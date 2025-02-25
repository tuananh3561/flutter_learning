// lib/features/auth/domain/entities/registration_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_profile.dart';

part 'registration_result.freezed.dart';
part 'registration_result.g.dart';

@freezed
class RegistrationResult with _$RegistrationResult {
  const factory RegistrationResult({
    required bool success,
    UserProfile? user,
    String? message,
    String? token,
  }) = _RegistrationResult;

  // Add JSON serialization
  factory RegistrationResult.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResultFromJson(json);
}
