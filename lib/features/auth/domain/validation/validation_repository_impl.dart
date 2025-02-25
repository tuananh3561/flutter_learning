import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/validation_rule.dart';
import '../repositories/validation_repository.dart';
import 'field_validator.dart';
import 'validation_rules.dart';

@Injectable(as: ValidationRepository)
class ValidationRepositoryImpl implements ValidationRepository {
  final FieldValidator validator;

  ValidationRepositoryImpl(this.validator);

  @override
  Either<Failure, bool> validateField(
      String value, List<ValidationRule> rules) {
    return validator.validate(value, rules);
  }

  @override
  List<ValidationRule> getRulesForField(String fieldName) {
    switch (fieldName) {
      case 'phone':
        return RegistrationValidationRules.phoneRules;
      case 'password':
        return RegistrationValidationRules.passwordRules;
      case 'name':
        return RegistrationValidationRules.nameRules;
      case 'otp':
        return RegistrationValidationRules.otpRules;
      default:
        return [];
    }
  }
}
