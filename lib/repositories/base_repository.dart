import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ///
  /// [customHeaders]: Additional headers to include in the request.
  /// [includeAuthToken]: Whether to include the authentication token in the headers.
  ///
  /// Returns a map of headers.
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
  ///
  /// [requestFunction]: The HTTP request function to execute.
  /// [fromJson]: A function to parse the JSON response into a model of type [T].
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
  ///
  /// [path]: The API endpoint to send the GET request to.
  /// [fromJson]: A function to parse the JSON response into a model of type [T].
  /// [customHeaders]: Additional headers to include in the request.
  /// [includeAuthToken]: Whether to include the authentication token in the headers.
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
  ///
  /// [path]: The API endpoint to send the POST request to.
  /// [body]: The body of the POST request.
  /// [fromJson]: A function to parse the JSON response into a model of type [T].
  /// [customHeaders]: Additional headers to include in the request.
  /// [includeAuthToken]: Whether to include the authentication token in the headers.
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
  ///
  /// [path]: The API endpoint to send the PUT request to.
  /// [body]: The body of the PUT request.
  /// [fromJson]: A function to parse the JSON response into a model of type [T].
  /// [customHeaders]: Additional headers to include in the request.
  /// [includeAuthToken]: Whether to include the authentication token in the headers.
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

  /// Fetches a document from Firestore and parses it.
  Future<ApiResult<T>> getDocument<T>(
    String collectionPath,
    String documentId,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      final docSnapshot =
          await firestore!.collection(collectionPath).doc(documentId).get();
      if (!docSnapshot.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Document does not exist',
          code: 'document-not-found',
        );
      }
      final data = docSnapshot.data()! as Map<String, dynamic>;
      // Add document ID to the map if not already present
      if (!data.containsKey('id')) {
        data['id'] = docSnapshot.id;
      }
      return fromJson(data);
    });
  }

  /// Fetches a collection of documents from Firestore and parses them.
  Future<ApiResult<List<T>>> getCollection<T>(
    String collectionPath,
    T Function(Map<String, dynamic>) fromJson, {
    Query Function(Query)? queryBuilder,
    int? limit,
  }) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      Query query = firestore!.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      if (limit != null) {
        query = query.limit(limit);
      }
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Add document ID to the map if not already present
        if (!data.containsKey('id')) {
          data['id'] = doc.id;
        }
        return fromJson(data);
      }).toList();
    });
  }

  /// Adds a new document to a Firestore collection.
  Future<ApiResult<String>> addDocument<T>(
    String collectionPath,
    T data,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      final docRef =
          await firestore!.collection(collectionPath).add(toJson(data));
      return docRef.id;
    });
  }

  /// Sets a document in Firestore.
  Future<ApiResult<void>> setDocument<T>(
    String collectionPath,
    String documentId,
    T data,
    Map<String, dynamic> Function(T) toJson, {
    bool merge = false,
  }) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      await firestore!
          .collection(collectionPath)
          .doc(documentId)
          .set(toJson(data), SetOptions(merge: merge));
    });
  }

  /// Updates a document in Firestore.
  Future<ApiResult<void>> updateDocument<T>(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      await firestore!.collection(collectionPath).doc(documentId).update(data);
    });
  }

  /// Deletes a document from Firestore.
  Future<ApiResult<void>> deleteDocument(
    String collectionPath,
    String documentId,
  ) async {
    _ensureFirestoreExists();
    return _firestoreOperation(() async {
      await firestore!.collection(collectionPath).doc(documentId).delete();
    });
  }

  /// Subscribes to a document in Firestore, providing real-time updates.
  Stream<ApiResult<T>> streamDocument<T>(
    String collectionPath,
    String documentId,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    _ensureFirestoreExists();
    return firestore!
        .collection(collectionPath)
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return ApiResult<T>.failure('Document not found');
      }
      final data = snapshot.data()! as Map<String, dynamic>;
      // Add document ID to the map if not already present
      if (!data.containsKey('id')) {
        data['id'] = snapshot.id;
      }
      return ApiResult<T>.success(fromJson(data));
    }).handleError((e, stacktrace) {
      developer.log('Exception during Firestore stream operation: $e',
          error: e, stackTrace: stacktrace);
      return ApiResult<T>.failure(e.toString());
    });
  }

  /// Subscribes to a collection in Firestore, providing real-time updates.
  Stream<ApiResult<List<T>>> streamCollection<T>(
    String collectionPath,
    T Function(Map<String, dynamic>) fromJson, {
    Query Function(Query)? queryBuilder,
    int? limit,
  }) {
    _ensureFirestoreExists();
    Query query = firestore!.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      final documents = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Add document ID to the map if not already present
        if (!data.containsKey('id')) {
          data['id'] = doc.id;
        }
        return fromJson(data);
      }).toList();
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
}
