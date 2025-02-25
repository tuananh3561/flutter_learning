// lib/features/auth/data/repositories/registration_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/registration_result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_local_datasource.dart';
import '../datasources/registration_remote_datasource.dart';
import '../models/registration_request_model.dart';
import '../models/user_profile_model.dart';

@Injectable(as: RegistrationRepository)
class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;
  final RegistrationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RegistrationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RegistrationResult>> register({
    required String phone,
    required String password,
    required String name,
    required String deviceId,
    String? deviceModel,
    String? deviceType,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final requestModel = RegistrationRequestModel(
        phone: phone,
        password: password,
        name: name,
        deviceId: deviceId,
        deviceModel: deviceModel,
        deviceType: deviceType,
      );

      // Cache the registration data first
      await localDataSource.cacheRegistrationData(requestModel);

      final response = await remoteDataSource.register(requestModel);

      if (response.success) {
        // If registration successful, save tokens
        if (response.token != null && response.refreshToken != null) {
          await localDataSource.saveAuthTokens(
            response.token!,
            response.refreshToken!,
          );
        }

        // Cache user profile if available
        if (response.user != null) {
          final userProfileModel = UserProfileModel(
            id: response.user!.id,
            phone: response.user!.phone,
            name: response.user!.name,
            email: response.user!.email,
            avatar: response.user!.avatar,
            isActive: response.user!.isActive,
          );
          await localDataSource.cacheUserProfile(userProfileModel);
        }

        return Right(
          RegistrationResult(
            success: true,
            user: response.user != null
                ? UserProfile(
                    id: response.user!.id,
                    phone: response.user!.phone,
                    name: response.user!.name,
                    email: response.user!.email,
                    avatar: response.user!.avatar,
                    isActive: response.user!.isActive,
                  )
                : null,
            message: response.message,
            token: response.token,
          ),
        );
      } else {
        return Right(
          RegistrationResult(
            success: false,
            message: response.message ?? 'Registration failed',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestOtp(String phone) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.requestOtp(phone);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String phone, String otp) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.verifyOtp(phone, otp);

      if (result) {
        await localDataSource.savePhoneVerificationStatus(true);
      }

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> createProfile(
      UserProfile profile, String token) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final profileModel = UserProfileModel.fromEntity(profile);
      final result = await remoteDataSource.createProfile(profileModel, token);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPhoneVerified() async {
    try {
      final isVerified = await localDataSource.getPhoneVerificationStatus();
      return Right(isVerified);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isRegistrationInProgress() async {
    try {
      final isInProgress = await localDataSource.isRegistrationInitiated();
      return Right(isInProgress);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearRegistrationData() async {
    try {
      await localDataSource.clearRegistrationData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
