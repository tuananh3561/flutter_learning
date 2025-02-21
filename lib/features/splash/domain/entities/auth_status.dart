import 'package:equatable/equatable.dart';

class AuthStatus extends Equatable {
  final bool isAuthenticated;
  final String? token;

  const AuthStatus({
    required this.isAuthenticated,
    this.token,
  });

  @override
  List<Object?> get props => [isAuthenticated, token];
}
