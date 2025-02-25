import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/validation_rule.dart';

abstract class ValidationRepository {
  /// Validates a field against a set of rules
  Either<Failure, bool> validateField(String value, List<ValidationRule> rules);

  /// Gets validation rules for a specific field
  List<ValidationRule> getRulesForField(String fieldName);
}
