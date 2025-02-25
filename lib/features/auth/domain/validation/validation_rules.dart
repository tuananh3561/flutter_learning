import '../entities/validation_rule.dart';

class RegistrationValidationRules {
  // Phone Validation Rules
  static List<ValidationRule> phoneRules = [
    const ValidationRule(
      type: ValidationType.required,
      message: 'Phone number is required',
    ),
    const ValidationRule(
      type: ValidationType.pattern,
      value: r'^([+]?[\s0-9]+)?(\d{10,12})$',
      message: 'Please enter a valid phone number',
    ),
  ];

  // Password Validation Rules
  static List<ValidationRule> passwordRules = [
    const ValidationRule(
      type: ValidationType.required,
      message: 'Password is required',
    ),
    const ValidationRule(
      type: ValidationType.minLength,
      value: 8,
      message: 'Password must be at least 8 characters',
    ),
    ValidationRule(
      type: ValidationType.custom,
      message: 'Password must contain at least one letter and one number',
      validator: (value) {
        final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
        final hasDigit = RegExp(r'[0-9]').hasMatch(value);
        return hasLetter && hasDigit;
      },
    ),
  ];

  // Name Validation Rules
  static List<ValidationRule> nameRules = [
    const ValidationRule(
      type: ValidationType.required,
      message: 'Name is required',
    ),
    const ValidationRule(
      type: ValidationType.minLength,
      value: 2,
      message: 'Name must be at least 2 characters',
    ),
  ];

  // OTP Validation Rules
  static List<ValidationRule> otpRules = [
    const ValidationRule(
      type: ValidationType.required,
      message: 'OTP code is required',
    ),
    ValidationRule(
      type: ValidationType.custom,
      message: 'OTP must be a valid digit code',
      validator: (value) {
        return RegExp(r'^\d{4,6}$').hasMatch(value);
      },
    ),
  ];
}
