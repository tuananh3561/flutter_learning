import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

/// App Header component có thể tái sử dụng
/// Bao gồm back button và title với responsive design
class AppHeader extends StatelessWidget {
  /// Title text hiển thị ở giữa header
  final String title;

  /// Callback khi nhấn back button (optional)
  /// Nếu null, sẽ dùng default navigation logic
  final VoidCallback? onBackPressed;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Custom text style cho title (optional)
  final TextStyle? titleStyle;

  /// Custom icon cho back button (optional)
  final IconData? backIcon;

  /// Custom color cho back icon (optional)
  final Color? backIconColor;

  /// Fallback route khi không thể pop (default: '/intro')
  final String fallbackRoute;

  /// Height của header (default: 84px từ Figma design)
  final double? height;

  const AppHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.scaleFactor = 1.0,
    this.titleStyle,
    this.backIcon,
    this.backIconColor,
    this.fallbackRoute = '/intro',
    this.height,
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  /// Default navigation logic với safe back navigation
  void _handleBackPress(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      // Safe navigation back or fallback
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(fallbackRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(16)),
      child: SizedBox(
        height: height != null ? _scale(height!) : _scale(84),
        child: Row(
          children: [
            // Back button - Figma: x=16, y=60
            GestureDetector(
              onTap: () => _handleBackPress(context),
              child: Container(
                width: _scale(24),
                height: _scale(24),
                alignment: Alignment.center,
                child: Icon(
                  backIcon ?? Icons.arrow_back_ios,
                  size: _scale(24),
                  color: backIconColor ?? const Color(0xFF4B4B4B),
                ),
              ),
            ),

            // Expanded để title chiếm phần còn lại và center
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: _scale(20),
                        color: const Color(0xFF4B4B4B),
                        height: 1.5,
                      ),
                ),
              ),
            ),

            // Spacer để balance layout (width bằng back button)
            SizedBox(width: _scale(24)),
          ],
        ),
      ),
    );
  }
}
