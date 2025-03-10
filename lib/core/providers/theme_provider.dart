import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme_constants.dart';

/// Theme provider for the Story Nighty Night app
/// This provider manages the app's theme state and provides methods to switch between themes
class ThemeProvider extends ChangeNotifier {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  // Getter for current theme mode
  ThemeMode get themeMode => _themeMode;

  // Check if dark mode is active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Toggle between light and dark themes
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _updateSystemUI();
    notifyListeners();
  }

  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _updateSystemUI();
    notifyListeners();
  }

  // Update system UI to match current theme
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: ThemeConstants.backgroundDark,
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: ThemeConstants.backgroundLight,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
    );
  }

  // Light theme configuration
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ThemeConstants.primaryPurple,
        secondary: ThemeConstants.accentYellow,
        tertiary: ThemeConstants.accentPink,
        surface: ThemeConstants.cardLight,
        error: ThemeConstants.error,
      ),
      scaffoldBackgroundColor: ThemeConstants.backgroundLight,
      cardColor: ThemeConstants.cardLight,
      textTheme: _buildTextTheme(
          ThemeConstants.textDark, ThemeConstants.textSecondaryDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeConstants.backgroundLight,
        foregroundColor: ThemeConstants.textDark,
        elevation: ThemeConstants.elevationSm,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryPurple,
          foregroundColor: ThemeConstants.textLight,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingLg,
            vertical: ThemeConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeConstants.primaryPurple,
          side: const BorderSide(color: ThemeConstants.primaryPurple),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingLg,
            vertical: ThemeConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeConstants.primaryPurple,
        ),
      ),
      iconTheme: const IconThemeData(
        color: ThemeConstants.primaryPurple,
      ),
      cardTheme: CardTheme(
        color: ThemeConstants.cardLight,
        elevation: ThemeConstants.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeConstants.cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: const BorderSide(color: ThemeConstants.primaryPurple),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: const BorderSide(color: ThemeConstants.error),
        ),
      ),
    );
  }

  // Dark theme configuration
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ThemeConstants.primaryBlue,
        secondary: ThemeConstants.accentYellow,
        tertiary: ThemeConstants.accentPink,
        surface: ThemeConstants.cardDark,
        error: ThemeConstants.error,
      ),
      scaffoldBackgroundColor: ThemeConstants.backgroundDark,
      cardColor: ThemeConstants.cardDark,
      textTheme: _buildTextTheme(
          ThemeConstants.textLight, ThemeConstants.textSecondaryLight),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeConstants.backgroundDark,
        foregroundColor: ThemeConstants.textLight,
        elevation: ThemeConstants.elevationSm,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryBlue,
          foregroundColor: ThemeConstants.textLight,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingLg,
            vertical: ThemeConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeConstants.accentYellow,
          side: const BorderSide(color: ThemeConstants.accentYellow),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingLg,
            vertical: ThemeConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeConstants.accentYellow,
        ),
      ),
      iconTheme: const IconThemeData(
        color: ThemeConstants.accentYellow,
      ),
      cardTheme: CardTheme(
        color: ThemeConstants.cardDark,
        elevation: ThemeConstants.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeConstants.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: const BorderSide(color: ThemeConstants.accentYellow),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMd),
          borderSide: const BorderSide(color: ThemeConstants.error),
        ),
      ),
    );
  }

  // Build text theme with appropriate colors
  TextTheme _buildTextTheme(Color primaryTextColor, Color secondaryTextColor) {
    return TextTheme(
      displayLarge: TextStyle(
        color: primaryTextColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: primaryTextColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: primaryTextColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: primaryTextColor,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: primaryTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: primaryTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: primaryTextColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: primaryTextColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: primaryTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: primaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: secondaryTextColor,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
