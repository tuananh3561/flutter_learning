import 'package:equatable/equatable.dart';
import 'user_profile.dart';

class RegistrationResult extends Equatable {
  final bool success;
  final UserProfile? user;
  final String? message;
  final String? token;

  const RegistrationResult({
    required this.success,
    this.user,
    this.message,
    this.token,
  });

  @override
  List<Object?> get props => [success, user, message, token];
}
