// lib/features/auth/domain/usecases/register_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/registration_result.dart';
import '../repositories/registration_repository.dart';

part 'register_user_usecase.freezed.dart';
part 'register_user_usecase.g.dart';

@injectable
class RegisterUserUseCase
    implements UseCase<RegistrationResult, RegisterParams> {
  final RegistrationRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, RegistrationResult>> call(RegisterParams params) {
    return repository.register(
      phone: params.phone,
      password: params.password,
      name: params.name,
      deviceId: params.deviceId,
      deviceModel: params.deviceModel,
      deviceType: params.deviceType,
    );
  }
}

@freezed
class RegisterParams with _$RegisterParams {
  const factory RegisterParams({
    required String phone,
    required String password,
    required String name,
    required String deviceId,
    String? deviceModel,
    String? deviceType,
  }) = _RegisterParams;

  factory RegisterParams.fromJson(Map<String, dynamic> json) =>
      _$RegisterParamsFromJson(json);
}
