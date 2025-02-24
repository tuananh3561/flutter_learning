abstract class RegistrationLocalDataSource {
  Future<void> cacheRegistrationData(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getCachedRegistrationData();
  Future<void> clearRegistrationData();
}
