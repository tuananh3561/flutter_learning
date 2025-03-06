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
