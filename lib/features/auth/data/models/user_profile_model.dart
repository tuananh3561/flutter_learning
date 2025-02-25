import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String phone,
    required String name,
    String? email,
    String? avatar,
    required bool isActive,
    List<String>? roles,
    String? createdAt,
    String? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  // Can't add methods directly in the freezed class, so we use extension
}

// Extension for mapping between domain and data models
extension UserProfileModelX on UserProfileModel {
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

  static UserProfileModel fromEntity(UserProfile entity) {
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
}
