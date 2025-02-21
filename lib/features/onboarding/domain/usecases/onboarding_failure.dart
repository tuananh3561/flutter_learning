// lib/features/onboarding/domain/failures/onboarding_failure.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingFailure extends Equatable {
  @override
  List<Object> get props => [];
}

class CacheFailure extends OnboardingFailure {}

class NoOnboardingItemsFailure extends OnboardingFailure {}
