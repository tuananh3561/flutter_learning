import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/registration_result.dart';

part 'registration_state.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState.initial() = RegistrationInitial;

  const factory RegistrationState.loading() = RegistrationLoading;

  const factory RegistrationState.form({
    required Map<String, String> errors,
  }) = RegistrationForm;

  const factory RegistrationState.formFilled() = RegistrationFormFilled;

  const factory RegistrationState.error({
    required String message,
  }) = RegistrationError;

  const factory RegistrationState.success({
    required RegistrationResult result,
  }) = RegistrationSuccess;

  const factory RegistrationState.otpLoading() = OtpLoading;

  const factory RegistrationState.otpSent() = OtpSent;

  const factory RegistrationState.otpError({
    required String message,
  }) = OtpError;

  const factory RegistrationState.phoneVerified() = RegistrationPhoneVerified;
}
