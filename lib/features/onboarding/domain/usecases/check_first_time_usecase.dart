import 'package:injectable/injectable.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class CheckFirstTimeUseCase {
  final OnboardingRepository _repository;

  CheckFirstTimeUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.isFirstTime();
  }
}
