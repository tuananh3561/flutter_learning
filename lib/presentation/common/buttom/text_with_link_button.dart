import 'package:flutter/material.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_link.dart';

/// Widget kết hợp text thường và link theo thiết kế Figma
/// Dùng cho activation code button và sign up button
class TextWithLinkButton extends StatelessWidget {
  /// Text prefix (phần text thường, màu xám)
  final String prefixText;

  /// Text link (phần có thể click, màu xanh)
  final String linkText;

  /// Callback khi nhấn vào link
  final VoidCallback? onLinkTap;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Custom width (optional, default 380 * scale)
  final double? width;

  /// Background color (optional)
  final Color? backgroundColor;

  /// Border radius (optional)
  final double? borderRadius;

  /// Padding (optional)
  final EdgeInsets? padding;

  /// Text style cho prefix text (optional)
  final TextStyle? prefixTextStyle;

  /// Text style cho link text (optional)
  final TextStyle? linkTextStyle;

  const TextWithLinkButton({
    Key? key,
    required this.prefixText,
    required this.linkText,
    this.onLinkTap,
    this.scaleFactor = 1.0,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.prefixTextStyle,
    this.linkTextStyle,
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? (380 * scaleFactor),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(
          borderRadius != null ? _scale(borderRadius!) : _scale(12),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            borderRadius != null ? _scale(borderRadius!) : _scale(12),
          ),
          onTap: onLinkTap,
          child: Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  // Prefix text (normal text)
                  TextSpan(
                    text: prefixText,
                    style: prefixTextStyle ?? _getDefaultPrefixStyle(),
                  ),
                  // Link text
                  WidgetSpan(
                    child: CustomLink(
                      text: linkText,
                      onTap: onLinkTap,
                      scale: scaleFactor,
                      textStyle: linkTextStyle ?? _getDefaultLinkStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Default style cho prefix text
  TextStyle _getDefaultPrefixStyle() {
    return TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w800,
      fontSize: _scale(16),
      color: const Color(0xFF777777),
      height: 1.4,
    );
  }

  /// Default style cho link text
  TextStyle _getDefaultLinkStyle() {
    return TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w800,
      fontSize: _scale(16),
      color: const Color(0xFF36BFFA), // Blue color for link
      height: 1.4,
    );
  }
}
