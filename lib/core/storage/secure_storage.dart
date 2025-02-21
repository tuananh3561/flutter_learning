import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorage {
  final FlutterSecureStorage _storage;

  static const String keyDeviceId = 'device_id';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: keyDeviceId, value: deviceId);
  }

  Future<String?> getDeviceId() async {
    return await _storage.read(key: keyDeviceId);
  }

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: keyAuthToken, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: keyAuthToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: keyRefreshToken);
  }

  Future<void> clearAllTokens() async {
    await _storage.delete(key: keyAuthToken);
    await _storage.delete(key: keyRefreshToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
