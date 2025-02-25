// lib/features/auth/data/models/registration_request_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_request_model.g.dart';

@JsonSerializable()
class RegistrationRequestModel extends Equatable {
  final String phone;
  final String password;
  final String name;
  final String deviceId;
  final String? deviceModel;
  final String? deviceType;

  const RegistrationRequestModel({
    required this.phone,
    required this.password,
    required this.name,
    required this.deviceId,
    this.deviceModel,
    this.deviceType,
  });

  factory RegistrationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationRequestModelToJson(this);

  @override
  List<Object?> get props =>
      [phone, password, name, deviceId, deviceModel, deviceType];
}
