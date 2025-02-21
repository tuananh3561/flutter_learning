// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceInfoModelImpl _$$DeviceInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceInfoModelImpl(
      deviceId: json['deviceId'] as String,
      isFirstTime: json['isFirstTime'] as bool,
      lastLoginDate: json['lastLoginDate'] as String?,
    );

Map<String, dynamic> _$$DeviceInfoModelImplToJson(
        _$DeviceInfoModelImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'isFirstTime': instance.isFirstTime,
      'lastLoginDate': instance.lastLoginDate,
    };
