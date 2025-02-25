// lib/features/auth/data/models/user_profile_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel extends Equatable {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? avatar;
  final bool isActive;
  final List<String>? roles;
  final String? createdAt;
  final String? updatedAt;

  const UserProfileModel({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.avatar,
    required this.isActive,
    this.roles,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      phone: phone,
      name: name,
      email: email,
      avatar: avatar,
      isActive: isActive,
      roles: roles,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      phone: entity.phone,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      isActive: entity.isActive,
      roles: entity.roles,
    );
  }

  @override
  List<Object?> get props =>
      [id, phone, name, email, avatar, isActive, roles, createdAt, updatedAt];
}
