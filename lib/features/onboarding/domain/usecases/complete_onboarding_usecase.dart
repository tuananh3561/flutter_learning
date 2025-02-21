import 'package:injectable/injectable.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> call() async {
    await _repository.completeOnboarding();
  }
}
