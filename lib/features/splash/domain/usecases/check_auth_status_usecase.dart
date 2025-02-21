import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_status.dart';
import '../repositories/splash_repository.dart';

@injectable
class CheckAuthStatusUseCase {
  final SplashRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<Either<Failure, AuthStatus>> call() async {
    return await _repository.checkAuthStatus();
  }
}
