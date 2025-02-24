import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage.dart';

@injectable
class AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.saveAuthToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
  }

  Future<void> clearAuthTokens() async {
    await _secureStorage.clearAllTokens();
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.getAuthToken();
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.getRefreshToken();
  }
}
