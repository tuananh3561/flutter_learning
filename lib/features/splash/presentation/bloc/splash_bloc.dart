import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/initialize_device_usecase.dart';
import '../../domain/usecases/check_first_time_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final InitializeDeviceUseCase _initializeDeviceUseCase;
  final CheckFirstTimeUseCase _checkFirstTimeUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  SplashBloc(
    this._initializeDeviceUseCase,
    this._checkFirstTimeUseCase,
    this._checkAuthStatusUseCase,
  ) : super(const SplashState.initial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashState.loading());
    await Future.delayed(const Duration(seconds: 2));
    // Initialize device
    final deviceResult = await _initializeDeviceUseCase();
    final SplashState failureOrSuccess = await deviceResult.fold(
      (failure) async => const SplashState.error('Failed to initialize device'),
      (deviceInfo) async {
        print('Device Info: $deviceInfo');
        // Check if first time
        final firstTimeResult = await _checkFirstTimeUseCase();
        return firstTimeResult.fold(
          (failure) =>
              const SplashState.error('Failed to check first time status'),
          (isFirstTime) async {
            if (isFirstTime) {
              return const SplashState.navigateToOnboarding();
            }

            // Check auth status
            final authResult = await _checkAuthStatusUseCase();
            return authResult.fold(
              (failure) =>
                  const SplashState.error('Failed to check auth status'),
              (authStatus) {
                if (authStatus.isAuthenticated) {
                  return const SplashState.navigateToHome();
                } else {
                  return const SplashState.navigateToLogin();
                }
              },
            );
          },
        );
      },
    );

    emit(failureOrSuccess);
  }
}
