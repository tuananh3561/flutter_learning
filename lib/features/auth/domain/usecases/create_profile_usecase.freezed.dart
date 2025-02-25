// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_profile_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateProfileParams _$CreateProfileParamsFromJson(Map<String, dynamic> json) {
  return _CreateProfileParams.fromJson(json);
}

/// @nodoc
mixin _$CreateProfileParams {
  @_UserProfileConverter()
  UserProfile get profile => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  /// Serializes this CreateProfileParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateProfileParamsCopyWith<CreateProfileParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProfileParamsCopyWith<$Res> {
  factory $CreateProfileParamsCopyWith(
          CreateProfileParams value, $Res Function(CreateProfileParams) then) =
      _$CreateProfileParamsCopyWithImpl<$Res, CreateProfileParams>;
  @useResult
  $Res call({@_UserProfileConverter() UserProfile profile, String token});

  $UserProfileCopyWith<$Res> get profile;
}

/// @nodoc
class _$CreateProfileParamsCopyWithImpl<$Res, $Val extends CreateProfileParams>
    implements $CreateProfileParamsCopyWith<$Res> {
  _$CreateProfileParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get profile {
    return $UserProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateProfileParamsImplCopyWith<$Res>
    implements $CreateProfileParamsCopyWith<$Res> {
  factory _$$CreateProfileParamsImplCopyWith(_$CreateProfileParamsImpl value,
          $Res Function(_$CreateProfileParamsImpl) then) =
      __$$CreateProfileParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@_UserProfileConverter() UserProfile profile, String token});

  @override
  $UserProfileCopyWith<$Res> get profile;
}

/// @nodoc
class __$$CreateProfileParamsImplCopyWithImpl<$Res>
    extends _$CreateProfileParamsCopyWithImpl<$Res, _$CreateProfileParamsImpl>
    implements _$$CreateProfileParamsImplCopyWith<$Res> {
  __$$CreateProfileParamsImplCopyWithImpl(_$CreateProfileParamsImpl _value,
      $Res Function(_$CreateProfileParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? token = null,
  }) {
    return _then(_$CreateProfileParamsImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateProfileParamsImpl implements _CreateProfileParams {
  const _$CreateProfileParamsImpl(
      {@_UserProfileConverter() required this.profile, required this.token});

  factory _$CreateProfileParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProfileParamsImplFromJson(json);

  @override
  @_UserProfileConverter()
  final UserProfile profile;
  @override
  final String token;

  @override
  String toString() {
    return 'CreateProfileParams(profile: $profile, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProfileParamsImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, profile, token);

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProfileParamsImplCopyWith<_$CreateProfileParamsImpl> get copyWith =>
      __$$CreateProfileParamsImplCopyWithImpl<_$CreateProfileParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateProfileParamsImplToJson(
      this,
    );
  }
}

abstract class _CreateProfileParams implements CreateProfileParams {
  const factory _CreateProfileParams(
      {@_UserProfileConverter() required final UserProfile profile,
      required final String token}) = _$CreateProfileParamsImpl;

  factory _CreateProfileParams.fromJson(Map<String, dynamic> json) =
      _$CreateProfileParamsImpl.fromJson;

  @override
  @_UserProfileConverter()
  UserProfile get profile;
  @override
  String get token;

  /// Create a copy of CreateProfileParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProfileParamsImplCopyWith<_$CreateProfileParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
