// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationResponseModelImpl _$$RegistrationResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResponseModelImpl(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : UserModel2.fromJson(json['user'] as Map<String, dynamic>),
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$RegistrationResponseModelImplToJson(
        _$RegistrationResponseModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'success': instance.success,
      'message': instance.message,
    };

_$UserModel2Impl _$$UserModel2ImplFromJson(Map<String, dynamic> json) =>
    _$UserModel2Impl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$UserModel2ImplToJson(_$UserModel2Impl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
    };
