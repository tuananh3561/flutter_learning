/// Data models for authentication
class SignInData {
  final String? phoneNumberOrUsername;
  final String? password;
  final String? deviceId;
  final String? activationCode;

  const SignInData({
    this.phoneNumberOrUsername,
    this.password,
    this.deviceId,
    this.activationCode,
  });

  SignInData copyWith({
    String? phoneNumberOrUsername,
    String? password,
    String? deviceId,
    String? activationCode,
  }) {
    return SignInData(
      phoneNumberOrUsername:
          phoneNumberOrUsername ?? this.phoneNumberOrUsername,
      password: password ?? this.password,
      deviceId: deviceId ?? this.deviceId,
      activationCode: activationCode ?? this.activationCode,
    );
  }

  bool get isValid =>
      phoneNumberOrUsername != null &&
      phoneNumberOrUsername!.isNotEmpty &&
      password != null &&
      password!.isNotEmpty;
}

/// Validation states for form fields
enum ValidationState {
  initial,
  valid,
  invalid,
  loading,
}

/// Form field validation data
class FormFieldValidation {
  final ValidationState state;
  final String? errorMessage;
  final String? value;

  const FormFieldValidation({
    this.state = ValidationState.initial,
    this.errorMessage,
    this.value,
  });

  FormFieldValidation copyWith({
    ValidationState? state,
    String? errorMessage,
    String? value,
  }) {
    return FormFieldValidation(
      state: state ?? this.state,
      errorMessage: errorMessage,
      value: value ?? this.value,
    );
  }

  bool get isValid => state == ValidationState.valid;
  bool get hasError => state == ValidationState.invalid;
}

/// Social login types
enum SocialLoginType {
  facebook,
  google,
  apple,
}

/// Social login data
class SocialLoginData {
  final SocialLoginType type;
  final String? token;
  final String? userId;
  final String? email;
  final String? name;

  const SocialLoginData({
    required this.type,
    this.token,
    this.userId,
    this.email,
    this.name,
  });
}

/// Authentication result
class AuthResult {
  final bool success;
  final String? token;
  final String? userId;
  final String? errorMessage;

  const AuthResult({
    required this.success,
    this.token,
    this.userId,
    this.errorMessage,
  });

  factory AuthResult.success({
    required String token,
    required String userId,
  }) {
    return AuthResult(
      success: true,
      token: token,
      userId: userId,
    );
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Defines the different steps in the sign up flow
enum SignUpStep {
  phone,
  password,
}

/// Data class for sign up information
class SignUpData {
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final SignUpStep currentStep;
  final FormFieldValidation phoneValidation;
  final FormFieldValidation passwordValidation;
  final FormFieldValidation confirmPasswordValidation;

  const SignUpData({
    this.phoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.currentStep = SignUpStep.phone,
    this.phoneValidation = const FormFieldValidation(),
    this.passwordValidation = const FormFieldValidation(),
    this.confirmPasswordValidation = const FormFieldValidation(),
  });

  SignUpData copyWith({
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    SignUpStep? currentStep,
    FormFieldValidation? phoneValidation,
    FormFieldValidation? passwordValidation,
    FormFieldValidation? confirmPasswordValidation,
  }) {
    return SignUpData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      currentStep: currentStep ?? this.currentStep,
      phoneValidation: phoneValidation ?? this.phoneValidation,
      passwordValidation: passwordValidation ?? this.passwordValidation,
      confirmPasswordValidation:
          confirmPasswordValidation ?? this.confirmPasswordValidation,
    );
  }

  bool get isPhoneValid => phoneValidation.state == ValidationState.valid;
  bool get isPasswordValid => passwordValidation.state == ValidationState.valid;
  bool get isConfirmPasswordValid =>
      confirmPasswordValidation.state == ValidationState.valid;

  bool get canProceedFromPhone => isPhoneValid && phoneNumber.isNotEmpty;
  bool get canProceedFromPassword =>
      isPasswordValid &&
      isConfirmPasswordValid &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;
}
