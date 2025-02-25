// lib/features/auth/domain/usecases/register_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/registration_result.dart';
import '../repositories/registration_repository.dart';

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

class RegisterParams extends Equatable {
  final String phone;
  final String password;
  final String name;
  final String deviceId;
  final String? deviceModel;
  final String? deviceType;

  const RegisterParams({
    required this.phone,
    required this.password,
    required this.name,
    required this.deviceId,
    this.deviceModel,
    this.deviceType,
  });

  @override
  List<Object?> get props =>
      [phone, password, name, deviceId, deviceModel, deviceType];
}
