import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;
  const factory SplashState.loading() = _Loading;
  const factory SplashState.navigateToOnboarding() = _NavigateToOnboarding;
  const factory SplashState.navigateToLogin() = _NavigateToLogin;
  const factory SplashState.navigateToHome() = _NavigateToHome;
  const factory SplashState.error(String message) = _Error;
}
