import 'package:flutter/material.dart';
import 'dart:math';

/// Widget dùng chung cho link text với GestureDetector
/// Có thể tái sử dụng với callback và style tùy chỉnh
class CustomLink extends StatelessWidget {
  /// Text hiển thị cho link
  final String text;

  /// Callback khi user tap vào link
  final VoidCallback? onTap;

  /// Scale factor cho responsive design
  final double scale;

  /// Custom text style (nếu muốn override style mặc định)
  final TextStyle? textStyle;

  /// Text alignment (mặc định: center)
  final TextAlign textAlign;

  const CustomLink({
    Key? key,
    required this.text,
    this.onTap,
    this.scale = 1.0,
    this.textStyle,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ?? _getDefaultTextStyle(),
        textAlign: textAlign,
      ),
    );
  }

  /// Style mặc định cho link: fontSize 18, Nunito-ExtraBold, blue color
  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w800,
      fontSize: _scale(18),
      color: const Color(0xFF3393FF),
      height: 1.5,
    );
  }

  /// Tính scaled value
  double _scale(double value) {
    return value * max(0.8, min(scale, 1.8));
  }
}
