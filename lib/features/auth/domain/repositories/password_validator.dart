abstract class PasswordValidator {
  bool isValid(String password);
  List<String> getValidationErrors(String password);
}
