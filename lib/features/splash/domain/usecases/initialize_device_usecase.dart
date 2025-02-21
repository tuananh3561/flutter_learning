import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_info.dart';
import '../repositories/splash_repository.dart';

@injectable
class InitializeDeviceUseCase {
  final SplashRepository _repository;

  InitializeDeviceUseCase(this._repository);

  Future<Either<Failure, DeviceInfo>> call() async {
    return await _repository.initializeDevice();
  }
}
