import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// Encapsulates the result of an API call, holding either data or an error message.
class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResult._({this.data, this.errorMessage, required this.isSuccess});

  factory ApiResult.success(T data) {
    return ApiResult._(data: data, isSuccess: true);
  }

  factory ApiResult.failure(String? errorMessage) {
    return ApiResult._(errorMessage: errorMessage, isSuccess: false);
  }

  /// Returns true if the call was not successful (data is not present).
  bool get isFailure => !isSuccess;
}

/// An abstract base class for repositories that interact with REST APIs and/or Firestore.
abstract class BaseRepository {
  final http.Client? client;
  final String? baseUrl;
  final FirebaseFirestore? firestore;
  final FirebasePerformance _performance = FirebasePerformance.instance;

  static int _totalReadCount = 0;
  static int _totalWriteCount = 0;
  int _readCount = 0;
  int _writeCount = 0;

  int get firestoreReads => _readCount;
  int get firestoreWrites => _writeCount;
  static int get totalFirestoreReads => _totalReadCount;
  static int get totalFirestoreWrites => _totalWriteCount;

  BaseRepository({this.client, this.baseUrl, this.firestore}) {
    if (client == null && firestore == null) {
      throw ArgumentError(
          'At least one of client or firestore must be provided');
    }
    if (client != null && baseUrl == null) {
      throw ArgumentError('baseUrl must be provided when client is set');
    }
  }

  /// Retrieves the authentication token from Firebase Auth.
  Future<String> getAuthToken() async {
    return (await FirebaseAuth.instance.currentUser!.getIdToken())!;
  }

  /// Returns the default HTTP headers for API requests.
  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      };

  /// Builds headers for API requests, including custom headers and optionally an authentication token.
  Future<Map<String, String>> _buildHeaders(
      Map<String, String>? customHeaders, bool includeAuthToken) async {
    final headers = {...defaultHeaders};
    if (includeAuthToken) {
      headers['auth-token'] = await getAuthToken();
    }
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  /// Sends a generic HTTP request and parses the response.
  Future<ApiResult<T>> _sendRequest<T>(
      Future<http.Response> Function() requestFunction,
      T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await requestFunction();
      if (response.statusCode == 200) {
        final data = fromJson(json.decode(response.body));
        return ApiResult<T>.success(data);
      } else {
        developer.log(
            'API call failed: ${response.statusCode} ${response.body}',
            error: response.statusCode);
        return ApiResult<T>.failure('Error: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      developer.log('Exception during API call: $e',
          error: e, stackTrace: stacktrace);
      return ApiResult<T>.failure(e.toString());
    }
  }

  /// Executes a GET request to the specified [path] and parses the response.
  Future<ApiResult<T>> get<T>(
      String path, T Function(Map<String, dynamic>) fromJson,
      {Map<String, String>? customHeaders,
      bool includeAuthToken = false}) async {
    _ensureClientExists();
    final headers = await _buildHeaders(customHeaders, includeAuthToken);
    return _sendRequest(
        () => client!.get(Uri.parse('$baseUrl$path'), headers: headers),
        fromJson);
  }

  /// Executes a POST request to the specified [path] with the given [body] and parses the response.
  Future<ApiResult<T>> post<T>(String path, Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson,
      {Map<String, String>? customHeaders,
      bool includeAuthToken = false}) async {
    _ensureClientExists();
    final headers = await _buildHeaders(customHeaders, includeAuthToken);
    return _sendRequest(
        () => client!.post(Uri.parse('$baseUrl$path'),
            body: json.encode(body), headers: headers),
        fromJson);
  }

  /// Executes a PUT request to the specified [path] with the given [body] and parses the response.
  Future<ApiResult<T>> put<T>(String path, Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson,
      {Map<String, String>? customHeaders,
      bool includeAuthToken = false}) async {
    _ensureClientExists();
    final headers = await _buildHeaders(customHeaders, includeAuthToken);
    return _sendRequest(
        () => client!.put(Uri.parse('$baseUrl$path'),
            body: json.encode(body), headers: headers),
        fromJson);
  }

  /// Creates a trace for Firestore operations
  Trace _getTrace(String operationType) {
    return _performance.newTrace('firestore_$operationType');
  }

  /// Increments the read count
  void _incrementReadCount([int count = 1]) {
    _readCount += count;
    _totalReadCount += count;
  }

  /// Increments the write count
  void _incrementWriteCount() {
    _writeCount++;
    _totalWriteCount++;
  }

  /// Increments a specific trace in Firebase Performance
  void _incrementTrace(String traceName, int incrementBy) {
    final trace = _performance.newTrace(traceName);
    trace.start();
    trace.incrementMetric('count', incrementBy);
    trace.stop();
  }

  /// Fetches a document from Firestore and parses it.
  Future<ApiResult<T>> getDocument<T>(
    String collectionPath,
    String documentId,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore,
  ) async {
    _ensureFirestoreExists();
    final trace = _getTrace('read');
    await trace.start();
    return _firestoreOperation(() async {
      final docRef =
          firestore!.collection(collectionPath).doc(documentId).withConverter(
                fromFirestore: fromFirestore,
                toFirestore: toFirestore,
              );
      final docSnapshot = await docRef.get();
      _incrementReadCount();
      trace.incrementMetric('document_reads', 1);
      if (!docSnapshot.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Document does not exist',
          code: 'document-not-found',
        );
      }
      await trace.stop();
      return docSnapshot.data()!;
    });
  }

  /// Fetches a collection of documents from Firestore and parses them.
  Future<ApiResult<List<T>>> getCollection<T>(
    String collectionPath,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore, {
    Query<T> Function(Query<T>)? queryBuilder,
    int? limit,
  }) async {
    _ensureFirestoreExists();
    final trace = _getTrace('read');
    await trace.start();
    return _firestoreOperation(() async {
      Query<T> query = firestore!.collection(collectionPath).withConverter(
            fromFirestore: fromFirestore,
            toFirestore: toFirestore,
          );
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      final querySnapshot = await query.get();
      _incrementReadCount(querySnapshot.size);
      trace.incrementMetric('collection_reads', 1);
      trace.incrementMetric('documents_read', querySnapshot.size);
      await trace.stop();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Adds a new document to a Firestore collection.
  Future<ApiResult<String>> addDocument<T>(
    String collectionPath,
    T data,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore,
  ) async {
    _ensureFirestoreExists();
    final trace = _getTrace('write');
    await trace.start();
    return _firestoreOperation(() async {
      final collectionRef = firestore!.collection(collectionPath).withConverter(
            fromFirestore: fromFirestore,
            toFirestore: toFirestore,
          );
      final docRef = await collectionRef.add(data);
      _incrementWriteCount();
      trace.incrementMetric('document_writes', 1);
      await trace.stop();
      return docRef.id;
    });
  }

  /// Sets a document in Firestore.
  Future<ApiResult<void>> setDocument<T>(
    String collectionPath,
    String documentId,
    T data,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore, {
    bool merge = false,
  }) async {
    _ensureFirestoreExists();
    final trace = _getTrace('write');
    await trace.start();
    return _firestoreOperation(() async {
      final docRef =
          firestore!.collection(collectionPath).doc(documentId).withConverter(
                fromFirestore: fromFirestore,
                toFirestore: toFirestore,
              );
      await docRef.set(data, SetOptions(merge: merge));
      _incrementWriteCount();
      trace.incrementMetric('document_writes', 1);
      await trace.stop();
    });
  }

  /// Updates a document in Firestore.
  Future<ApiResult<void>> updateDocument<T>(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    _ensureFirestoreExists();
    final trace = _getTrace('write');
    await trace.start();
    return _firestoreOperation(() async {
      await firestore!.collection(collectionPath).doc(documentId).update(data);
      _incrementWriteCount();
      trace.incrementMetric('document_writes', 1);
      await trace.stop();
    });
  }

  /// Deletes a document from Firestore.
  Future<ApiResult<void>> deleteDocument(
    String collectionPath,
    String documentId,
  ) async {
    _ensureFirestoreExists();
    final trace = _getTrace('delete');
    await trace.start();
    return _firestoreOperation(() async {
      await firestore!.collection(collectionPath).doc(documentId).delete();
      _incrementWriteCount();
      trace.incrementMetric('document_deletes', 1);
      await trace.stop();
    });
  }

  /// Subscribes to a document in Firestore, providing real-time updates.
  Stream<ApiResult<T>> streamDocument<T>(
    String collectionPath,
    String documentId,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore,
  ) {
    _ensureFirestoreExists();
    final docRef =
        firestore!.collection(collectionPath).doc(documentId).withConverter(
              fromFirestore: fromFirestore,
              toFirestore: toFirestore,
            );

    return docRef.snapshots().map((snapshot) {
      _incrementReadCount();
      _incrementTrace('firestore_stream_reads', 1);

      if (!snapshot.exists) {
        return ApiResult<T>.failure('Document not found');
      }
      return ApiResult<T>.success(snapshot.data()!);
    }).handleError((e, stacktrace) {
      developer.log('Exception during Firestore stream operation: $e',
          error: e, stackTrace: stacktrace);
      return ApiResult<T>.failure(e.toString());
    });
  }

  /// Subscribes to a collection in Firestore, providing real-time updates.
  Stream<ApiResult<List<T>>> streamCollection<T>(
    String collectionPath,
    T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
        fromFirestore,
    Map<String, Object?> Function(T, SetOptions?) toFirestore, {
    Query<T> Function(Query<T>)? queryBuilder,
    int? limit,
  }) {
    _ensureFirestoreExists();
    Query<T> query = firestore!.collection(collectionPath).withConverter(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      _incrementReadCount(snapshot.docChanges.length);
      _incrementTrace('firestore_stream_reads', 1);
      _incrementTrace(
          'firestore_stream_documents_read', snapshot.docChanges.length);

      final documents = snapshot.docs.map((doc) => doc.data()).toList();
      return ApiResult<List<T>>.success(documents);
    }).handleError((e, stacktrace) {
      developer.log('Exception during Firestore stream operation: $e',
          error: e, stackTrace: stacktrace);
      return ApiResult<List<T>>.failure(e.toString());
    });
  }

  /// Executes a transaction in Firestore.
  Future<ApiResult<T>> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler,
  ) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      return await firestore!.runTransaction(transactionHandler);
    });
  }

  /// Executes a batch write operation in Firestore.
  Future<ApiResult<void>> writeBatch(
      void Function(WriteBatch) batchHandler) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      final batch = firestore!.batch();
      batchHandler(batch);
      await batch.commit();
    });
  }

  /// Executes Firestore operations and handles exceptions.
  Future<ApiResult<T>> _firestoreOperation<T>(
      Future<T> Function() firestoreFunction) async {
    try {
      final data = await firestoreFunction();
      return ApiResult<T>.success(data);
    } on FirebaseException catch (e, stacktrace) {
      developer.log(
          'FirebaseException during Firestore operation: ${e.message}',
          error: e,
          stackTrace: stacktrace);
      return ApiResult<T>.failure(e.message);
    } catch (e, stacktrace) {
      developer.log('Exception during Firestore operation: $e',
          error: e, stackTrace: stacktrace);
      return ApiResult<T>.failure(e.toString());
    }
  }

  void _ensureClientExists() {
    if (client == null) {
      throw StateError('HTTP client is not initialized');
    }
  }

  void _ensureFirestoreExists() {
    if (firestore == null) {
      throw StateError('Firestore is not initialized');
    }
  }

  /// Gets the current analytics data
  Map<String, int> getAnalyticsData() {
    return {
      'read_count': _readCount,
      'write_count': _writeCount,
      'total_read_count': _totalReadCount,
      'total_write_count': _totalWriteCount,
    };
  }

  /// Gets the total analytics data across all instances
  static Map<String, int> getTotalAnalyticsData() {
    return {
      'total_read_count': _totalReadCount,
      'total_write_count': _totalWriteCount,
    };
  }
}
