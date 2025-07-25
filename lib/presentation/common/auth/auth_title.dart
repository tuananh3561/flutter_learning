import 'package:flutter/material.dart';

/// Widget hiển thị title cho auth screens
class AuthTitle extends StatelessWidget {
  final String text;
  final double scaleFactor;
  final TextAlign textAlign;
  final double fontSize;
  final Color color;
  final EdgeInsetsGeometry? padding;

  const AuthTitle({
    super.key,
    required this.text,
    required this.scaleFactor,
    this.textAlign = TextAlign.center,
    this.fontSize = 24,
    this.color = const Color(0xFF4B4B4B),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      text,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w800,
        fontSize: fontSize * scaleFactor,
        color: color,
        height: 1.5,
      ),
      textAlign: textAlign,
    );

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: title,
      );
    }

    return title;
  }
}
