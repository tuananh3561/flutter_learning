import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/core/services/lottie_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/auth_data.dart';
import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_character_image.dart';
import '../../common/auth/auth_title.dart';
import '../../common/auth/auth_social_login_section.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/buttom/text_with_link_button.dart';
import '../../common/text_field/password_input_widget.dart';
import '../../common/text_field/password_text_field.dart';

/// Sign up password screen - second step of sign up flow
class SignUpPasswordScreen extends StatefulWidget {
  final SignUpData? signUpData;

  const SignUpPasswordScreen({
    super.key,
    this.signUpData,
  });

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late SignUpData _signUpData;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _signUpData = widget.signUpData ?? const SignUpData();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _signUpData = _signUpData.copyWith(
          password: password,
          passwordValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (password.length < 6) {
        _signUpData = _signUpData.copyWith(
          password: password,
          passwordValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Mật khẩu cần ít nhất 6 ký tự',
          ),
        );
      } else {
        _signUpData = _signUpData.copyWith(
          password: password,
          passwordValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
      }
      _updateCanContinue();
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      if (confirmPassword.isEmpty) {
        _signUpData = _signUpData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (confirmPassword != _passwordController.text) {
        _signUpData = _signUpData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Mật khẩu không trùng khớp',
          ),
        );
      } else {
        _signUpData = _signUpData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
      }
      _updateCanContinue();
    });
  }

  void _updateCanContinue() {
    _canContinue = _signUpData.isPasswordValid &&
        _signUpData.isConfirmPasswordValid &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void _onContinue() {
    if (_canContinue) {
      // TODO: Implement sign up completion
      context.push('/welcome');
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
          AuthCharacterImage(
            imagePath: 'assets/images/auth/sign_up_character.png',
            width: 151,
            height: 169,
            scaleFactor: scaleFactor,
          ),

          Lottie.asset(
            'assets/lottie/monkey_hello.lottie',
            decoder: customDecoder,
            width: 151,
            height: 169,
          ),

          SizedBox(height: 24 * scaleFactor),

          // // Title
          // AuthTitle(
          //   text: 'Tạo mật khẩu',
          //   scaleFactor: scaleFactor,
          //   textAlign: TextAlign.left,
          //   padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          // ),

          // SizedBox(height: 32 * scaleFactor),

          // // Password field
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          //   child: PasswordTextField(
          //     controller: _passwordController,
          //     onChanged: _validatePassword,
          //     validation: _signUpData.passwordValidation,
          //     scaleFactor: scaleFactor,
          //     hintText: 'Mật khẩu mới',
          //   ),
          // ),

          // SizedBox(height: 24 * scaleFactor),

          // // Confirm password field
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
          //   child: PasswordTextField(
          //     controller: _confirmPasswordController,
          //     onChanged: _validateConfirmPassword,
          //     validation: _signUpData.confirmPasswordValidation,
          //     scaleFactor: scaleFactor,
          //     hintText: 'Nhập lại mật khẩu',
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: PasswordInput(
              controllerPassword: _passwordController,
              controllerConfirmPassword: _confirmPasswordController,
              onChangedPassword: _validatePassword,
              onChangedConfirmPassword: _validateConfirmPassword,
              isShowPassword: true,
              isShowConfirmPassword: true,
              toggleShowPassword: () {},
              toggleShowConfirmPassword: () {},
              focusNode: FocusNode(),
              passwordErrorText: "",
              confirmPasswordErrorText: "",
              isPasswordValid: _signUpData.passwordValidation.isValid,
              isConfirmPasswordValid:
                  _signUpData.confirmPasswordValidation.isValid,
            ),
          ),

          Spacer(),

          // Continue button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
            child: CustomButton(
              text: 'Tiếp tục',
              onPressed: _canContinue ? _onContinue : null,
              enabled: _canContinue,
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

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.controllerPassword,
    required this.controllerConfirmPassword,
    required this.onChangedPassword,
    required this.onChangedConfirmPassword,
    required this.isShowPassword,
    required this.isShowConfirmPassword,
    required this.toggleShowPassword,
    required this.toggleShowConfirmPassword,
    required this.focusNode,
    this.passwordErrorText,
    this.confirmPasswordErrorText,
    this.isPasswordValid = false,
    this.isConfirmPasswordValid = false,
  });

  final TextEditingController controllerPassword;
  final TextEditingController controllerConfirmPassword;
  final bool isShowPassword;
  final bool isShowConfirmPassword;
  final void Function(String) onChangedPassword;
  final void Function(String) onChangedConfirmPassword;
  final VoidCallback toggleShowPassword;
  final VoidCallback toggleShowConfirmPassword;
  final String? passwordErrorText;
  final String? confirmPasswordErrorText;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Nhập mật khẩu",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        PasswordInputField(
          controller: controllerPassword,
          onChanged: onChangedPassword,
          hintText: "Mật khẩu mới",
          obscureText: !isShowPassword,
          onObscureTextToggle: toggleShowPassword,
          errorText: passwordErrorText,
          isPasswordValid: isPasswordValid,
          passwordValidText: "Mật khẩu hợp lệ",
          focusNode: focusNode,
        ),
        const SizedBox(height: 16),
        PasswordInputField(
          controller: controllerConfirmPassword,
          onChanged: onChangedConfirmPassword,
          hintText: "Nhập lại mật khẩu",
          obscureText: !isShowConfirmPassword,
          onObscureTextToggle: toggleShowConfirmPassword,
          errorText: confirmPasswordErrorText,
          isPasswordValid: isConfirmPasswordValid,
          passwordValidText: "Mật khẩu hợp lệ",
        ),
      ],
    );
  }
}
