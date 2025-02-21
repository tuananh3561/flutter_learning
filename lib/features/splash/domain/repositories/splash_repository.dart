import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_info.dart';
import '../entities/auth_status.dart';

abstract class SplashRepository {
  /// Initializes device and returns device information
  Future<Either<Failure, DeviceInfo>> initializeDevice();

  /// Checks if this is the first time app is launched
  Future<Either<Failure, bool>> isFirstTime();

  /// Checks authentication status
  Future<Either<Failure, AuthStatus>> checkAuthStatus();
}
