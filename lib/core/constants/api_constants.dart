class ApiEndpoints {
  static const String baseUrl = 'https://auth.monkeyuni.net';

  // Registration endpoints
  static const String register = '/api/v1/auth/register';
  static const String verifyPhone = '/api/v1/auth/verify-phone';
  static const String requestOtp = '/api/v1/auth/request-otp';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String createProfile = '/api/v1/users/profile';
}
