import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/core/services/lottie_utils.dart';
import 'package:flutter_learning/presentation/common/text_field/phone_input_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/auth_data.dart';
import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_character_image.dart';
import '../../common/auth/auth_title.dart';
import '../../common/auth/auth_social_login_section.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/buttom/text_with_link_button.dart';
import '../../common/text_field/phone_form.dart';

/// Sign up phone screen - first step of sign up flow
class SignUpPhoneScreen extends StatefulWidget {
  const SignUpPhoneScreen({super.key});

  @override
  State<SignUpPhoneScreen> createState() => _SignUpPhoneScreenState();
}

class _SignUpPhoneScreenState extends State<SignUpPhoneScreen> {
  final _phoneController = TextEditingController();
  SignUpData _signUpData = const SignUpData();
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String phone) {
    setState(() {
      if (phone.isEmpty) {
        _signUpData = _signUpData.copyWith(
          phoneNumber: phone,
          phoneValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
        _isPhoneValid = false;
      } else if (phone.length < 6 || phone.length > 15) {
        _signUpData = _signUpData.copyWith(
          phoneNumber: phone,
          phoneValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Số điện thoại cần nhập 6-15 chữ số',
          ),
        );
        _isPhoneValid = false;
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _signUpData = _signUpData.copyWith(
          phoneNumber: phone,
          phoneValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Số điện thoại không đúng',
          ),
        );
        _isPhoneValid = false;
      } else {
        _signUpData = _signUpData.copyWith(
          phoneNumber: phone,
          phoneValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
        _isPhoneValid = true;
      }
    });
  }

  void _onContinue() {
    if (_isPhoneValid && _signUpData.phoneNumber.isNotEmpty) {
      context.push('/sign-up/password', extra: _signUpData);
    }
  }

  void _onSocialLogin(SocialLoginType type) {
    // TODO: Implement social login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đăng nhập ${type.name} đang được phát triển')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return AuthScreenLayout(
      child: Column(
        children: [
          // Character image
          // AuthCharacterImage(
          //   imagePath: 'assets/images/auth/sign_up_character.png',
          //   width: 151,
          //   height: 169,
          //   scaleFactor: scaleFactor,
          // ),

          Lottie.asset(
            'assets/lottie/monkey_hello.lottie',
            decoder: customDecoder,
            width: 151,
            height: 169,
          ),

          SizedBox(height: 24 * scaleFactor),

          // Title
          // AuthTitle(
          //   text: 'Nhập số điện thoại',
          //   scaleFactor: scaleFactor,
          //   textAlign: TextAlign.left,
          //   padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          // ),

          SizedBox(height: 24 * scaleFactor),

          // Phone form
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          //   child: PhoneForm(
          //     controller: _phoneController,
          //     onChanged: _validatePhone,
          //     validation: _signUpData.phoneValidation,
          //     scaleFactor: scaleFactor,
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: PhoneInput(
              controller: _phoneController,
              onCountryChange: (countryCode) {},
              onPhoneChanged: _validatePhone,
              errorText: "",
              isPhoneValid: _signUpData.phoneValidation.isValid,
              initialCountryCode: "VN",
            ),
          ),

          Spacer(),

          // Continue button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: CustomButton(
              text: 'Tiếp tục',
              onPressed: _isPhoneValid ? _onContinue : null,
              enabled: _isPhoneValid,
              size: ButtonSize.xl,
              customScale: scaleFactor,
            ),
          ),

          SizedBox(height: 40 * scaleFactor),

          // Social login section
          AuthSocialLoginSection(
            scaleFactor: scaleFactor,
            onSocialLogin: _onSocialLogin,
            dividerText: 'Hoặc đăng ký với',
          ),

          SizedBox(height: 24 * scaleFactor),

          // Sign in link
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: TextWithLinkButton(
              prefixText: 'Tôi đã có tài khoản. ',
              linkText: 'Đăng nhập',
              onLinkTap: () => context.push('/sign-in'),
              scaleFactor: scaleFactor,
            ),
          ),

          SizedBox(height: 40 * scaleFactor),
        ],
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.controller,
    required this.onCountryChange,
    required this.onPhoneChanged,
    this.isLoading = false,
    this.errorText,
    this.isPhoneValid = false,
    this.initialCountryCode = 'VN',
    this.onCountryInit,
  });

  final TextEditingController controller;
  final void Function(String) onCountryChange;
  final void Function(String) onPhoneChanged;
  final bool isLoading;
  final String? errorText;
  final bool isPhoneValid;
  final String initialCountryCode;
  final void Function(String)? onCountryInit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Nhập số điện thoại",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        PhoneInputField(
          controller: controller,
          onCountryChange: onCountryChange,
          onChanged: onPhoneChanged,
          isLoading: isLoading,
          errorText: errorText,
          isPhoneValid: isPhoneValid,
          initialCountryCode: initialCountryCode,
          onCountryInit: onCountryInit,
        ),
      ],
    );
  }
}
