// lib/features/auth/domain/usecases/verify_phone_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

@injectable
class VerifyPhoneUseCase implements UseCase<bool, VerifyPhoneParams> {
  final RegistrationRepository repository;

  VerifyPhoneUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyPhoneParams params) {
    return repository.verifyOtp(params.phone, params.otp);
  }
}

class VerifyPhoneParams extends Equatable {
  final String phone;
  final String otp;

  const VerifyPhoneParams({
    required this.phone,
    required this.otp,
  });

  @override
  List<Object> get props => [phone, otp];
}
