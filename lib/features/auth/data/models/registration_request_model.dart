import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_request_model.freezed.dart';
part 'registration_request_model.g.dart';

@freezed
class RegistrationRequestModel with _$RegistrationRequestModel {
  const factory RegistrationRequestModel({
    required String phone,
    required String password,
    required String name,
    required String deviceId,
    String? deviceModel,
    String? deviceType,
  }) = _RegistrationRequestModel;

  factory RegistrationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestModelFromJson(json);
}
