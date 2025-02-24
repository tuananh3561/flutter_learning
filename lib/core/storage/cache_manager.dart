class CacheManager {
  static final Map<String, dynamic> _cache = {};
  static const Duration _defaultDuration = Duration(minutes: 5);

  static Future<T?> get<T>(String key) async {
    final item = _cache[key];
    if (item == null) return null;

    if (item['expiry'].isBefore(DateTime.now())) {
      _cache.remove(key);
      return null;
    }

    return item['value'] as T;
  }

  static Future<void> set<T>(
    String key,
    T value, {
    Duration duration = _defaultDuration,
  }) async {
    _cache[key] = {
      'value': value,
      'expiry': DateTime.now().add(duration),
    };
  }
}
