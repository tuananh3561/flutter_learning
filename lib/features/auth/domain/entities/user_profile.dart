// lib/features/auth/domain/entities/user_profile.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String phone,
    required String name,
    String? email,
    String? avatar,
    required bool isActive,
    List<String>? roles,
  }) = _UserProfile;

  // Add JSON serialization
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
