// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestModelImpl _$$RegistrationRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestModelImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      deviceId: json['deviceId'] as String,
      deviceModel: json['deviceModel'] as String?,
      deviceType: json['deviceType'] as String?,
    );

Map<String, dynamic> _$$RegistrationRequestModelImplToJson(
        _$RegistrationRequestModelImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'name': instance.name,
      'deviceId': instance.deviceId,
      'deviceModel': instance.deviceModel,
      'deviceType': instance.deviceType,
    };
