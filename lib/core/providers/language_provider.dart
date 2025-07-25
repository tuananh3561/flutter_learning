import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // Key for storing the language code in SharedPreferences
  static const String _languageKey = 'language_code';

  // Default language is Vietnamese
  Locale _currentLocale = const Locale('vi');

  // Loading state
  bool _isLoaded = false;

  // Getter for the current locale
  Locale get currentLocale => _currentLocale;

  // Getter for loading state
  bool get isLoaded => _isLoaded;

  // Available locales for the app (mở rộng 4 ngôn ngữ)
  final List<Locale> supportedLocales = const [
    Locale('vi'), // Vietnamese
    Locale('en'), // English
    Locale('th'), // Thai
    Locale('ms'), // Malaysian
  ];

  // Constructor that initializes the provider and loads the saved language
  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        final newLocale = Locale(languageCode);
        // Kiểm tra xem locale có được support không
        if (supportedLocales.contains(newLocale)) {
          _currentLocale = newLocale;
        }
      }
    } catch (e) {
      // Handle error silently in production, could add logging service
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  // Change the app's language
  Future<void> changeLanguage(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _currentLocale = locale;

    // Save the selected language to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      // Handle error silently in production, could add logging service
    }

    notifyListeners();
  }

  // Get the display name of a language based on its locale
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English (US)';
      case 'th':
        return 'ไทย';
      case 'ms':
        return 'Malaysia';
      default:
        return 'Unknown';
    }
  }

  // Get the display name of the current language
  String get currentLanguageName => getLanguageName(_currentLocale);

  // Get short display name for button (VI, EN, TH, MS)
  String getShortDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return 'VI';
      case 'en':
        return 'EN';
      case 'th':
        return 'TH';
      case 'ms':
        return 'MS';
      default:
        return 'VI';
    }
  }

  // Get short display name for current language
  String get currentShortDisplayName => getShortDisplayName(_currentLocale);

  // Get flag colors for language
  Color getFlagColor(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return const Color(0xFFEA403F); // Vietnam red
      case 'en':
        return const Color(0xFF46467F); // USA blue
      case 'th':
        return const Color(0xFFF12532); // Thailand red
      case 'ms':
        return const Color(0xFFE31D1C); // Malaysia red
      default:
        return const Color(0xFFEA403F);
    }
  }

  // Get star colors for language
  Color getStarColor(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return const Color(0xFFFFFE4E); // Vietnam yellow star
      case 'en':
        return Colors.white; // USA white stars
      case 'th':
        return Colors.white; // Thailand white
      case 'ms':
        return const Color(0xFFFECA00); // Malaysia yellow
      default:
        return const Color(0xFFFFFE4E);
    }
  }

  // Get current flag color
  Color get currentFlagColor => getFlagColor(_currentLocale);

  // Get current star color
  Color get currentStarColor => getStarColor(_currentLocale);
}
