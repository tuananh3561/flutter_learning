import '../entities/onboarding_item.dart';

abstract class OnboardingRepository {
  Future<bool> isFirstTime();
  Future<void> completeOnboarding();
  Future<List<OnboardingItem>> getOnboardingItems();
}
