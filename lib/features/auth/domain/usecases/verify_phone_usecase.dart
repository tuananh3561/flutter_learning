// lib/features/auth/domain/usecases/verify_phone_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

part 'verify_phone_usecase.freezed.dart';
part 'verify_phone_usecase.g.dart';

@injectable
class VerifyPhoneUseCase implements UseCase<bool, VerifyPhoneParams> {
  final RegistrationRepository repository;

  VerifyPhoneUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyPhoneParams params) {
    return repository.verifyOtp(params.phone, params.otp);
  }
}

@freezed
class VerifyPhoneParams with _$VerifyPhoneParams {
  const factory VerifyPhoneParams({
    required String phone,
    required String otp,
  }) = _VerifyPhoneParams;

  factory VerifyPhoneParams.fromJson(Map<String, dynamic> json) =>
      _$VerifyPhoneParamsFromJson(json);
}
