import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/splash_repository.dart';

@injectable
class CheckFirstTimeUseCase {
  final SplashRepository _repository;

  CheckFirstTimeUseCase(this._repository);

  Future<Either<Failure, bool>> call() async {
    return await _repository.isFirstTime();
  }
}
