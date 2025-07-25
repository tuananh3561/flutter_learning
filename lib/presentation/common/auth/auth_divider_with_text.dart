import 'package:flutter/material.dart';

/// Widget hiển thị divider với text ở giữa cho auth screens
class AuthDividerWithText extends StatelessWidget {
  final String text;
  final double scaleFactor;
  final double? width;
  final Color dividerColor;
  final Color textColor;

  const AuthDividerWithText({
    super.key,
    required this.text,
    required this.scaleFactor,
    this.width,
    this.dividerColor = const Color(0xFFAFAFAF),
    this.textColor = const Color(0xFF777777),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 324 * scaleFactor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: dividerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 16 * scaleFactor,
                color: textColor,
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
