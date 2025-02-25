// lib/features/auth/data/datasources/registration_local_datasource.dart
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/registration_request_model.dart';
import '../models/user_profile_model.dart';

abstract class RegistrationLocalDataSource {
  /// Stores the registration data temporarily during the registration process.
  ///
  /// Throws a [CacheException] if something goes wrong.
  Future<void> cacheRegistrationData(RegistrationRequestModel data);

  /// Gets the cached registration data.
  ///
  /// Throws a [CacheException] if no cached data is found.
  Future<RegistrationRequestModel?> getCachedRegistrationData();

  /// Clears the cached registration data.
  ///
  /// Throws a [CacheException] if something goes wrong.
  Future<void> clearRegistrationData();

  /// Saves auth tokens securely.
  ///
  /// Throws a [CacheException] if something goes wrong.
  Future<void> saveAuthTokens(String token, String refreshToken);

  /// Saves user profile info temporarily.
  ///
  /// Throws a [CacheException] if something goes wrong.
  Future<void> cacheUserProfile(UserProfileModel profile);

  /// Gets the cached user profile.
  ///
  /// Throws a [CacheException] if no cached data is found.
  Future<UserProfileModel?> getCachedUserProfile();

  /// Checks if the registration process has been initiated.
  Future<bool> isRegistrationInitiated();

  /// Saves the phone verification status.
  Future<void> savePhoneVerificationStatus(bool verified);

  /// Gets the phone verification status.
  Future<bool> getPhoneVerificationStatus();
}

@Injectable(as: RegistrationLocalDataSource)
class RegistrationLocalDataSourceImpl implements RegistrationLocalDataSource {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  static const String CACHED_REGISTRATION_DATA = 'CACHED_REGISTRATION_DATA';
  static const String CACHED_USER_PROFILE = 'CACHED_USER_PROFILE';
  static const String REGISTRATION_INITIATED = 'REGISTRATION_INITIATED';
  static const String PHONE_VERIFIED = 'PHONE_VERIFIED';
  static const String AUTH_TOKEN_KEY = 'AUTH_TOKEN';
  static const String REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

  RegistrationLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  @override
  Future<void> cacheRegistrationData(RegistrationRequestModel data) async {
    try {
      await _sharedPreferences.setString(
        CACHED_REGISTRATION_DATA,
        jsonEncode(data.toJson()),
      );
      await _sharedPreferences.setBool(REGISTRATION_INITIATED, true);
    } catch (e) {
      throw CacheException('Failed to cache registration data');
    }
  }

  @override
  Future<RegistrationRequestModel?> getCachedRegistrationData() async {
    try {
      final jsonString = _sharedPreferences.getString(CACHED_REGISTRATION_DATA);
      if (jsonString == null) {
        return null;
      }

      return RegistrationRequestModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Failed to get cached registration data');
    }
  }

  @override
  Future<void> clearRegistrationData() async {
    try {
      await _sharedPreferences.remove(CACHED_REGISTRATION_DATA);
      await _sharedPreferences.remove(REGISTRATION_INITIATED);
      await _sharedPreferences.remove(PHONE_VERIFIED);
      await _sharedPreferences.remove(CACHED_USER_PROFILE);
    } catch (e) {
      throw CacheException('Failed to clear registration data');
    }
  }

  @override
  Future<void> saveAuthTokens(String token, String refreshToken) async {
    try {
      await _secureStorage.write(key: AUTH_TOKEN_KEY, value: token);
      await _secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    } catch (e) {
      throw CacheException('Failed to save auth tokens');
    }
  }

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    try {
      await _sharedPreferences.setString(
        CACHED_USER_PROFILE,
        jsonEncode(profile.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache user profile');
    }
  }

  @override
  Future<UserProfileModel?> getCachedUserProfile() async {
    try {
      final jsonString = _sharedPreferences.getString(CACHED_USER_PROFILE);
      if (jsonString == null) {
        return null;
      }

      return UserProfileModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Failed to get cached user profile');
    }
  }

  @override
  Future<bool> isRegistrationInitiated() async {
    return _sharedPreferences.getBool(REGISTRATION_INITIATED) ?? false;
  }

  @override
  Future<void> savePhoneVerificationStatus(bool verified) async {
    try {
      await _sharedPreferences.setBool(PHONE_VERIFIED, verified);
    } catch (e) {
      throw CacheException('Failed to save phone verification status');
    }
  }

  @override
  Future<bool> getPhoneVerificationStatus() async {
    return _sharedPreferences.getBool(PHONE_VERIFIED) ?? false;
  }
}
