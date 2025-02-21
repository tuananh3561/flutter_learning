import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_datasource.dart';
import '../datasources/splash_remote_datasource.dart';
import '../../domain/entities/device_info.dart';
import '../../../../core/error/failures.dart';

@Injectable(as: SplashRepository)
class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource _localDataSource;
  final SplashRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  SplashRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, DeviceInfo>> initializeDevice() async {
    try {
      // Check for existing device info
      final localDeviceInfo = await _localDataSource.getDeviceInfo();

      if (localDeviceInfo != null) {
        return Right(DeviceInfo(
          deviceId: localDeviceInfo.deviceId,
          isFirstTime: localDeviceInfo.isFirstTime,
        ));
      }

      // No existing device info, need to register
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      // Generate new device ID
      final deviceId = const Uuid().v4();

      // Register with backend
      final remoteDeviceInfo = await _remoteDataSource.registerDevice(deviceId);

      // Save to local storage
      await _localDataSource.saveDeviceInfo(remoteDeviceInfo);

      return Right(DeviceInfo(
        deviceId: remoteDeviceInfo.deviceId,
        isFirstTime: true,
      ));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFirstTime() async {
    try {
      final isFirstTime = await _localDataSource.isFirstTime();
      return Right(isFirstTime);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AuthStatus>> checkAuthStatus() async {
    try {
      final token = await _localDataSource.getAuthToken();
      return Right(AuthStatus(
        isAuthenticated: token != null,
        token: token,
      ));
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
