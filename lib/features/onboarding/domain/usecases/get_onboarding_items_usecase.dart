import 'package:injectable/injectable.dart';
import '../entities/onboarding_item.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class GetOnboardingItemsUseCase {
  final OnboardingRepository _repository;

  GetOnboardingItemsUseCase(this._repository);

  Future<List<OnboardingItem>> call() async {
    return await _repository.getOnboardingItems();
  }
}
