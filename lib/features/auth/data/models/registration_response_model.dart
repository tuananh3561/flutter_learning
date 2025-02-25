import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_response_model.freezed.dart';
part 'registration_response_model.g.dart';

@freezed
class RegistrationResponseModel with _$RegistrationResponseModel {
  const factory RegistrationResponseModel({
    String? token,
    String? refreshToken,
    UserModel2? user,
    required bool success,
    String? message,
  }) = _RegistrationResponseModel;

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseModelFromJson(json);
}

@freezed
class UserModel2 with _$UserModel2 {
  const factory UserModel2({
    required String id,
    required String phone,
    required String name,
    String? email,
    String? avatar,
    required bool isActive,
    String? createdAt,
  }) = _UserModel2;

  factory UserModel2.fromJson(Map<String, dynamic> json) =>
      _$UserModel2FromJson(json);
}
