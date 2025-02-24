// import 'package:injectable/injectable.dart';
// import '../../features/auth/data/datasources/auth_remote_datasource.dart';
// import '../../features/auth/data/datasources/auth_local_datasource.dart';
// import '../../features/auth/data/repositories/auth_repository_impl.dart';
// import '../../features/auth/domain/repositories/auth_repository.dart';

// @module
// abstract class AuthModule {
//   @singleton
//   AuthRemoteDataSource get remoteDataSource => AuthRemoteDataSource();

//   @singleton
//   AuthLocalDataSource get localDataSource => AuthLocalDataSource();

//   @singleton
//   AuthRepository get repository => AuthRepositoryImpl(
//         remoteDataSource: getIt<AuthRemoteDataSource>(),
//         localDataSource: getIt<AuthLocalDataSource>(),
//       );
// }

import 'package:injectable/injectable.dart';
import '../../features/auth/domain/repositories/phone_validator.dart';
import '../../features/auth/domain/repositories/password_validator.dart';
import '../../features/auth/domain/repositories/validators/vietnamese_phone_validator.dart';
import '../../features/auth/domain/repositories/validators/auth_password_validator.dart';

@module
abstract class AuthModule {
  @singleton
  PhoneValidator get phoneValidator => VietnamesePhoneValidator();

  @singleton
  PasswordValidator get passwordValidator => AuthPasswordValidator();
}
