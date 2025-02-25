// lib/features/auth/domain/usecases/request_otp_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

@injectable
class RequestOtpUseCase implements UseCase<bool, String> {
  final RegistrationRepository repository;

  RequestOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String phone) {
    return repository.requestOtp(phone);
  }
}
