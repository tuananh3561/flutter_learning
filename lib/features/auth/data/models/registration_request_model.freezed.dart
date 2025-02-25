// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationRequestModel _$RegistrationRequestModelFromJson(
    Map<String, dynamic> json) {
  return _RegistrationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RegistrationRequestModel {
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;
  String? get deviceType => throw _privateConstructorUsedError;

  /// Serializes this RegistrationRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationRequestModelCopyWith<RegistrationRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationRequestModelCopyWith<$Res> {
  factory $RegistrationRequestModelCopyWith(RegistrationRequestModel value,
          $Res Function(RegistrationRequestModel) then) =
      _$RegistrationRequestModelCopyWithImpl<$Res, RegistrationRequestModel>;
  @useResult
  $Res call(
      {String phone,
      String password,
      String name,
      String deviceId,
      String? deviceModel,
      String? deviceType});
}

/// @nodoc
class _$RegistrationRequestModelCopyWithImpl<$Res,
        $Val extends RegistrationRequestModel>
    implements $RegistrationRequestModelCopyWith<$Res> {
  _$RegistrationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? name = null,
    Object? deviceId = null,
    Object? deviceModel = freezed,
    Object? deviceType = freezed,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationRequestModelImplCopyWith<$Res>
    implements $RegistrationRequestModelCopyWith<$Res> {
  factory _$$RegistrationRequestModelImplCopyWith(
          _$RegistrationRequestModelImpl value,
          $Res Function(_$RegistrationRequestModelImpl) then) =
      __$$RegistrationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phone,
      String password,
      String name,
      String deviceId,
      String? deviceModel,
      String? deviceType});
}

/// @nodoc
class __$$RegistrationRequestModelImplCopyWithImpl<$Res>
    extends _$RegistrationRequestModelCopyWithImpl<$Res,
        _$RegistrationRequestModelImpl>
    implements _$$RegistrationRequestModelImplCopyWith<$Res> {
  __$$RegistrationRequestModelImplCopyWithImpl(
      _$RegistrationRequestModelImpl _value,
      $Res Function(_$RegistrationRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? name = null,
    Object? deviceId = null,
    Object? deviceModel = freezed,
    Object? deviceType = freezed,
  }) {
    return _then(_$RegistrationRequestModelImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationRequestModelImpl implements _RegistrationRequestModel {
  const _$RegistrationRequestModelImpl(
      {required this.phone,
      required this.password,
      required this.name,
      required this.deviceId,
      this.deviceModel,
      this.deviceType});

  factory _$RegistrationRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationRequestModelImplFromJson(json);

  @override
  final String phone;
  @override
  final String password;
  @override
  final String name;
  @override
  final String deviceId;
  @override
  final String? deviceModel;
  @override
  final String? deviceType;

  @override
  String toString() {
    return 'RegistrationRequestModel(phone: $phone, password: $password, name: $name, deviceId: $deviceId, deviceModel: $deviceModel, deviceType: $deviceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationRequestModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, phone, password, name, deviceId, deviceModel, deviceType);

  /// Create a copy of RegistrationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationRequestModelImplCopyWith<_$RegistrationRequestModelImpl>
      get copyWith => __$$RegistrationRequestModelImplCopyWithImpl<
          _$RegistrationRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _RegistrationRequestModel implements RegistrationRequestModel {
  const factory _RegistrationRequestModel(
      {required final String phone,
      required final String password,
      required final String name,
      required final String deviceId,
      final String? deviceModel,
      final String? deviceType}) = _$RegistrationRequestModelImpl;

  factory _RegistrationRequestModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationRequestModelImpl.fromJson;

  @override
  String get phone;
  @override
  String get password;
  @override
  String get name;
  @override
  String get deviceId;
  @override
  String? get deviceModel;
  @override
  String? get deviceType;

  /// Create a copy of RegistrationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationRequestModelImplCopyWith<_$RegistrationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
