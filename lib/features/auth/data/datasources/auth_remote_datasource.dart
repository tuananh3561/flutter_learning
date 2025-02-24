import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

@injectable
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Login failed');
      // throw ServerException(message: 'Login failed');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      throw Exception('Login failed');
      // throw ServerException(message: 'Logout failed');
    }
  }
}
