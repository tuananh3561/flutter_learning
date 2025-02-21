import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/onboarding_item.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;

  const factory OnboardingState.loading() = _Loading;

  const factory OnboardingState.success({
    required List<OnboardingItem> items,
    required int currentPage,
    required bool isLastPage,
    required double progress,
  }) = _Success;

  const factory OnboardingState.error({
    required String message,
  }) = _Error;

  const factory OnboardingState.completed() = _Completed;
}
