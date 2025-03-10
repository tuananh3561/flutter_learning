import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// API Client for handling network requests
/// Uses Dio as the HTTP client
class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.connectTimeout =
        const Duration(milliseconds: AppConstants.connectionTimeout);
    _dio.options.receiveTimeout =
        const Duration(milliseconds: AppConstants.receiveTimeout);
    _dio.interceptors.add(_createLoggingInterceptor());
  }

  /// Create a custom interceptor for logging requests and responses
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log request
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log response
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Log error
        print(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        return handler.next(e);
      },
    );
  }

  /// Perform a GET request
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Perform a POST request
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Handle Dio specific errors
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(
          message: 'Connection timeout',
          code: e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        throw ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          code: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        throw ServerException(
          message: 'Request cancelled',
          code: e.response?.statusCode,
        );
      default:
        throw ServerException(
          message: e.message ?? 'Unknown error occurred',
          code: e.response?.statusCode,
        );
    }
  }
}
