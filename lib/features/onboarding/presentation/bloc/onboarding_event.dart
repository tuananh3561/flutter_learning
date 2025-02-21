import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_event.freezed.dart';

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.initialize() = OnboardingInitialize;

  const factory OnboardingEvent.pageChanged({
    required int pageIndex,
    required int totalPages,
  }) = OnboardingPageChanged;

  const factory OnboardingEvent.nextTapped({
    required bool isLastPage,
  }) = OnboardingNextTapped;

  const factory OnboardingEvent.skip() = OnboardingSkip;
}
