/// Data model cho thay đổi mật khẩu
class ChangePasswordData {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final ChangePasswordValidation validation;

  const ChangePasswordData({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.validation,
  });

  ChangePasswordData copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    ChangePasswordValidation? validation,
  }) {
    return ChangePasswordData(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      validation: validation ?? this.validation,
    );
  }

  /// Check if form is valid
  bool get isValid => validation.isValid;

  /// Check if save button should be enabled
  bool get canSave =>
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      isValid;

  /// Sample data with empty fields
  static ChangePasswordData getSampleData() {
    return ChangePasswordData(
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
      validation: ChangePasswordValidation.initial(),
    );
  }
}

/// Validation state cho change password
class ChangePasswordValidation {
  final String? currentPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const ChangePasswordValidation({
    this.currentPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
  });

  /// Check if all fields are valid
  bool get isValid =>
      currentPasswordError == null &&
      newPasswordError == null &&
      confirmPasswordError == null;

  /// Initial state (no errors)
  static ChangePasswordValidation initial() {
    return ChangePasswordValidation();
  }

  /// Current password error state
  static ChangePasswordValidation withCurrentPasswordError(String error) {
    return ChangePasswordValidation(currentPasswordError: error);
  }

  /// New password error state
  static ChangePasswordValidation withNewPasswordError(String error) {
    return ChangePasswordValidation(newPasswordError: error);
  }

  /// Confirm password error state
  static ChangePasswordValidation withConfirmPasswordError(String error) {
    return ChangePasswordValidation(confirmPasswordError: error);
  }

  /// Multiple errors state
  static ChangePasswordValidation withMultipleErrors({
    String? currentPasswordError,
    String? newPasswordError,
    String? confirmPasswordError,
  }) {
    return ChangePasswordValidation(
      currentPasswordError: currentPasswordError,
      newPasswordError: newPasswordError,
      confirmPasswordError: confirmPasswordError,
    );
  }

  /// Validate password data
  static ChangePasswordValidation validateData(ChangePasswordData data) {
    String? currentPasswordError;
    String? newPasswordError;
    String? confirmPasswordError;

    // Validate current password
    if (data.currentPassword.isEmpty) {
      currentPasswordError = 'Vui lòng nhập mật khẩu hiện tại';
    } else if (data.currentPassword.length < 6) {
      currentPasswordError = 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    // Validate new password
    if (data.newPassword.isEmpty) {
      newPasswordError = 'Vui lòng nhập mật khẩu mới';
    } else if (data.newPassword.length < 6) {
      newPasswordError = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else if (data.newPassword == data.currentPassword) {
      newPasswordError = 'Mật khẩu mới phải khác mật khẩu hiện tại';
    }

    // Validate confirm password
    if (data.confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
    } else if (data.confirmPassword != data.newPassword) {
      confirmPasswordError = 'Mật khẩu xác nhận không khớp';
    }

    return ChangePasswordValidation.withMultipleErrors(
      currentPasswordError: currentPasswordError,
      newPasswordError: newPasswordError,
      confirmPasswordError: confirmPasswordError,
    );
  }
}
