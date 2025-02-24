import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';
part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._(); // Add this line to include custom methods

  const factory UserModel({
    required String id,
    required String phoneNumber,
    String? name,
    String? avatar,
    DateTime? lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Move toDomain() inside the private constructor
  User toDomain() => User(
        id: id,
        phoneNumber: phoneNumber,
        name: name,
        avatar: avatar,
        lastLoginAt: lastLoginAt,
      );
}
