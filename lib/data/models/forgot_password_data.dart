import 'package:equatable/equatable.dart';

import 'auth_data.dart';

/// Các bước trong forgot password flow
enum ForgotPasswordStep {
  navigator,
  phone,
  email,
  otp,
  updatePassword,
}

/// Phương thức khôi phục mật khẩu
enum RecoveryMethod {
  sms,
  email,
}

/// Trạng thái OTP
enum OTPState {
  unfilled,
  filled,
  success,
}

/// Trạng thái update password
enum UpdatePasswordState {
  unfilled,
  filled,
  success,
}

/// Data model cho forgot password flow
class ForgotPasswordData extends Equatable {
  const ForgotPasswordData({
    this.step = ForgotPasswordStep.navigator,
    this.recoveryMethod,
    this.phoneNumber = '',
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.phoneValidation = const FormFieldValidation(),
    this.emailValidation = const FormFieldValidation(),
    this.otpValidation = const FormFieldValidation(),
    this.passwordValidation = const FormFieldValidation(),
    this.confirmPasswordValidation = const FormFieldValidation(),
    this.otpState = OTPState.unfilled,
    this.updatePasswordState = UpdatePasswordState.unfilled,
  });

  final ForgotPasswordStep step;
  final RecoveryMethod? recoveryMethod;
  final String phoneNumber;
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final FormFieldValidation phoneValidation;
  final FormFieldValidation emailValidation;
  final FormFieldValidation otpValidation;
  final FormFieldValidation passwordValidation;
  final FormFieldValidation confirmPasswordValidation;
  final OTPState otpState;
  final UpdatePasswordState updatePasswordState;

  /// Kiểm tra phone number có hợp lệ không
  bool get isPhoneValid => phoneValidation.state == ValidationState.valid;

  /// Kiểm tra email có hợp lệ không
  bool get isEmailValid => emailValidation.state == ValidationState.valid;

  /// Kiểm tra OTP có hợp lệ không
  bool get isOTPValid => otpValidation.state == ValidationState.valid;

  /// Kiểm tra new password có hợp lệ không
  bool get isNewPasswordValid =>
      passwordValidation.state == ValidationState.valid;

  /// Kiểm tra confirm password có hợp lệ không
  bool get isConfirmPasswordValid =>
      confirmPasswordValidation.state == ValidationState.valid;

  /// Kiểm tra có thể tiếp tục từ navigator không
  bool get canContinueFromNavigator => recoveryMethod != null;

  /// Kiểm tra có thể gửi OTP không
  bool get canSendOTP {
    switch (recoveryMethod) {
      case RecoveryMethod.sms:
        return isPhoneValid && phoneNumber.isNotEmpty;
      case RecoveryMethod.email:
        return isEmailValid && email.isNotEmpty;
      case null:
        return false;
    }
  }

  /// Kiểm tra có thể verify OTP không
  bool get canVerifyOTP => isOTPValid && otp.isNotEmpty;

  /// Kiểm tra có thể update password không
  bool get canUpdatePassword =>
      isNewPasswordValid &&
      isConfirmPasswordValid &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty;

  /// Lấy display text cho recovery method
  String get recoveryMethodDisplayText {
    switch (recoveryMethod) {
      case RecoveryMethod.sms:
        return 'SMS';
      case RecoveryMethod.email:
        return 'Email';
      case null:
        return '';
    }
  }

  /// Lấy contact info đã được format
  String get formattedContactInfo {
    switch (recoveryMethod) {
      case RecoveryMethod.sms:
        return '+84 ${phoneNumber.substring(1, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
      case RecoveryMethod.email:
        return email;
      case null:
        return '';
    }
  }

  ForgotPasswordData copyWith({
    ForgotPasswordStep? step,
    RecoveryMethod? recoveryMethod,
    String? phoneNumber,
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    FormFieldValidation? phoneValidation,
    FormFieldValidation? emailValidation,
    FormFieldValidation? otpValidation,
    FormFieldValidation? passwordValidation,
    FormFieldValidation? confirmPasswordValidation,
    OTPState? otpState,
    UpdatePasswordState? updatePasswordState,
  }) {
    return ForgotPasswordData(
      step: step ?? this.step,
      recoveryMethod: recoveryMethod ?? this.recoveryMethod,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneValidation: phoneValidation ?? this.phoneValidation,
      emailValidation: emailValidation ?? this.emailValidation,
      otpValidation: otpValidation ?? this.otpValidation,
      passwordValidation: passwordValidation ?? this.passwordValidation,
      confirmPasswordValidation:
          confirmPasswordValidation ?? this.confirmPasswordValidation,
      otpState: otpState ?? this.otpState,
      updatePasswordState: updatePasswordState ?? this.updatePasswordState,
    );
  }

  @override
  List<Object?> get props => [
        step,
        recoveryMethod,
        phoneNumber,
        email,
        otp,
        newPassword,
        confirmPassword,
        phoneValidation,
        emailValidation,
        otpValidation,
        passwordValidation,
        confirmPasswordValidation,
        otpState,
        updatePasswordState,
      ];
}
