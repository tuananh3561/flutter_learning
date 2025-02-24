import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/phone_validator.dart';

@injectable
class ValidatePhoneUseCase {
  final PhoneValidator _validator;

  ValidatePhoneUseCase(this._validator);

  Either<Failure, String> call(String phone) {
    if (_validator.isValid(phone)) {
      return Right(_validator.normalize(phone));
    } else {
      return Left(ValidationFailure('Số điện thoại không hợp lệ'));
    }
  }
}
