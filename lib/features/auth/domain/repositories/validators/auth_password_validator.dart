import '../password_validator.dart';

class AuthPasswordValidator implements PasswordValidator {
  static const int minLength = 6;

  @override
  bool isValid(String password) {
    return getValidationErrors(password).isEmpty;
  }

  @override
  List<String> getValidationErrors(String password) {
    final errors = <String>[];

    if (password.length < minLength) {
      errors.add('Mật khẩu phải có ít nhất $minLength ký tự');
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Mật khẩu phải chứa ít nhất 1 số');
    }

    return errors;
  }
}
