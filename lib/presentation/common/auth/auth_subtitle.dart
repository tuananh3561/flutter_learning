import 'package:flutter/material.dart';

/// Widget hiển thị subtitle/description cho auth screens
class AuthSubtitle extends StatelessWidget {
  final String text;
  final double scaleFactor;
  final TextAlign textAlign;
  final double fontSize;
  final Color color;
  final EdgeInsetsGeometry? padding;

  const AuthSubtitle({
    super.key,
    required this.text,
    required this.scaleFactor,
    this.textAlign = TextAlign.center,
    this.fontSize = 16,
    this.color = const Color(0xFF777777),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget subtitle = Text(
      text,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        fontSize: fontSize * scaleFactor,
        color: color,
        height: 1.5,
      ),
      textAlign: textAlign,
    );

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: subtitle,
      );
    }

    return subtitle;
  }
}
