import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/login_request_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
    required String deviceId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final request = LoginRequestModel(
        phoneNumber: phoneNumber,
        password: password,
        deviceId: deviceId,
      );

      final response = await _remoteDataSource.login(request);

      // Save tokens
      await _localDataSource.saveAuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Right(response.user.toDomain());
    } catch (e) {
      return Left(ServerFailure('Login failed'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAuthTokens();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _localDataSource.getAccessToken();
      return Right(token != null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
