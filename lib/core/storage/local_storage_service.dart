import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';

/// Service for handling local storage operations
/// Uses SharedPreferences for simple key-value storage
class LocalStorageService {
  final SharedPreferences _prefs;
  
  LocalStorageService(this._prefs);
  
  /// Factory constructor to create an instance with initialized SharedPreferences
  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  /// Save a string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string: $e');
    }
  }

  /// Get a string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: $e');
    }
  }

  /// Save a boolean value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save boolean: $e');
    }
  }

  /// Get a boolean value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get boolean: $e');
    }
  }

  /// Save an integer value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save integer: $e');
    }
  }

  /// Get an integer value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get integer: $e');
    }
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: $e');
    }
  }

  /// Clear all values
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: $e');
    }
  }
}