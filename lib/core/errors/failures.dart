import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// All failures should extend this class
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server failures (API related)
class ServerFailure extends Failure {
  const ServerFailure({required String message, int? code}) 
      : super(message: message, code: code);
}

/// Cache failures (local storage related)
class CacheFailure extends Failure {
  const CacheFailure({required String message, int? code}) 
      : super(message: message, code: code);
}

/// Network failures (connectivity related)
class NetworkFailure extends Failure {
  const NetworkFailure({required String message, int? code}) 
      : super(message: message, code: code);
}

/// Validation failures (input validation related)
class ValidationFailure extends Failure {
  const ValidationFailure({required String message, int? code}) 
      : super(message: message, code: code);
}