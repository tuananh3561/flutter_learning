import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/password_validator.dart';

@injectable
class ValidatePasswordUseCase {
  final PasswordValidator _validator;

  ValidatePasswordUseCase(this._validator);

  Either<Failure, Unit> call(String password) {
    final errors = _validator.getValidationErrors(password);
    if (errors.isEmpty) {
      return const Right(unit);
    } else {
      return Left(ValidationFailure(errors.join(', ')));
    }
  }
}
