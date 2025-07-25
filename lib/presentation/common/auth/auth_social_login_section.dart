import 'package:flutter/material.dart';
import '../../../data/models/auth_data.dart';
import '../buttom/social_button.dart';
import 'auth_divider_with_text.dart';

/// Widget hiển thị social login section cho auth screens
class AuthSocialLoginSection extends StatelessWidget {
  final double scaleFactor;
  final Function(SocialLoginType) onSocialLogin;
  final String dividerText;
  final double? spacing;
  final double? dividerSpacing;
  final double? horizontalPadding;

  const AuthSocialLoginSection({
    super.key,
    required this.scaleFactor,
    required this.onSocialLogin,
    this.dividerText = 'Hoặc đăng nhập với',
    this.spacing = 24,
    this.dividerSpacing = 12,
    this.horizontalPadding = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        AuthDividerWithText(
          text: dividerText,
          scaleFactor: scaleFactor,
        ),

        SizedBox(height: dividerSpacing! * scaleFactor),

        // Social login buttons
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding! * scaleFactor),
          child: Row(
            children: [
              // Facebook button
              Expanded(
                child: SocialButton(
                  type: SocialLoginType.facebook,
                  onPressed: () => onSocialLogin(SocialLoginType.facebook),
                  scaleFactor: scaleFactor,
                ),
              ),
              SizedBox(width: 12 * scaleFactor),

              // Google button
              Expanded(
                child: SocialButton(
                  type: SocialLoginType.google,
                  onPressed: () => onSocialLogin(SocialLoginType.google),
                  scaleFactor: scaleFactor,
                ),
              ),
              SizedBox(width: 12 * scaleFactor),

              // Apple button
              Expanded(
                child: SocialButton(
                  type: SocialLoginType.apple,
                  onPressed: () => onSocialLogin(SocialLoginType.apple),
                  scaleFactor: scaleFactor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
