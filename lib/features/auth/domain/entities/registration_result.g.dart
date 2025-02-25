// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationResultImpl _$$RegistrationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResultImpl(
      success: json['success'] as bool,
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$RegistrationResultImplToJson(
        _$RegistrationResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'user': instance.user,
      'message': instance.message,
      'token': instance.token,
    };
