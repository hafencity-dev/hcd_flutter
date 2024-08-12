// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExampleModelImpl _$$ExampleModelImplFromJson(Map<String, dynamic> json) =>
    _$ExampleModelImpl(
      id: json['id'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ExampleModelImplToJson(_$ExampleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'name': instance.name,
      'email': instance.email,
    };
