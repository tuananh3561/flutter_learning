// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    gh.factory<_i845.DeviceInfoMapper>(() => _i845.DeviceInfoMapper());
    gh.singleton<_i619.SecureStorage>(() => _i619.SecureStorage());
    gh.factory<_i804.OnboardingLocalDataSource>(() =>
        _i804.OnboardingLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i201.SplashLocalDataSource>(
        () => _i201.SplashLocalDataSourceImpl(
              gh<_i619.SecureStorage>(),
              gh<_i406.AppDatabase>(),
            ));
    gh.singleton<_i557.ApiClient>(
        () => _i557.ApiClient(gh<_i619.SecureStorage>()));
    gh.factory<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i220.SplashRemoteDataSource>(
        () => _i220.SplashRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.factory<_i430.OnboardingRepository>(() =>
        _i452.OnboardingRepositoryImpl(gh<_i804.OnboardingLocalDataSource>()));
    gh.factory<_i210.SplashRepository>(() => _i554.SplashRepositoryImpl(
          gh<_i201.SplashLocalDataSource>(),
          gh<_i220.SplashRemoteDataSource>(),
          gh<_i932.NetworkInfo>(),
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
    gh.factory<_i792.OnboardingBloc>(() => _i792.OnboardingBloc(
          gh<_i97.GetOnboardingItemsUseCase>(),
          gh<_i733.CheckFirstTimeUseCase>(),
          gh<_i360.CompleteOnboardingUseCase>(),
        ));
    gh.factory<_i442.SplashBloc>(() => _i442.SplashBloc(
          gh<_i239.InitializeDeviceUseCase>(),
          gh<_i426.CheckFirstTimeUseCase>(),
          gh<_i895.CheckAuthStatusUseCase>(),
        ));
    return this;
  }
}
