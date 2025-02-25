// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/repositories/password_validator.dart'
    as _i705;
import '../../features/auth/domain/repositories/phone_validator.dart' as _i632;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i52;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/validate_password_usecase.dart'
    as _i890;
import '../../features/auth/domain/usecases/validate_phone_usecase.dart'
    as _i220;
import '../../features/auth/presentation/bloc/login_bloc.dart' as _i990;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i804;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/check_first_time_usecase.dart'
    as _i733;
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart'
    as _i360;
import '../../features/onboarding/domain/usecases/get_onboarding_items_usecase.dart'
    as _i97;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/splash/data/datasources/splash_local_datasource.dart'
    as _i201;
import '../../features/splash/data/datasources/splash_remote_datasource.dart'
    as _i220;
import '../../features/splash/data/models/mappers/device_info_mapper.dart'
    as _i845;
import '../../features/splash/data/repositories/splash_repository_impl.dart'
    as _i554;
import '../../features/splash/domain/repositories/splash_repository.dart'
    as _i210;
import '../../features/splash/domain/usecases/check_auth_status_usecase.dart'
    as _i895;
import '../../features/splash/domain/usecases/check_first_time_usecase.dart'
    as _i426;
import '../../features/splash/domain/usecases/initialize_device_usecase.dart'
    as _i239;
import '../../features/splash/presentation/bloc/splash_bloc.dart' as _i442;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import '../storage/database/app_database.dart' as _i406;
import '../storage/secure_storage.dart' as _i619;
import 'auth_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final authModule = _$AuthModule();
    gh.factory<_i845.DeviceInfoMapper>(() => _i845.DeviceInfoMapper());
    gh.singleton<_i632.PhoneValidator>(() => authModule.phoneValidator);
    gh.singleton<_i705.PasswordValidator>(() => authModule.passwordValidator);
    gh.singleton<_i619.SecureStorage>(() => _i619.SecureStorage());
    gh.factory<_i804.OnboardingLocalDataSource>(() =>
        _i804.OnboardingLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i890.ValidatePasswordUseCase>(
        () => _i890.ValidatePasswordUseCase(gh<_i705.PasswordValidator>()));
    gh.factory<_i201.SplashLocalDataSource>(
        () => _i201.SplashLocalDataSourceImpl(
              gh<_i619.SecureStorage>(),
              gh<_i406.AppDatabase>(),
            ));
    gh.singleton<_i557.ApiClient>(
        () => _i557.ApiClient(gh<_i619.SecureStorage>()));
    gh.factory<_i992.AuthLocalDataSource>(
        () => _i992.AuthLocalDataSource(gh<_i619.SecureStorage>()));
    gh.factory<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl.create());
    gh.factory<_i220.ValidatePhoneUseCase>(
        () => _i220.ValidatePhoneUseCase(gh<_i632.PhoneValidator>()));
    gh.factory<_i220.SplashRemoteDataSource>(
        () => _i220.SplashRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.factory<_i430.OnboardingRepository>(() =>
        _i452.OnboardingRepositoryImpl(gh<_i804.OnboardingLocalDataSource>()));
    gh.factory<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSource(gh<_i557.ApiClient>()));
    gh.factory<_i210.SplashRepository>(() => _i554.SplashRepositoryImpl(
          gh<_i201.SplashLocalDataSource>(),
          gh<_i220.SplashRemoteDataSource>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
          localDataSource: gh<_i992.AuthLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i360.CompleteOnboardingUseCase>(() =>
        _i360.CompleteOnboardingUseCase(gh<_i430.OnboardingRepository>()));
    gh.factory<_i97.GetOnboardingItemsUseCase>(
        () => _i97.GetOnboardingItemsUseCase(gh<_i430.OnboardingRepository>()));
    gh.factory<_i733.CheckFirstTimeUseCase>(
        () => _i733.CheckFirstTimeUseCase(gh<_i430.OnboardingRepository>()));
    gh.factory<_i426.CheckFirstTimeUseCase>(
        () => _i426.CheckFirstTimeUseCase(gh<_i210.SplashRepository>()));
    gh.factory<_i239.InitializeDeviceUseCase>(
        () => _i239.InitializeDeviceUseCase(gh<_i210.SplashRepository>()));
    gh.factory<_i895.CheckAuthStatusUseCase>(
        () => _i895.CheckAuthStatusUseCase(gh<_i210.SplashRepository>()));
    gh.factory<_i52.CheckAuthStatusUseCase>(
        () => _i52.CheckAuthStatusUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i792.OnboardingBloc>(() => _i792.OnboardingBloc(
          gh<_i97.GetOnboardingItemsUseCase>(),
          gh<_i733.CheckFirstTimeUseCase>(),
          gh<_i360.CompleteOnboardingUseCase>(),
        ));
    gh.factory<_i188.LoginUseCase>(() => _i188.LoginUseCase(
          gh<_i787.AuthRepository>(),
          gh<_i632.PhoneValidator>(),
          gh<_i705.PasswordValidator>(),
        ));
    gh.factory<_i442.SplashBloc>(() => _i442.SplashBloc(
          gh<_i239.InitializeDeviceUseCase>(),
          gh<_i426.CheckFirstTimeUseCase>(),
          gh<_i895.CheckAuthStatusUseCase>(),
        ));
    gh.factory<_i990.LoginBloc>(() => _i990.LoginBloc(
          gh<_i188.LoginUseCase>(),
          gh<_i220.ValidatePhoneUseCase>(),
          gh<_i890.ValidatePasswordUseCase>(),
        ));
    return this;
  }
}

class _$AuthModule extends _i784.AuthModule {}
