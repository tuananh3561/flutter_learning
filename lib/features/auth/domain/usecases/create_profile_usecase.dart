// lib/features/auth/domain/usecases/create_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/registration_repository.dart';

@injectable
class CreateProfileUseCase
    implements UseCase<UserProfile, CreateProfileParams> {
  final RegistrationRepository repository;

  CreateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(CreateProfileParams params) {
    return repository.createProfile(params.profile, params.token);
  }
}

class CreateProfileParams extends Equatable {
  final UserProfile profile;
  final String token;

  const CreateProfileParams({
    required this.profile,
    required this.token,
  });

  @override
  List<Object> get props => [profile, token];
}
