import 'package:flutter/material.dart';

/// Widget hiển thị character image cho auth screens
class AuthCharacterImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double scaleFactor;
  final double topMargin;

  const AuthCharacterImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.scaleFactor,
    this.topMargin = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin * scaleFactor),
      child: Image.asset(
        imagePath,
        width: width * scaleFactor,
        height: height * scaleFactor,
        fit: BoxFit.contain,
      ),
    );
  }
}
