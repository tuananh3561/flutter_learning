import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/validation_rule.dart';

@injectable
class FieldValidator {
  Either<Failure, bool> validate(String value, List<ValidationRule> rules) {
    final errors = <String>[];

    for (final rule in rules) {
      switch (rule.type) {
        case ValidationType.required:
          if (value.isEmpty) {
            errors.add(rule.message);
          }
          break;
        case ValidationType.minLength:
          if (value.length < rule.value) {
            errors.add(rule.message);
          }
          break;
        case ValidationType.maxLength:
          if (value.length > rule.value) {
            errors.add(rule.message);
          }
          break;
        case ValidationType.pattern:
          if (!RegExp(rule.value).hasMatch(value)) {
            errors.add(rule.message);
          }
          break;
        case ValidationType.custom:
          if (rule.validator != null && !rule.validator!(value)) {
            errors.add(rule.message);
          }
          break;
      }
    }

    if (errors.isNotEmpty) {
      return Left(ValidationFailure(errors.join(', ')));
    }

    return const Right(true);
  }
}
