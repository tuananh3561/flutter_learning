import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/auth_data.dart';
import '../../../data/models/forgot_password_data.dart';
import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_character_image.dart';
import '../../common/auth/auth_title.dart';
import '../../common/auth/auth_subtitle.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/text_field/email_form.dart';

/// Forgot password email screen - nhập email để khôi phục mật khẩu
class ForgotPasswordEmailScreen extends StatefulWidget {
  final ForgotPasswordData? forgotPasswordData;

  const ForgotPasswordEmailScreen({
    super.key,
    this.forgotPasswordData,
  });

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _emailController = TextEditingController();
  late ForgotPasswordData _forgotPasswordData;

  @override
  void initState() {
    super.initState();
    _forgotPasswordData =
        widget.forgotPasswordData ?? const ForgotPasswordData();
    _emailController.text = _forgotPasswordData.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          email: email,
          emailValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email)) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          email: email,
          emailValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Email không hợp lệ',
          ),
        );
      } else {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          email: email,
          emailValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
      }
    });
  }

  void _onSendOTP() {
    if (_forgotPasswordData.canSendOTP) {
      // TODO: Implement send OTP logic
      context.push('/forgot-password/otp', extra: _forgotPasswordData);
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
            imagePath: 'assets/images/auth/forgot_email_character.png',
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
            text:
                'Ba mẹ đừng lo lắng, hãy nhập địa chỉ email để Monkey hỗ trợ khôi phục mật khẩu nhé.',
            scaleFactor: scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          ),

          SizedBox(height: 48 * scaleFactor),

          // Email form
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: EmailForm(
              controller: _emailController,
              onChanged: _validateEmail,
              validation: _forgotPasswordData.emailValidation,
              scaleFactor: scaleFactor,
            ),
          ),

          Spacer(),

          // Send OTP button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: CustomButton(
              text: 'Gửi OTP',
              onPressed: _forgotPasswordData.canSendOTP ? _onSendOTP : null,
              enabled: _forgotPasswordData.canSendOTP,
              size: ButtonSize.xl,
              customScale: scaleFactor,
            ),
          ),

          SizedBox(height: 40 * scaleFactor),
        ],
      ),
    );
  }
}
