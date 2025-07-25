import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_header.dart';

/// Layout chung cho tất cả auth screens
class AuthScreenLayout extends StatelessWidget {
  final Widget child;
  final double? customHeight;
  final bool showHeader;
  final String headerTitle;
  final double headerHeight;

  const AuthScreenLayout({
    super.key,
    required this.child,
    this.customHeight,
    this.showHeader = true,
    this.headerTitle = '',
    this.headerHeight = 84,
  });

  static double getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return math.min(screenWidth / 428.0, screenHeight / 926.0).clamp(0.8, 1.8);
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = getScaleFactor(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            height: customHeight ?? math.max(screenHeight, 926 * scaleFactor),
            child: Column(
              children: [
                // Header
                if (showHeader)
                  AppHeader(
                    title: headerTitle,
                    scaleFactor: scaleFactor,
                    height: headerHeight,
                  ),

                // Content
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
