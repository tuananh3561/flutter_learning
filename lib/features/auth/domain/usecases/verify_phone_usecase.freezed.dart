// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_phone_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyPhoneParams _$VerifyPhoneParamsFromJson(Map<String, dynamic> json) {
  return _VerifyPhoneParams.fromJson(json);
}

/// @nodoc
mixin _$VerifyPhoneParams {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  /// Serializes this VerifyPhoneParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyPhoneParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyPhoneParamsCopyWith<VerifyPhoneParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyPhoneParamsCopyWith<$Res> {
  factory $VerifyPhoneParamsCopyWith(
          VerifyPhoneParams value, $Res Function(VerifyPhoneParams) then) =
      _$VerifyPhoneParamsCopyWithImpl<$Res, VerifyPhoneParams>;
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class _$VerifyPhoneParamsCopyWithImpl<$Res, $Val extends VerifyPhoneParams>
    implements $VerifyPhoneParamsCopyWith<$Res> {
  _$VerifyPhoneParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyPhoneParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyPhoneParamsImplCopyWith<$Res>
    implements $VerifyPhoneParamsCopyWith<$Res> {
  factory _$$VerifyPhoneParamsImplCopyWith(_$VerifyPhoneParamsImpl value,
          $Res Function(_$VerifyPhoneParamsImpl) then) =
      __$$VerifyPhoneParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class __$$VerifyPhoneParamsImplCopyWithImpl<$Res>
    extends _$VerifyPhoneParamsCopyWithImpl<$Res, _$VerifyPhoneParamsImpl>
    implements _$$VerifyPhoneParamsImplCopyWith<$Res> {
  __$$VerifyPhoneParamsImplCopyWithImpl(_$VerifyPhoneParamsImpl _value,
      $Res Function(_$VerifyPhoneParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyPhoneParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_$VerifyPhoneParamsImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyPhoneParamsImpl implements _VerifyPhoneParams {
  const _$VerifyPhoneParamsImpl({required this.phone, required this.otp});

  factory _$VerifyPhoneParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyPhoneParamsImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;

  @override
  String toString() {
    return 'VerifyPhoneParams(phone: $phone, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyPhoneParamsImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp);

  /// Create a copy of VerifyPhoneParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyPhoneParamsImplCopyWith<_$VerifyPhoneParamsImpl> get copyWith =>
      __$$VerifyPhoneParamsImplCopyWithImpl<_$VerifyPhoneParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyPhoneParamsImplToJson(
      this,
    );
  }
}

abstract class _VerifyPhoneParams implements VerifyPhoneParams {
  const factory _VerifyPhoneParams(
      {required final String phone,
      required final String otp}) = _$VerifyPhoneParamsImpl;

  factory _VerifyPhoneParams.fromJson(Map<String, dynamic> json) =
      _$VerifyPhoneParamsImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;

  /// Create a copy of VerifyPhoneParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyPhoneParamsImplCopyWith<_$VerifyPhoneParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
