class ServerException implements Exception {
  final int statusCode;
  final String message;

  ServerException(this.statusCode, this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);
}

class UnknownException implements Exception {
  final String message;

  UnknownException(this.message);
}
