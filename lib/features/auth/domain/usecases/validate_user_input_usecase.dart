// lib/features/auth/domain/usecases/validate_user_input_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class ValidateUserInputUseCase implements UseCase<bool, ValidationParams> {
  ValidateUserInputUseCase();

  @override
  Future<Either<Failure, bool>> call(ValidationParams params) async {
    final errors = <String, String>{};

    // Phone validation
    if (params.phone != null) {
      if (params.phone!.isEmpty) {
        errors['phone'] = 'Phone number is required';
      } else if (!_isValidPhoneNumber(params.phone!)) {
        errors['phone'] = 'Invalid phone number format';
      }
    }

    // Password validation
    if (params.password != null) {
      if (params.password!.isEmpty) {
        errors['password'] = 'Password is required';
      } else if (params.password!.length < 8) {
        errors['password'] = 'Password must be at least 8 characters';
      } else if (!_hasStrongPassword(params.password!)) {
        errors['password'] = 'Password must contain letters and numbers';
      }
    }

    // Name validation
    if (params.name != null) {
      if (params.name!.isEmpty) {
        errors['name'] = 'Name is required';
      } else if (params.name!.length < 2) {
        errors['name'] = 'Name must be at least 2 characters';
      }
    }

    // OTP validation
    if (params.otp != null) {
      if (params.otp!.isEmpty) {
        errors['otp'] = 'OTP code is required';
      } else if (params.otp!.length < 4 || params.otp!.length > 6) {
        errors['otp'] = 'OTP code must be between 4-6 digits';
      } else if (!RegExp(r'^\d+$').hasMatch(params.otp!)) {
        errors['otp'] = 'OTP code must contain only digits';
      }
    }

    if (errors.isNotEmpty) {
      return Left(ValidationFailure(
        'Validation failed: ${errors.values.join(', ')}',
      ));
    }

    return const Right(true);
  }

  bool _isValidPhoneNumber(String phone) {
    // Basic phone validation - can be enhanced based on requirements
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return RegExp(r'^([+]?[\s0-9]+)?(\d{10,12})$').hasMatch(cleanPhone);
  }

  bool _hasStrongPassword(String password) {
    // Check if password has at least one letter and one number
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasDigit;
  }
}

class ValidationParams extends Equatable {
  final String? phone;
  final String? password;
  final String? name;
  final String? otp;

  const ValidationParams({
    this.phone,
    this.password,
    this.name,
    this.otp,
  });

  @override
  List<Object?> get props => [phone, password, name, otp];
}
