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
import '../../common/text_field/otp_input.dart';

/// Forgot password OTP screen - xác nhận mã OTP
class ForgotPasswordOTPScreen extends StatefulWidget {
  final ForgotPasswordData? forgotPasswordData;

  const ForgotPasswordOTPScreen({
    super.key,
    this.forgotPasswordData,
  });

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  late ForgotPasswordData _forgotPasswordData;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _forgotPasswordData =
        widget.forgotPasswordData ?? const ForgotPasswordData();
    _otp = _forgotPasswordData.otp;
  }

  void _onOTPChanged(String otp) {
    _otp = otp;
    _validateOTP(_otp);
  }

  void _validateOTP(String otp) {
    setState(() {
      if (otp.length == 4) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          otp: otp,
          otpValidation:
              const FormFieldValidation(state: ValidationState.valid),
          otpState: OTPState.filled,
        );
      } else if (otp.length > 0) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          otp: otp,
          otpValidation:
              const FormFieldValidation(state: ValidationState.initial),
          otpState: OTPState.unfilled,
        );
      } else {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          otp: otp,
          otpValidation:
              const FormFieldValidation(state: ValidationState.initial),
          otpState: OTPState.unfilled,
        );
      }
    });
  }

  void _onVerifyOTP() {
    if (_forgotPasswordData.canVerifyOTP) {
      // TODO: Implement verify OTP logic
      // For now, simulate success
      setState(() {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          otpState: OTPState.success,
        );
      });

      // Navigate to update password after delay
      Future.delayed(const Duration(seconds: 1), () {
        context.push('/forgot-password/update-password',
            extra: _forgotPasswordData);
      });
    }
  }

  void _onResendOTP() {
    // TODO: Implement resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi lại mã OTP')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return AuthScreenLayout(
      child: Column(
        children: [
          // Character image
          AuthCharacterImage(
            imagePath: 'assets/images/auth/otp_character.png',
            width: 158,
            height: 150,
            scaleFactor: scaleFactor,
          ),

          SizedBox(height: 20 * scaleFactor),

          // Title
          AuthTitle(
            text: 'Xác nhận OTP',
            scaleFactor: scaleFactor,
          ),

          SizedBox(height: 24 * scaleFactor),

          // Subtitle
          AuthSubtitle(
            text:
                'Monkey đã gửi mã OTP đến ${_forgotPasswordData.recoveryMethod == RecoveryMethod.sms ? 'số điện thoại' : 'email'}\n${_forgotPasswordData.formattedContactInfo}',
            scaleFactor: scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          ),

          SizedBox(height: 48 * scaleFactor),

          // OTP Input
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: OTPInput(
              onChanged: _onOTPChanged,
              scaleFactor: scaleFactor,
              initialValue: _otp,
              autoFocus: true,
            ),
          ),

          Spacer(),

          // Buttons
          Column(
            children: [
              // Confirm button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
                child: CustomButton(
                  text: 'Xác nhận',
                  onPressed:
                      _forgotPasswordData.canVerifyOTP ? _onVerifyOTP : null,
                  enabled: _forgotPasswordData.canVerifyOTP,
                  size: ButtonSize.xl,
                  customScale: scaleFactor,
                ),
              ),

              SizedBox(height: 24 * scaleFactor),

              // Resend OTP button
              GestureDetector(
                onTap: _onResendOTP,
                child: Text(
                  'Gửi lại OTP',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 18 * scaleFactor,
                    color: const Color(0xFF3393FF),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40 * scaleFactor),
        ],
      ),
    );
  }
}
