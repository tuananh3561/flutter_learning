import 'package:flutter/material.dart';

/// Theme constants for the Story Nighty Night app
/// This file contains all the colors, text styles, and other design elements
/// that will be used throughout the app.
class ThemeConstants {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6A1B9A); // Deep Purple
  static const Color primaryBlue =
      Color(0xFF1A237E); // Dark Blue for night theme
  static const Color accentYellow =
      Color(0xFFFFD54F); // Amber for stars/highlights
  static const Color accentPink = Color(0xFFF48FB1); // Pink for accents

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light background
  static const Color backgroundDark =
      Color(0xFF121212); // Dark background for night mode
  static const Color cardLight = Color(0xFFFFFFFF); // Light card background
  static const Color cardDark = Color(0xFF1E1E1E); // Dark card background

  // Text Colors
  static const Color textDark =
      Color(0xFF212121); // Primary text on light background
  static const Color textLight =
      Color(0xFFF5F5F5); // Primary text on dark background
  static const Color textSecondaryDark =
      Color(0xFF757575); // Secondary text on light background
  static const Color textSecondaryLight =
      Color(0xFFBDBDBD); // Secondary text on dark background

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Success green
  static const Color error = Color(0xFFE57373); // Soft error red
  static const Color warning = Color(0xFFFFB74D); // Warning orange
  static const Color info = Color(0xFF64B5F6); // Info blue

  // Child-friendly Colors
  static const Color childYellow = Color(0xFFFFEB3B); // Bright yellow
  static const Color childGreen = Color(0xFF8BC34A); // Soft green
  static const Color childBlue = Color(0xFF03A9F4); // Bright blue
  static const Color childRed = Color(0xFFFF8A80); // Soft red
  static const Color childPurple = Color(0xFFCE93D8); // Soft purple

  // Gradients
  static const List<Color> nightSkyGradient = [
    Color(0xFF0D47A1), // Deep blue
    Color(0xFF1A237E), // Indigo
    Color(0xFF311B92), // Deep purple
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
  ];

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusCircular = 1000.0; // For circular elements

  // Elevation
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Animation Durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);

  // Prevent instantiation
  ThemeConstants._();
}

class AppTheme {
  static const Color primaryColor = Color(0xFF36BFFA);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Colors.white;
  static const Color successColor = Color(0xFF92C73D);
  static const Color blueLightColor = Color(0xFFEDF9FF);
  static const Color skyLightColor = Color(0xFFD2F1FF);
  static const Color lightGrayColor = Color(0xFFD9D9D9);

  static const Color errorColor = Color(0xFFFF4B4B);
  static const Color textColor = Color(0xFF4B4B4B);
  static const Color textSecondaryColor = Color(0xFF777777);
  static const Color textGrayColor = Color(0xFFA3A3A3);
  static const Color textGrayLightColor = Color(0xFFAFAFAF);
  static const Color textBlueColor = Color(0xFF3393FF);
  static const Color textPrimaryColor = Color(0xFF00BBFF);
  static const Color azureColor = Color(0xFF00AAFF);
  static const Color pinkColor = Color(0xFFFF6CA5);
  static const Color orangeColor = Color(0xFFFFAE01);

  // Button colors
  static const Color buttonPrimaryDisabledBackground = Color(0xFFE5E5E5);
  static const Color buttonSecondaryDisabledBackground = Color(0xFFF5F5F5);
  static const Color buttonPrimaryDarkerColor = Color(0xFF0095C1);
  static const Color buttonPrimaryDisabledDarkerColor = Color(0xFFD6D6D6);
  static const Color buttonSecondaryDarkerColor = Color(0xFFE5E5E5);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    fontFamily: 'Nunito',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1.44,
      ),
      titleSmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1.28,
      ),
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: -1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: -0.96,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.8,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.64,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.56,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
        letterSpacing: -0.56,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: textSecondaryColor,
        letterSpacing: -0.48,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textColor,
          fontFamily: 'Nunito',
          letterSpacing: -0.8,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(
          color: AppTheme.buttonPrimaryDisabledBackground,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textSecondaryColor,
          fontFamily: 'Nunito',
          letterSpacing: -0.8,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: backgroundColor,
          fontFamily: 'Nunito',
          letterSpacing: -0.8,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textSecondaryColor,
          fontFamily: 'Nunito',
          decoration: TextDecoration.none,
          letterSpacing: -0.72,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      hintStyle: TextStyle(
        fontSize: 20,
        color: textGrayLightColor,
        fontWeight: FontWeight.w800,
        fontFamily: 'Nunito',
        letterSpacing: -0.8,
      ),
      labelStyle: TextStyle(
        fontSize: 20,
        color: textGrayLightColor,
        fontWeight: FontWeight.w800,
        fontFamily: 'Nunito',
        letterSpacing: -0.8,
      ),
    ),
  );
}

class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
}
