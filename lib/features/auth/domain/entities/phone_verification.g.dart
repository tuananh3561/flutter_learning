// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneVerificationImpl _$$PhoneVerificationImplFromJson(
        Map<String, dynamic> json) =>
    _$PhoneVerificationImpl(
      phone: json['phone'] as String,
      isVerified: json['isVerified'] as bool,
      verificationId: json['verificationId'] as String?,
      requestedAt: _dateTimeFromJson(json['requestedAt'] as String?),
      verifiedAt: _dateTimeFromJson(json['verifiedAt'] as String?),
    );

Map<String, dynamic> _$$PhoneVerificationImplToJson(
        _$PhoneVerificationImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'isVerified': instance.isVerified,
      'verificationId': instance.verificationId,
      'requestedAt': _dateTimeToJson(instance.requestedAt),
      'verifiedAt': _dateTimeToJson(instance.verifiedAt),
    };
