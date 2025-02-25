// lib/features/auth/domain/usecases/check_registration_status_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

@injectable
class CheckRegistrationStatusUseCase
    implements UseCase<RegistrationStatus, NoParams> {
  final RegistrationRepository repository;

  CheckRegistrationStatusUseCase(this.repository);

  @override
  Future<Either<Failure, RegistrationStatus>> call(NoParams params) async {
    try {
      // Check if registration is in progress
      final isInProgressEither = await repository.isRegistrationInProgress();

      final bool isInProgress = isInProgressEither.fold(
        (failure) => false,
        (isInProgress) => isInProgress,
      );

      if (!isInProgress) {
        return const Right(RegistrationStatus(
          isInProgress: false,
          isPhoneVerified: false,
        ));
      }

      // Check if phone is verified
      final isPhoneVerifiedEither = await repository.isPhoneVerified();

      final bool isPhoneVerified = isPhoneVerifiedEither.fold(
        (failure) => false,
        (isVerified) => isVerified,
      );

      return Right(RegistrationStatus(
        isInProgress: isInProgress,
        isPhoneVerified: isPhoneVerified,
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

class RegistrationStatus {
  final bool isInProgress;
  final bool isPhoneVerified;

  const RegistrationStatus({
    required this.isInProgress,
    required this.isPhoneVerified,
  });
}
