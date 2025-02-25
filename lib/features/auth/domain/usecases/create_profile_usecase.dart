// lib/features/auth/domain/usecases/create_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/registration_repository.dart';

part 'create_profile_usecase.freezed.dart';
part 'create_profile_usecase.g.dart';

@injectable
class CreateProfileUseCase
    implements UseCase<UserProfile, CreateProfileParams> {
  final RegistrationRepository repository;

  CreateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(CreateProfileParams params) {
    return repository.createProfile(params.profile, params.token);
  }
}

// Convert UserProfile to/from JSON for serialization
class _UserProfileConverter
    implements JsonConverter<UserProfile, Map<String, dynamic>> {
  const _UserProfileConverter();

  @override
  UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(UserProfile object) {
    return {
      'id': object.id,
      'phone': object.phone,
      'name': object.name,
      'email': object.email,
      'avatar': object.avatar,
      'isActive': object.isActive,
      'roles': object.roles,
    };
  }
}

@freezed
class CreateProfileParams with _$CreateProfileParams {
  const factory CreateProfileParams({
    @_UserProfileConverter() required UserProfile profile,
    required String token,
  }) = _CreateProfileParams;

  factory CreateProfileParams.fromJson(Map<String, dynamic> json) =>
      _$CreateProfileParamsFromJson(json);
}
