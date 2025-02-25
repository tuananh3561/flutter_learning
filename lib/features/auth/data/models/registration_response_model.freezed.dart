// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationResponseModel _$RegistrationResponseModelFromJson(
    Map<String, dynamic> json) {
  return _RegistrationResponseModel.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResponseModel {
  String? get token => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  UserModel2? get user => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this RegistrationResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationResponseModelCopyWith<RegistrationResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResponseModelCopyWith<$Res> {
  factory $RegistrationResponseModelCopyWith(RegistrationResponseModel value,
          $Res Function(RegistrationResponseModel) then) =
      _$RegistrationResponseModelCopyWithImpl<$Res, RegistrationResponseModel>;
  @useResult
  $Res call(
      {String? token,
      String? refreshToken,
      UserModel2? user,
      bool success,
      String? message});

  $UserModel2CopyWith<$Res>? get user;
}

/// @nodoc
class _$RegistrationResponseModelCopyWithImpl<$Res,
        $Val extends RegistrationResponseModel>
    implements $RegistrationResponseModelCopyWith<$Res> {
  _$RegistrationResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel2?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModel2CopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModel2CopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationResponseModelImplCopyWith<$Res>
    implements $RegistrationResponseModelCopyWith<$Res> {
  factory _$$RegistrationResponseModelImplCopyWith(
          _$RegistrationResponseModelImpl value,
          $Res Function(_$RegistrationResponseModelImpl) then) =
      __$$RegistrationResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? token,
      String? refreshToken,
      UserModel2? user,
      bool success,
      String? message});

  @override
  $UserModel2CopyWith<$Res>? get user;
}

/// @nodoc
class __$$RegistrationResponseModelImplCopyWithImpl<$Res>
    extends _$RegistrationResponseModelCopyWithImpl<$Res,
        _$RegistrationResponseModelImpl>
    implements _$$RegistrationResponseModelImplCopyWith<$Res> {
  __$$RegistrationResponseModelImplCopyWithImpl(
      _$RegistrationResponseModelImpl _value,
      $Res Function(_$RegistrationResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_$RegistrationResponseModelImpl(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel2?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResponseModelImpl implements _RegistrationResponseModel {
  const _$RegistrationResponseModelImpl(
      {this.token,
      this.refreshToken,
      this.user,
      required this.success,
      this.message});

  factory _$RegistrationResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationResponseModelImplFromJson(json);

  @override
  final String? token;
  @override
  final String? refreshToken;
  @override
  final UserModel2? user;
  @override
  final bool success;
  @override
  final String? message;

  @override
  String toString() {
    return 'RegistrationResponseModel(token: $token, refreshToken: $refreshToken, user: $user, success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResponseModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, refreshToken, user, success, message);

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResponseModelImplCopyWith<_$RegistrationResponseModelImpl>
      get copyWith => __$$RegistrationResponseModelImplCopyWithImpl<
          _$RegistrationResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResponseModelImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResponseModel implements RegistrationResponseModel {
  const factory _RegistrationResponseModel(
      {final String? token,
      final String? refreshToken,
      final UserModel2? user,
      required final bool success,
      final String? message}) = _$RegistrationResponseModelImpl;

  factory _RegistrationResponseModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationResponseModelImpl.fromJson;

  @override
  String? get token;
  @override
  String? get refreshToken;
  @override
  UserModel2? get user;
  @override
  bool get success;
  @override
  String? get message;

  /// Create a copy of RegistrationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationResponseModelImplCopyWith<_$RegistrationResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserModel2 _$UserModel2FromJson(Map<String, dynamic> json) {
  return _UserModel2.fromJson(json);
}

/// @nodoc
mixin _$UserModel2 {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel2 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModel2CopyWith<UserModel2> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModel2CopyWith<$Res> {
  factory $UserModel2CopyWith(
          UserModel2 value, $Res Function(UserModel2) then) =
      _$UserModel2CopyWithImpl<$Res, UserModel2>;
  @useResult
  $Res call(
      {String id,
      String phone,
      String name,
      String? email,
      String? avatar,
      bool isActive,
      String? createdAt});
}

/// @nodoc
class _$UserModel2CopyWithImpl<$Res, $Val extends UserModel2>
    implements $UserModel2CopyWith<$Res> {
  _$UserModel2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModel2ImplCopyWith<$Res>
    implements $UserModel2CopyWith<$Res> {
  factory _$$UserModel2ImplCopyWith(
          _$UserModel2Impl value, $Res Function(_$UserModel2Impl) then) =
      __$$UserModel2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phone,
      String name,
      String? email,
      String? avatar,
      bool isActive,
      String? createdAt});
}

/// @nodoc
class __$$UserModel2ImplCopyWithImpl<$Res>
    extends _$UserModel2CopyWithImpl<$Res, _$UserModel2Impl>
    implements _$$UserModel2ImplCopyWith<$Res> {
  __$$UserModel2ImplCopyWithImpl(
      _$UserModel2Impl _value, $Res Function(_$UserModel2Impl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserModel2Impl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModel2Impl implements _UserModel2 {
  const _$UserModel2Impl(
      {required this.id,
      required this.phone,
      required this.name,
      this.email,
      this.avatar,
      required this.isActive,
      this.createdAt});

  factory _$UserModel2Impl.fromJson(Map<String, dynamic> json) =>
      _$$UserModel2ImplFromJson(json);

  @override
  final String id;
  @override
  final String phone;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  final bool isActive;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'UserModel2(id: $id, phone: $phone, name: $name, email: $email, avatar: $avatar, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModel2Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, phone, name, email, avatar, isActive, createdAt);

  /// Create a copy of UserModel2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModel2ImplCopyWith<_$UserModel2Impl> get copyWith =>
      __$$UserModel2ImplCopyWithImpl<_$UserModel2Impl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModel2ImplToJson(
      this,
    );
  }
}

abstract class _UserModel2 implements UserModel2 {
  const factory _UserModel2(
      {required final String id,
      required final String phone,
      required final String name,
      final String? email,
      final String? avatar,
      required final bool isActive,
      final String? createdAt}) = _$UserModel2Impl;

  factory _UserModel2.fromJson(Map<String, dynamic> json) =
      _$UserModel2Impl.fromJson;

  @override
  String get id;
  @override
  String get phone;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  bool get isActive;
  @override
  String? get createdAt;

  /// Create a copy of UserModel2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModel2ImplCopyWith<_$UserModel2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
