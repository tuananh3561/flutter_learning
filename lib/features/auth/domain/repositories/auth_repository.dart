import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations.
///
/// Implements methods for:
/// - User login
/// - Token management
/// - Authentication state
abstract class AuthRepository {
  /// Attempts to log in a user with the provided credentials.
  ///
  /// Returns:
  /// - Right(User): On successful authentication
  /// - Left(Failure): On authentication failure
  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
    required String deviceId,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}
