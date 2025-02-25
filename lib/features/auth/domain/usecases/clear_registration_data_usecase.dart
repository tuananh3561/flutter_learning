import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/registration_repository.dart';

@injectable
class ClearRegistrationDataUseCase implements UseCase<void, NoParams> {
  final RegistrationRepository repository;

  ClearRegistrationDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearRegistrationData();
  }
}
