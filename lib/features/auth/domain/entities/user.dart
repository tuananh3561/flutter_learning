import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? avatar;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.avatar,
    this.lastLoginAt,
  });

  bool get hasCompletedProfile => name != null;

  @override
  List<Object?> get props => [id, phoneNumber, name, avatar, lastLoginAt];
}
