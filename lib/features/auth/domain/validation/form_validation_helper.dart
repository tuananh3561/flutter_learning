// lib/features/auth/domain/validation/form_validation_helper.dart
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../usecases/validate_field_usecase.dart';

@injectable
class FormValidationHelper {
  final ValidateFieldUseCase validateFieldUseCase;

  FormValidationHelper(this.validateFieldUseCase);

  /// Validates multiple fields at once and returns a map of field names to error messages
  Future<Map<String, String>> validateForm(
      Map<String, String> fieldValues) async {
    final errors = <String, String>{};

    for (final entry in fieldValues.entries) {
      final fieldName = entry.key;
      final value = entry.value;

      final result = await validateFieldUseCase(
        ValidateFieldParams(fieldName: fieldName, value: value),
      );

      result.fold(
        (failure) {
          if (failure is ValidationFailure) {
            errors[fieldName] = failure.message;
          }
        },
        (_) => null, // No error for this field
      );
    }

    return errors;
  }

  /// Validates a single field and returns an error message if validation fails
  Future<String?> validateField(String fieldName, String value) async {
    final result = await validateFieldUseCase(
      ValidateFieldParams(fieldName: fieldName, value: value),
    );

    return result.fold(
      (failure) =>
          failure is ValidationFailure ? failure.message : 'Validation error',
      (_) => null, // No error
    );
  }

  /// Performs phone number formatting and validation
  Future<String?> validateAndFormatPhone(String phone) async {
    // Remove any non-digit characters except plus sign at the beginning
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Validate the clean phone
    return validateField('phone', cleanPhone);
  }

  /// Validates password strength
  Future<Map<String, bool>> checkPasswordStrength(String password) async {
    return {
      'hasMinLength': password.length >= 8,
      'hasLetter': RegExp(r'[a-zA-Z]').hasMatch(password),
      'hasNumber': RegExp(r'[0-9]').hasMatch(password),
      'hasSpecialChar': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
    };
  }
}
