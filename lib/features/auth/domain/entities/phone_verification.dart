// lib/features/auth/domain/entities/phone_verification.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification.freezed.dart';
part 'phone_verification.g.dart';

@freezed
class PhoneVerification with _$PhoneVerification {
  const factory PhoneVerification({
    required String phone,
    required bool isVerified,
    String? verificationId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? requestedAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? verifiedAt,
  }) = _PhoneVerification;

  // Add JSON serialization
  factory PhoneVerification.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerificationFromJson(json);
}

// Helper methods to handle DateTime serialization
DateTime? _dateTimeFromJson(String? date) {
  return date == null ? null : DateTime.parse(date);
}

String? _dateTimeToJson(DateTime? date) {
  return date?.toIso8601String();
}
