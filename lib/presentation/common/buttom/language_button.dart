import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/language_provider.dart';

/// Language Button widget có thể dùng chung
/// Hiển thị flag, text và settings icon theo thiết kế Figma
class LanguageButton extends StatelessWidget {
  final double scale;
  final String languageCode;
  final Color flagColor;
  final Color starColor;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;

  const LanguageButton({
    Key? key,
    this.scale = 1.0,
    this.languageCode = 'VN',
    this.flagColor = const Color(0xFFEA403F),
    this.starColor = const Color(0xFFFFFE4E),
    this.textColor = const Color(0xFF777777),
    this.iconColor = const Color(0xFFAFAFAF),
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE5E5E5),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8 * scale),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(
            color: borderColor,
            width: 2 * scale,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flag container - Figma: 34x24px
            Container(
              width: 34 * scale,
              height: 24 * scale,
              decoration: BoxDecoration(
                color: flagColor,
                borderRadius: BorderRadius.circular(4 * scale),
                border: Border.all(
                  color: Colors.white,
                  width: 3 * scale,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.star,
                  size: 14.57 * scale,
                  color: starColor,
                ),
              ),
            ),

            SizedBox(width: 8 * scale),

            // Language code text - Figma: fontSize 16, Nunito-ExtraBold
            Text(
              languageCode,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 16 * scale,
                color: textColor,
                height: 1.5,
              ),
            ),

            SizedBox(width: 8 * scale),

            // Settings icon - Figma: 24x24px
            Icon(
              Icons.settings_outlined,
              size: 24 * scale,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive Language Button sử dụng LanguageProvider
/// Tự động hiển thị ngôn ngữ hiện tại và update khi thay đổi
class ResponsiveLanguageButton extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const ResponsiveLanguageButton({
    Key? key,
    this.scale = 1.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return LanguageButton(
          scale: scale,
          languageCode: languageProvider.currentShortDisplayName,
          flagColor: languageProvider.currentFlagColor,
          starColor: languageProvider.currentStarColor,
          onTap: onTap,
        );
      },
    );
  }
}

/// Language Button với positioning cho Intro Screen
/// Wrapper riêng để maintain backward compatibility
class PositionedLanguageButton extends StatelessWidget {
  final double scale;
  final double rightPosition;
  final double topPadding;
  final VoidCallback? onTap;

  const PositionedLanguageButton({
    Key? key,
    this.scale = 1.0,
    this.rightPosition = 24,
    this.topPadding = 65,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: rightPosition * scale,
      top: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: topPadding * scale),
          child: ResponsiveLanguageButton(
            scale: scale,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
