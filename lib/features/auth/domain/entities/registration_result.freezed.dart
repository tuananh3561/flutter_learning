// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationResult _$RegistrationResultFromJson(Map<String, dynamic> json) {
  return _RegistrationResult.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResult {
  bool get success => throw _privateConstructorUsedError;
  UserProfile? get user => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  /// Serializes this RegistrationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationResultCopyWith<RegistrationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResultCopyWith<$Res> {
  factory $RegistrationResultCopyWith(
          RegistrationResult value, $Res Function(RegistrationResult) then) =
      _$RegistrationResultCopyWithImpl<$Res, RegistrationResult>;
  @useResult
  $Res call({bool success, UserProfile? user, String? message, String? token});

  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class _$RegistrationResultCopyWithImpl<$Res, $Val extends RegistrationResult>
    implements $RegistrationResultCopyWith<$Res> {
  _$RegistrationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationResultImplCopyWith<$Res>
    implements $RegistrationResultCopyWith<$Res> {
  factory _$$RegistrationResultImplCopyWith(_$RegistrationResultImpl value,
          $Res Function(_$RegistrationResultImpl) then) =
      __$$RegistrationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, UserProfile? user, String? message, String? token});

  @override
  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class __$$RegistrationResultImplCopyWithImpl<$Res>
    extends _$RegistrationResultCopyWithImpl<$Res, _$RegistrationResultImpl>
    implements _$$RegistrationResultImplCopyWith<$Res> {
  __$$RegistrationResultImplCopyWithImpl(_$RegistrationResultImpl _value,
      $Res Function(_$RegistrationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? token = freezed,
  }) {
    return _then(_$RegistrationResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResultImpl implements _RegistrationResult {
  const _$RegistrationResultImpl(
      {required this.success, this.user, this.message, this.token});

  factory _$RegistrationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationResultImplFromJson(json);

  @override
  final bool success;
  @override
  final UserProfile? user;
  @override
  final String? message;
  @override
  final String? token;

  @override
  String toString() {
    return 'RegistrationResult(success: $success, user: $user, message: $message, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, user, message, token);

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResultImplCopyWith<_$RegistrationResultImpl> get copyWith =>
      __$$RegistrationResultImplCopyWithImpl<_$RegistrationResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResultImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResult implements RegistrationResult {
  const factory _RegistrationResult(
      {required final bool success,
      final UserProfile? user,
      final String? message,
      final String? token}) = _$RegistrationResultImpl;

  factory _RegistrationResult.fromJson(Map<String, dynamic> json) =
      _$RegistrationResultImpl.fromJson;

  @override
  bool get success;
  @override
  UserProfile? get user;
  @override
  String? get message;
  @override
  String? get token;

  /// Create a copy of RegistrationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationResultImplCopyWith<_$RegistrationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
