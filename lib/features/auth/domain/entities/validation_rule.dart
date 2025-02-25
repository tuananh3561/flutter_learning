// lib/features/auth/domain/entities/validation_rule.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_rule.freezed.dart';
part 'validation_rule.g.dart';

enum ValidationType {
  required,
  minLength,
  maxLength,
  pattern,
  custom,
}

// Custom JsonConverter to handle the function type
class ValidatorFunctionConverter
    implements JsonConverter<bool Function(String)?, Map<String, dynamic>?> {
  const ValidatorFunctionConverter();

  @override
  bool Function(String)? fromJson(Map<String, dynamic>? json) {
    // We can't actually deserialize a function from JSON
    // This is a dummy implementation, in practice you would need a different approach
    return null;
  }

  @override
  Map<String, dynamic>? toJson(bool Function(String)? function) {
    // We can't serialize functions to JSON
    return null;
  }
}

@freezed
class ValidationRule with _$ValidationRule {
  const factory ValidationRule({
    required ValidationType type,
    dynamic value,
    required String message,
    @ValidatorFunctionConverter() bool Function(String value)? validator,
  }) = _ValidationRule;

  // Add JSON serialization
  factory ValidationRule.fromJson(Map<String, dynamic> json) =>
      _$ValidationRuleFromJson(json);
}
