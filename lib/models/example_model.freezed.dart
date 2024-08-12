// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExampleModel _$ExampleModelFromJson(Map<String, dynamic> json) {
  return _ExampleModel.fromJson(json);
}

/// @nodoc
mixin _$ExampleModel {
  String? get id => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference<Object?>? get reference =>
      throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentSnapshot<Object?>? get snapshot => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ExampleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExampleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExampleModelCopyWith<ExampleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExampleModelCopyWith<$Res> {
  factory $ExampleModelCopyWith(
          ExampleModel value, $Res Function(ExampleModel) then) =
      _$ExampleModelCopyWithImpl<$Res, ExampleModel>;
  @useResult
  $Res call(
      {String? id,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DocumentReference<Object?>? reference,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DocumentSnapshot<Object?>? snapshot,
      String name,
      String email});
}

/// @nodoc
class _$ExampleModelCopyWithImpl<$Res, $Val extends ExampleModel>
    implements $ExampleModelCopyWith<$Res> {
  _$ExampleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExampleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reference = freezed,
    Object? snapshot = freezed,
    Object? name = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      snapshot: freezed == snapshot
          ? _value.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as DocumentSnapshot<Object?>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExampleModelImplCopyWith<$Res>
    implements $ExampleModelCopyWith<$Res> {
  factory _$$ExampleModelImplCopyWith(
          _$ExampleModelImpl value, $Res Function(_$ExampleModelImpl) then) =
      __$$ExampleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DocumentReference<Object?>? reference,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DocumentSnapshot<Object?>? snapshot,
      String name,
      String email});
}

/// @nodoc
class __$$ExampleModelImplCopyWithImpl<$Res>
    extends _$ExampleModelCopyWithImpl<$Res, _$ExampleModelImpl>
    implements _$$ExampleModelImplCopyWith<$Res> {
  __$$ExampleModelImplCopyWithImpl(
      _$ExampleModelImpl _value, $Res Function(_$ExampleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExampleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reference = freezed,
    Object? snapshot = freezed,
    Object? name = null,
    Object? email = null,
  }) {
    return _then(_$ExampleModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      snapshot: freezed == snapshot
          ? _value.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as DocumentSnapshot<Object?>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExampleModelImpl extends _ExampleModel {
  const _$ExampleModelImpl(
      {this.id,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.reference,
      @JsonKey(includeFromJson: false, includeToJson: false) this.snapshot,
      required this.name,
      required this.email})
      : super._();

  factory _$ExampleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExampleModelImplFromJson(json);

  @override
  final String? id;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Object?>? reference;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentSnapshot<Object?>? snapshot;
  @override
  final String name;
  @override
  final String email;

  @override
  String toString() {
    return 'ExampleModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, reference: $reference, snapshot: $snapshot, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExampleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, createdAt, updatedAt, reference, snapshot, name, email);

  /// Create a copy of ExampleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExampleModelImplCopyWith<_$ExampleModelImpl> get copyWith =>
      __$$ExampleModelImplCopyWithImpl<_$ExampleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExampleModelImplToJson(
      this,
    );
  }
}

abstract class _ExampleModel extends ExampleModel {
  const factory _ExampleModel(
      {final String? id,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final DocumentReference<Object?>? reference,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final DocumentSnapshot<Object?>? snapshot,
      required final String name,
      required final String email}) = _$ExampleModelImpl;
  const _ExampleModel._() : super._();

  factory _ExampleModel.fromJson(Map<String, dynamic> json) =
      _$ExampleModelImpl.fromJson;

  @override
  String? get id;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference<Object?>? get reference;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentSnapshot<Object?>? get snapshot;
  @override
  String get name;
  @override
  String get email;

  /// Create a copy of ExampleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExampleModelImplCopyWith<_$ExampleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
