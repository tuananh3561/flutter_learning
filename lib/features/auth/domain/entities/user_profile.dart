import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? avatar;
  final bool isActive;
  final List<String>? roles;

  const UserProfile({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.avatar,
    required this.isActive,
    this.roles,
  });

  @override
  List<Object?> get props => [id, phone, name, email, avatar, isActive, roles];
}
