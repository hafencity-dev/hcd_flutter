import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

@freezed
class ExampleModel with _$ExampleModel implements BaseModel {
  const ExampleModel._();

  const factory ExampleModel({
    String? id,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    DocumentReference? reference,
    @JsonKey(includeFromJson: false, includeToJson: false)
    DocumentSnapshot? snapshot,
    required String name,
    required String email,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);

  static ExampleModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return ExampleModel.fromJson({
      'id': doc.id,
      ...data ?? {},
    }).copyWith(reference: doc.reference, snapshot: doc);
  }

  ExampleModel copyWithTimestamp({bool updateCreatedAt = false}) {
    return copyWith(
      updatedAt: DateTime.now(),
      createdAt: updateCreatedAt ? DateTime.now() : createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}
