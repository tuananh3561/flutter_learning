/// Base class for all exceptions in the application
/// Exceptions are used for programming errors that should be fixed during development
/// For expected error cases that should be handled gracefully, use Failures instead
class AppException implements Exception {
  final String message;
  final String? stackTrace;
  final int? code;

  AppException({
    required this.message,
    this.stackTrace,
    this.code,
  });

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Server exceptions (API related)
class ServerException extends AppException {
  ServerException({
    required String message,
    String? stackTrace,
    int? code,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
        );
}

/// Cache exceptions (local storage related)
class CacheException extends AppException {
  CacheException({
    required String message,
    String? stackTrace,
    int? code,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
        );
}

/// Network exceptions (connectivity related)
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? stackTrace,
    int? code,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
        );
}