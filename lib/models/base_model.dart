import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class Model {
  Map<String, dynamic> toJson();
}

abstract class BaseModel extends Model {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, dynamic> toJson();
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is Map<String, dynamic>) {
      // Handle Firestore timestamp map format
      if (value.containsKey('_seconds') && value.containsKey('_nanoseconds')) {
        return Timestamp(
          value['_seconds'] as int,
          value['_nanoseconds'] as int,
        ).toDate();
      }
      // Handle standard timestamp map format
      if (value.containsKey('seconds') && value.containsKey('nanoseconds')) {
        return Timestamp(
          value['seconds'] as int,
          value['nanoseconds'] as int,
        ).toDate();
      }
    } else if (value is int) {
      // Handle Unix timestamp in milliseconds
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is double) {
      // Handle Unix timestamp in seconds with decimal places
      return DateTime.fromMillisecondsSinceEpoch((value * 1000).round());
    }
    throw ArgumentError('Unsupported timestamp format: $value');
  }

  @override
  dynamic toJson(DateTime? date) => date?.toIso8601String();
}
