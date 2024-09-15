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
    }
    throw ArgumentError('Unsupported timestamp format: $value');
  }

  @override
  dynamic toJson(DateTime? date) => date?.toIso8601String();
}
