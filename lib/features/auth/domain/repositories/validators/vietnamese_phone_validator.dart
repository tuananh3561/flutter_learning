import '../phone_validator.dart';

class VietnamesePhoneValidator implements PhoneValidator {
  static final RegExp _phoneRegex = RegExp(r'^(\+84|0)[0-9]{9}$');

  @override
  bool isValid(String phone) {
    return _phoneRegex.hasMatch(normalize(phone));
  }

  @override
  String normalize(String phone) {
    // Remove all spaces and special characters
    String normalized = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Convert +84 to 0
    if (normalized.startsWith('+84')) {
      normalized = '0' + normalized.substring(3);
    }

    return normalized;
  }
}
