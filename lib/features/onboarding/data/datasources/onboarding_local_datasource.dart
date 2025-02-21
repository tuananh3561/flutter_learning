import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isFirstTime();
  Future<void> setOnboardingComplete();
  Future<List<Map<String, dynamic>>> getOnboardingItems();
}

@Injectable(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences _prefs;
  static const String _keyFirstTime = 'is_first_time';

  OnboardingLocalDataSourceImpl(this._prefs);

  @override
  Future<bool> isFirstTime() async {
    return _prefs.getBool(_keyFirstTime) ?? true;
  }

  @override
  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_keyFirstTime, false);
  }

  @override
  Future<List<Map<String, dynamic>>> getOnboardingItems() async {
    // Hardcoded onboarding items - in real app might come from JSON file or API
    return [
      {
        'title': 'Welcome to Our App',
        'description':
            'Discover amazing features that will make your life easier',
        'imageAsset': 'assets/images/onboarding/welcome.png',
      },
      {
        'title': 'Easy to Use',
        'description':
            'Intuitive interface designed for the best user experience',
        'imageAsset': 'assets/images/onboarding/easy.png',
      },
      {
        'title': 'Get Started',
        'description': 'Create your account and start your journey with us',
        'imageAsset': 'assets/images/onboarding/start.png',
      },
    ];
  }
}
