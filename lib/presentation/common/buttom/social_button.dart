import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/auth_data.dart';

/// Social Button Component có thể tái sử dụng
/// Hỗ trợ Facebook, Google, Apple login
class SocialButton extends StatelessWidget {
  /// Loại social login
  final SocialLoginType type;

  /// Callback khi button được nhấn
  final VoidCallback? onPressed;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Custom width (optional, default sẽ expand)
  final double? width;

  /// Custom height (optional)
  final double? height;

  const SocialButton({
    Key? key,
    required this.type,
    this.onPressed,
    this.scaleFactor = 1.0,
    this.width,
    this.height,
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    final config = _getSocialConfig(type);

    return Container(
      width: width,
      height: height ?? _scale(44),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(_scale(8)),
        border: config.borderColor != null
            ? Border.all(color: config.borderColor!, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D101828),
            offset: Offset(0, _scale(1)),
            blurRadius: _scale(2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_scale(8)),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(_scale(10)),
            child: Icon(
              config.icon,
              color: config.iconColor,
              size: _scale(24),
            ),
          ),
        ),
      ),
    );
  }

  /// Lấy config cho từng loại social button
  _SocialButtonConfig _getSocialConfig(SocialLoginType type) {
    switch (type) {
      case SocialLoginType.facebook:
        return _SocialButtonConfig(
          backgroundColor: const Color(0xFF1877F2),
          iconColor: Colors.white,
          icon: Icons.facebook,
        );
      case SocialLoginType.google:
        return _SocialButtonConfig(
          backgroundColor: Colors.white,
          iconColor: const Color(0xFF424242),
          icon: Icons.g_mobiledata,
          borderColor: const Color(0xFFD0D5DD),
        );
      case SocialLoginType.apple:
        return _SocialButtonConfig(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
          icon: Icons.apple,
        );
    }
  }
}

/// Helper class cho social button config
class _SocialButtonConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Color? borderColor;

  _SocialButtonConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    this.borderColor,
  });
}
