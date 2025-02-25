// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_usecase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterParamsImpl _$$RegisterParamsImplFromJson(Map<String, dynamic> json) =>
    _$RegisterParamsImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      deviceId: json['deviceId'] as String,
      deviceModel: json['deviceModel'] as String?,
      deviceType: json['deviceType'] as String?,
    );

Map<String, dynamic> _$$RegisterParamsImplToJson(
        _$RegisterParamsImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'name': instance.name,
      'deviceId': instance.deviceId,
      'deviceModel': instance.deviceModel,
      'deviceType': instance.deviceType,
    };
