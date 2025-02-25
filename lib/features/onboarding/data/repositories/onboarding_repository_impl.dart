import 'package:injectable/injectable.dart';
import '../../domain/entities/onboarding_item.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';
import '../models/onboarding_item_model.dart';

@Injectable(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  OnboardingRepositoryImpl(this._localDataSource);

  @override
  Future<bool> isFirstTime() async {
    return await _localDataSource.isFirstTime();
  }

  @override
  Future<void> completeOnboarding() async {
    await _localDataSource.setOnboardingComplete();
  }

  @override
  Future<List<OnboardingItem>> getOnboardingItems() async {
    final itemsData = await _localDataSource.getOnboardingItems();
    return itemsData
        .map((data) => OnboardingItemModel.fromJson(data).toEntity())
        .toList();
  }
}
