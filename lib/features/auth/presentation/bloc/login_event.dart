import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.phoneChanged(String phone) = PhoneChanged;
  const factory LoginEvent.passwordChanged(String password) = PasswordChanged;
  const factory LoginEvent.loginSubmitted() = LoginSubmitted;
  const factory LoginEvent.validatePhone() = ValidatePhone;
  const factory LoginEvent.validatePassword() = ValidatePassword;
}
