import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/phone_validator.dart';
import '../repositories/password_validator.dart';

class LoginParams {
  final String phoneNumber;
  final String password;
  final String deviceId;

  LoginParams({
    required this.phoneNumber,
    required this.password,
    required this.deviceId,
  });
}

@injectable
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _authRepository;
  final PhoneValidator _phoneValidator;
  final PasswordValidator _passwordValidator;

  LoginUseCase(
    this._authRepository,
    this._phoneValidator,
    this._passwordValidator,
  );

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validate phone number
    if (!_phoneValidator.isValid(params.phoneNumber)) {
      return Left(ValidationFailure('Số điện thoại không hợp lệ'));
    }

    // Validate password
    if (!_passwordValidator.isValid(params.password)) {
      return Left(ValidationFailure('Mật khẩu không hợp lệ'));
    }

    // Normalize phone number before sending to repository
    final normalizedPhone = _phoneValidator.normalize(params.phoneNumber);

    return _authRepository.login(
      phoneNumber: normalizedPhone,
      password: params.password,
      deviceId: params.deviceId,
    );
  }
}
