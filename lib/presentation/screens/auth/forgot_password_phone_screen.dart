import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/auth_data.dart';
import '../../../data/models/forgot_password_data.dart';
import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_character_image.dart';
import '../../common/auth/auth_title.dart';
import '../../common/auth/auth_subtitle.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/text_field/phone_form.dart';

/// Forgot password phone screen - nhập số điện thoại để khôi phục mật khẩu
class ForgotPasswordPhoneScreen extends StatefulWidget {
  final ForgotPasswordData? forgotPasswordData;

  const ForgotPasswordPhoneScreen({
    super.key,
    this.forgotPasswordData,
  });

  @override
  State<ForgotPasswordPhoneScreen> createState() =>
      _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState extends State<ForgotPasswordPhoneScreen> {
  final _phoneController = TextEditingController();
  late ForgotPasswordData _forgotPasswordData;

  @override
  void initState() {
    super.initState();
    _forgotPasswordData =
        widget.forgotPasswordData ?? const ForgotPasswordData();
    _phoneController.text = _forgotPasswordData.phoneNumber;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String phone) {
    setState(() {
      if (phone.isEmpty) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          phoneNumber: phone,
          phoneValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (phone.length < 6 || phone.length > 15) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          phoneNumber: phone,
          phoneValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Số điện thoại cần nhập 6-15 chữ số',
          ),
        );
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          phoneNumber: phone,
          phoneValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Số điện thoại không đúng',
          ),
        );
      } else {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          phoneNumber: phone,
          phoneValidation:
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
            imagePath: 'assets/images/auth/forgot_phone_character.png',
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
                'Ba mẹ đừng lo lắng, hãy nhập số điện thoại để Monkey hỗ trợ khôi phục mật khẩu nhé.',
            scaleFactor: scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          ),

          SizedBox(height: 48 * scaleFactor),

          // Phone form
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: PhoneForm(
              controller: _phoneController,
              onChanged: _validatePhone,
              validation: _forgotPasswordData.phoneValidation,
              scaleFactor: scaleFactor,
              hintText: '123456789',
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
