import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_event.freezed.dart';

@freezed
class RegistrationEvent with _$RegistrationEvent {
  const factory RegistrationEvent.initialize() = InitializeRegistrationEvent;

  const factory RegistrationEvent.updatePhone(String phone) = UpdatePhoneEvent;

  const factory RegistrationEvent.updatePassword(String password) =
      UpdatePasswordEvent;

  const factory RegistrationEvent.updateName(String name) = UpdateNameEvent;

  const factory RegistrationEvent.updateDeviceInfo({
    required String deviceId,
    String? deviceModel,
    String? deviceType,
  }) = UpdateDeviceInfoEvent;

  const factory RegistrationEvent.validateForm() = ValidateFormEvent;

  const factory RegistrationEvent.submitRegistration() =
      SubmitRegistrationEvent;

  const factory RegistrationEvent.requestOtp() = RequestOtpEvent;

  const factory RegistrationEvent.updateOtp(String otp) = UpdateOtpEvent;

  const factory RegistrationEvent.verifyOtp() = VerifyOtpEvent;

  const factory RegistrationEvent.clearRegistration() = ClearRegistrationEvent;
}
