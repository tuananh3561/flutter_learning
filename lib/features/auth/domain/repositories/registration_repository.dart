// lib/features/auth/domain/repositories/registration_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/registration_result.dart';
import '../entities/user_profile.dart';

abstract class RegistrationRepository {
  /// Registers a new user with the provided details.
  ///
  /// Returns [RegistrationResult] if successful, [Failure] otherwise.
  Future<Either<Failure, RegistrationResult>> register({
    required String phone,
    required String password,
    required String name,
    required String deviceId,
    String? deviceModel,
    String? deviceType,
  });

  /// Requests an OTP code for the provided phone number.
  ///
  /// Returns [bool] indicating success or failure, [Failure] on error.
  Future<Either<Failure, bool>> requestOtp(String phone);

  /// Verifies the OTP code for the provided phone number.
  ///
  /// Returns [bool] indicating success or failure, [Failure] on error.
  Future<Either<Failure, bool>> verifyOtp(String phone, String otp);

  /// Creates a user profile after successful registration.
  ///
  /// Returns [UserProfile] if successful, [Failure] otherwise.
  Future<Either<Failure, UserProfile>> createProfile(
      UserProfile profile, String token);

  /// Checks if the phone verification process has been completed.
  ///
  /// Returns [bool] indicating if verified, [Failure] on error.
  Future<Either<Failure, bool>> isPhoneVerified();

  /// Checks if there's a registration process currently in progress.
  ///
  /// Returns [bool] indicating if in progress, [Failure] on error.
  Future<Either<Failure, bool>> isRegistrationInProgress();

  /// Clears all registration-related data from local storage.
  ///
  /// Returns [void] if successful, [Failure] otherwise.
  Future<Either<Failure, void>> clearRegistrationData();
}
