import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class BaseModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson();
}

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    throw ArgumentError('Unsupported timestamp format: $value');
  }

  @override
  dynamic toJson(DateTime date) => date.toIso8601String();
}
