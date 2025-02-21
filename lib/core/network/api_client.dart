import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/secure_storage.dart';

@singleton
class ApiClient {
  late Dio _dio;
  final SecureStorage _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://auth.monkeyuni.net',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )..interceptors.addAll([
        _authInterceptor(),
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      ]);
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Handle token refresh here
          final refreshToken = await _secureStorage.getRefreshToken();
          if (refreshToken != null) {
            try {
              // Call refresh token API
              // Update tokens in secure storage
              // Retry original request
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              // Handle refresh token failure
              await _secureStorage.clearAllTokens();
              // Navigate to login screen
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Add other methods as needed
}
