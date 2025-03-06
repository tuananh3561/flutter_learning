import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // Key for storing the language code in SharedPreferences
  static const String _languageKey = 'language_code';

  // Default language is English
  Locale _currentLocale = const Locale('en');

  // Getter for the current locale
  Locale get currentLocale => _currentLocale;

  // Available locales for the app
  final List<Locale> supportedLocales = const [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  // Constructor that initializes the provider and loads the saved language
  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Change the app's language
  Future<void> changeLanguage(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _currentLocale = locale;

    // Save the selected language to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);

    notifyListeners();
  }

  // Get the display name of a language based on its locale
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return 'Unknown';
    }
  }

  // Get the display name of the current language
  String get currentLanguageName => getLanguageName(_currentLocale);
}
