// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhoneVerification _$PhoneVerificationFromJson(Map<String, dynamic> json) {
  return _PhoneVerification.fromJson(json);
}

/// @nodoc
mixin _$PhoneVerification {
  String get phone => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get verificationId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get requestedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  /// Serializes this PhoneVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneVerificationCopyWith<PhoneVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneVerificationCopyWith<$Res> {
  factory $PhoneVerificationCopyWith(
          PhoneVerification value, $Res Function(PhoneVerification) then) =
      _$PhoneVerificationCopyWithImpl<$Res, PhoneVerification>;
  @useResult
  $Res call(
      {String phone,
      bool isVerified,
      String? verificationId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? requestedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? verifiedAt});
}

/// @nodoc
class _$PhoneVerificationCopyWithImpl<$Res, $Val extends PhoneVerification>
    implements $PhoneVerificationCopyWith<$Res> {
  _$PhoneVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? isVerified = null,
    Object? verificationId = freezed,
    Object? requestedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhoneVerificationImplCopyWith<$Res>
    implements $PhoneVerificationCopyWith<$Res> {
  factory _$$PhoneVerificationImplCopyWith(_$PhoneVerificationImpl value,
          $Res Function(_$PhoneVerificationImpl) then) =
      __$$PhoneVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phone,
      bool isVerified,
      String? verificationId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? requestedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? verifiedAt});
}

/// @nodoc
class __$$PhoneVerificationImplCopyWithImpl<$Res>
    extends _$PhoneVerificationCopyWithImpl<$Res, _$PhoneVerificationImpl>
    implements _$$PhoneVerificationImplCopyWith<$Res> {
  __$$PhoneVerificationImplCopyWithImpl(_$PhoneVerificationImpl _value,
      $Res Function(_$PhoneVerificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? isVerified = null,
    Object? verificationId = freezed,
    Object? requestedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$PhoneVerificationImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneVerificationImpl implements _PhoneVerification {
  const _$PhoneVerificationImpl(
      {required this.phone,
      required this.isVerified,
      this.verificationId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.requestedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.verifiedAt});

  factory _$PhoneVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneVerificationImplFromJson(json);

  @override
  final String phone;
  @override
  final bool isVerified;
  @override
  final String? verificationId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? requestedAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'PhoneVerification(phone: $phone, isVerified: $isVerified, verificationId: $verificationId, requestedAt: $requestedAt, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneVerificationImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verificationId, verificationId) ||
                other.verificationId == verificationId) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, phone, isVerified, verificationId, requestedAt, verifiedAt);

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneVerificationImplCopyWith<_$PhoneVerificationImpl> get copyWith =>
      __$$PhoneVerificationImplCopyWithImpl<_$PhoneVerificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneVerificationImplToJson(
      this,
    );
  }
}

abstract class _PhoneVerification implements PhoneVerification {
  const factory _PhoneVerification(
      {required final String phone,
      required final bool isVerified,
      final String? verificationId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? requestedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? verifiedAt}) = _$PhoneVerificationImpl;

  factory _PhoneVerification.fromJson(Map<String, dynamic> json) =
      _$PhoneVerificationImpl.fromJson;

  @override
  String get phone;
  @override
  bool get isVerified;
  @override
  String? get verificationId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get requestedAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get verifiedAt;

  /// Create a copy of PhoneVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneVerificationImplCopyWith<_$PhoneVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
