import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository _authRepository;

  CheckAuthStatusUseCase(this._authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _authRepository.isLoggedIn();
  }
}
