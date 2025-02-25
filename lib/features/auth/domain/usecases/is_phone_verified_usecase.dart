import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

@injectable
class IsPhoneVerifiedUseCase implements UseCase<bool, NoParams> {
  final RegistrationRepository repository;

  IsPhoneVerifiedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isPhoneVerified();
  }
}
