/// Data model cho thông tin người dùng trong parent settings
class ParentUserInfo {
  final String name;
  final String phoneNumber;
  final String email;
  final ParentUserInfoValidation validation;

  const ParentUserInfo({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.validation,
  });

  ParentUserInfo copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    ParentUserInfoValidation? validation,
  }) {
    return ParentUserInfo(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      validation: validation ?? this.validation,
    );
  }

  /// Sample data với validation state bình thường
  static ParentUserInfo getSampleData() {
    return ParentUserInfo(
      name: 'Họ và tên ba mẹ',
      phoneNumber: '+84 123 456 789',
      email: 'abc@xyz.com',
      validation: ParentUserInfoValidation.valid(),
    );
  }

  /// Sample data với name quá dài
  static ParentUserInfo getSampleDataWithLongName() {
    return ParentUserInfo(
      name: 'Just Híu TwoKayyzzzzzzzzzzzzzzz',
      phoneNumber: '+84 123 456 789',
      email: 'abc@xyz.com',
      validation:
          ParentUserInfoValidation.withNameError('Số ký tự vượt quá 50 ký tự'),
    );
  }

  /// Sample data với email không hợp lệ
  static ParentUserInfo getSampleDataWithInvalidEmail() {
    return ParentUserInfo(
      name: 'Just Híu TwoKayy',
      phoneNumber: '+84 123 456 789',
      email: 'trunghieutran.com',
      validation: ParentUserInfoValidation.withEmailError('Email không hợp lệ'),
    );
  }
}

/// Validation state cho user info
class ParentUserInfoValidation {
  final String? nameError;
  final String? phoneError;
  final String? emailError;

  const ParentUserInfoValidation({
    this.nameError,
    this.phoneError,
    this.emailError,
  });

  bool get isValid =>
      nameError == null && phoneError == null && emailError == null;

  /// Valid state
  static ParentUserInfoValidation valid() {
    return const ParentUserInfoValidation();
  }

  /// Name error state
  static ParentUserInfoValidation withNameError(String error) {
    return ParentUserInfoValidation(nameError: error);
  }

  /// Phone error state
  static ParentUserInfoValidation withPhoneError(String error) {
    return ParentUserInfoValidation(phoneError: error);
  }

  /// Email error state
  static ParentUserInfoValidation withEmailError(String error) {
    return ParentUserInfoValidation(emailError: error);
  }

  ParentUserInfoValidation copyWith({
    String? nameError,
    String? phoneError,
    String? emailError,
  }) {
    return ParentUserInfoValidation(
      nameError: nameError ?? this.nameError,
      phoneError: phoneError ?? this.phoneError,
      emailError: emailError ?? this.emailError,
    );
  }
}
