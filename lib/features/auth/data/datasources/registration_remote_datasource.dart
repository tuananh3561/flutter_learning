abstract class RegistrationRemoteDataSource {
  Future<void> register(Map<String, dynamic> data);
  Future<void> verifyPhone(String phone);
  Future<void> requestOtp(String phone);
  Future<void> verifyOtp(String phone, String otp);
}
