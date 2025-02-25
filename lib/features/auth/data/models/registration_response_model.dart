// lib/features/auth/data/models/registration_response_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_response_model.g.dart';

@JsonSerializable()
class RegistrationResponseModel extends Equatable {
  final String? token;
  final String? refreshToken;
  final UserModel? user;
  final bool success;
  final String? message;

  const RegistrationResponseModel({
    this.token,
    this.refreshToken,
    this.user,
    required this.success,
    this.message,
  });

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseModelToJson(this);

  @override
  List<Object?> get props => [token, refreshToken, user, success, message];
}

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? avatar;
  final bool isActive;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.avatar,
    required this.isActive,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props =>
      [id, phone, name, email, avatar, isActive, createdAt];
}
