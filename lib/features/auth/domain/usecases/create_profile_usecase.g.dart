// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_usecase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateProfileParamsImpl _$$CreateProfileParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateProfileParamsImpl(
      profile: const _UserProfileConverter()
          .fromJson(json['profile'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$$CreateProfileParamsImplToJson(
        _$CreateProfileParamsImpl instance) =>
    <String, dynamic>{
      'profile': const _UserProfileConverter().toJson(instance.profile),
      'token': instance.token,
    };
