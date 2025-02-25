// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validate_field_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidateFieldParams _$ValidateFieldParamsFromJson(Map<String, dynamic> json) {
  return _ValidateFieldParams.fromJson(json);
}

/// @nodoc
mixin _$ValidateFieldParams {
  String get fieldName => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this ValidateFieldParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValidateFieldParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidateFieldParamsCopyWith<ValidateFieldParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidateFieldParamsCopyWith<$Res> {
  factory $ValidateFieldParamsCopyWith(
          ValidateFieldParams value, $Res Function(ValidateFieldParams) then) =
      _$ValidateFieldParamsCopyWithImpl<$Res, ValidateFieldParams>;
  @useResult
  $Res call({String fieldName, String value});
}

/// @nodoc
class _$ValidateFieldParamsCopyWithImpl<$Res, $Val extends ValidateFieldParams>
    implements $ValidateFieldParamsCopyWith<$Res> {
  _$ValidateFieldParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidateFieldParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidateFieldParamsImplCopyWith<$Res>
    implements $ValidateFieldParamsCopyWith<$Res> {
  factory _$$ValidateFieldParamsImplCopyWith(_$ValidateFieldParamsImpl value,
          $Res Function(_$ValidateFieldParamsImpl) then) =
      __$$ValidateFieldParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fieldName, String value});
}

/// @nodoc
class __$$ValidateFieldParamsImplCopyWithImpl<$Res>
    extends _$ValidateFieldParamsCopyWithImpl<$Res, _$ValidateFieldParamsImpl>
    implements _$$ValidateFieldParamsImplCopyWith<$Res> {
  __$$ValidateFieldParamsImplCopyWithImpl(_$ValidateFieldParamsImpl _value,
      $Res Function(_$ValidateFieldParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidateFieldParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? value = null,
  }) {
    return _then(_$ValidateFieldParamsImpl(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidateFieldParamsImpl implements _ValidateFieldParams {
  const _$ValidateFieldParamsImpl(
      {required this.fieldName, required this.value});

  factory _$ValidateFieldParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidateFieldParamsImplFromJson(json);

  @override
  final String fieldName;
  @override
  final String value;

  @override
  String toString() {
    return 'ValidateFieldParams(fieldName: $fieldName, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidateFieldParamsImpl &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fieldName, value);

  /// Create a copy of ValidateFieldParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidateFieldParamsImplCopyWith<_$ValidateFieldParamsImpl> get copyWith =>
      __$$ValidateFieldParamsImplCopyWithImpl<_$ValidateFieldParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidateFieldParamsImplToJson(
      this,
    );
  }
}

abstract class _ValidateFieldParams implements ValidateFieldParams {
  const factory _ValidateFieldParams(
      {required final String fieldName,
      required final String value}) = _$ValidateFieldParamsImpl;

  factory _ValidateFieldParams.fromJson(Map<String, dynamic> json) =
      _$ValidateFieldParamsImpl.fromJson;

  @override
  String get fieldName;
  @override
  String get value;

  /// Create a copy of ValidateFieldParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidateFieldParamsImplCopyWith<_$ValidateFieldParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
