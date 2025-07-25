import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/forgot_password_data.dart';
import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_character_image.dart';
import '../../common/auth/auth_title.dart';
import '../../common/auth/auth_subtitle.dart';
import '../../common/auth/auth_divider_with_text.dart';
import '../../common/item/recovery_method_option.dart';

/// Forgot password screen - cho phép chọn phương thức khôi phục
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordData _forgotPasswordData = const ForgotPasswordData();

  void _selectRecoveryMethod(RecoveryMethod method) {
    setState(() {
      _forgotPasswordData =
          _forgotPasswordData.copyWith(recoveryMethod: method);
    });

    // Navigate to appropriate screen
    switch (method) {
      case RecoveryMethod.sms:
        context.push('/forgot-password/phone', extra: _forgotPasswordData);
        break;
      case RecoveryMethod.email:
        context.push('/forgot-password/email', extra: _forgotPasswordData);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return AuthScreenLayout(
      child: Column(
        children: [
          // Character image
          AuthCharacterImage(
            imagePath: 'assets/images/auth/forgot_password_character.png',
            width: 116,
            height: 154,
            scaleFactor: scaleFactor,
          ),

          SizedBox(height: 20 * scaleFactor),

          // Title
          AuthTitle(
            text: 'Quên mật khẩu',
            scaleFactor: scaleFactor,
          ),

          SizedBox(height: 24 * scaleFactor),

          // Subtitle
          AuthSubtitle(
            text: 'Ba mẹ muốn nhận mã để đặt lại mật khẩu theo hình thức nào?',
            scaleFactor: scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          ),

          SizedBox(height: 48 * scaleFactor),

          // Options container
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: Column(
              children: [
                // SMS Option
                RecoveryMethodOption(
                  method: RecoveryMethod.sms,
                  title: 'Gửi mã qua SMS',
                  icon: Icons.phone,
                  onTap: () => _selectRecoveryMethod(RecoveryMethod.sms),
                  scaleFactor: scaleFactor,
                  isPrimary: true,
                ),

                SizedBox(height: 24 * scaleFactor),

                // Divider with "Hoặc"
                AuthDividerWithText(
                  text: 'Hoặc',
                  scaleFactor: scaleFactor,
                ),

                SizedBox(height: 24 * scaleFactor),

                // Email Option
                RecoveryMethodOption(
                  method: RecoveryMethod.email,
                  title: 'Gửi mã qua Email',
                  icon: Icons.email,
                  onTap: () => _selectRecoveryMethod(RecoveryMethod.email),
                  scaleFactor: scaleFactor,
                  isPrimary: false,
                ),
              ],
            ),
          ),

          Spacer(),
        ],
      ),
    );
  }
}
