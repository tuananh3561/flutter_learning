import 'package:flutter/material.dart';
import 'package:flutter_learning/core/services/lottie_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_learning/data/models/auth_data.dart';
import 'package:flutter_learning/presentation/common/auth/auth_screen_layout.dart';
import 'package:flutter_learning/presentation/common/auth/auth_character_image.dart';
import 'package:flutter_learning/presentation/common/auth/auth_social_login_section.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_button.dart';
import 'package:flutter_learning/presentation/common/buttom/text_with_link_button.dart';
import 'package:flutter_learning/presentation/common/text_field/phone_text_field.dart';
import 'package:flutter_learning/presentation/common/text_field/password_text_field.dart';

/// Màn hình Sign In theo thiết kế Figma
/// Kích thước base: 428x926px
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _activationCodeController = TextEditingController();

  // Form validation
  FormFieldValidation _phoneValidation = const FormFieldValidation();
  FormFieldValidation _passwordValidation = const FormFieldValidation();

  // Device ID (simulated)
  final String _deviceId = "100600";

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _activationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return AuthScreenLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character image
            // AuthCharacterImage(
            //   imagePath: 'assets/images/auth/sign_in_character.png',
            //   width: 151,
            //   height: 169,
            //   scaleFactor: scaleFactor,
            //   topMargin: 0,
            // ),

            Lottie.asset(
              'assets/lottie/monkey_hello.lottie',
              decoder: customDecoder,
              width: 151,
              height: 169,
            ),

            SizedBox(height: 24 * scaleFactor),

            // Sign in form
            _buildSignInForm(scaleFactor),

            SizedBox(height: 24 * scaleFactor),

            // Login button
            CustomButton(
              text: 'Đăng nhập',
              onPressed:
                  (_phoneValidation.isValid && _passwordValidation.isValid)
                      ? _handleLogin
                      : null,
              enabled: _phoneValidation.isValid && _passwordValidation.isValid,
              size: ButtonSize.xl,
              customScale: scaleFactor,
              maxWidth: 380 * scaleFactor,
            ),

            SizedBox(height: 16 * scaleFactor),

            // Activation code button
            TextWithLinkButton(
              prefixText: 'Nếu bạn có mã kích hoạt, ',
              linkText: 'Nhập tại đây.',
              onLinkTap: _handleActivationCode,
              scaleFactor: scaleFactor,
            ),

            SizedBox(height: 40 * scaleFactor),

            // Social login section
            AuthSocialLoginSection(
              scaleFactor: scaleFactor,
              onSocialLogin: _handleSocialLogin,
              horizontalPadding: 0,
            ),

            SizedBox(height: 12 * scaleFactor),

            // Sign up button
            TextWithLinkButton(
              prefixText: 'Bạn chưa có tài khoản? ',
              linkText: 'Đăng ký',
              onLinkTap: _handleSignUp,
              scaleFactor: scaleFactor,
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng form đăng nhập
  Widget _buildSignInForm(double scale) {
    return Column(
      children: [
        // Phone number / Username field
        PhoneTextField(
          controller: _phoneController,
          validation: _phoneValidation,
          onChanged: _validatePhone,
          scaleFactor: scale,
        ),

        SizedBox(height: 12 * scale),

        // Password field
        PasswordTextField(
          controller: _passwordController,
          validation: _passwordValidation,
          onChanged: _validatePassword,
          scaleFactor: scale,
        ),

        SizedBox(height: 16 * scale),

        // Device ID and Forgot password
        _buildDeviceIdAndForgotPassword(scale),
      ],
    );
  }

  /// Xây dựng device ID và forgot password
  Widget _buildDeviceIdAndForgotPassword(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ID thiết bị: $_deviceId',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16 * scale,
            color: const Color(0xFFAFAFAF),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle forgot password
            context.push('/forgot-password');
          },
          child: Text(
            'Quên mật khẩu?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 16 * scale,
              color: const Color(0xFF777777),
            ),
          ),
        ),
      ],
    );
  }

  /// Validate phone number
  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneValidation = const FormFieldValidation(
          state: ValidationState.initial,
        );
      } else if (value.length < 6 || value.length > 15) {
        _phoneValidation = const FormFieldValidation(
          state: ValidationState.invalid,
          errorMessage: 'Số điện thoại cần nhập 6 - 15 chữ số',
        );
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _phoneValidation = const FormFieldValidation(
          state: ValidationState.invalid,
          errorMessage: 'Số điện thoại không đúng',
        );
      } else {
        _phoneValidation = FormFieldValidation(
          state: ValidationState.valid,
          value: value,
        );
      }
    });
  }

  /// Validate password
  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordValidation = const FormFieldValidation(
          state: ValidationState.initial,
        );
      } else if (value.length < 6) {
        _passwordValidation = const FormFieldValidation(
          state: ValidationState.invalid,
          errorMessage: 'Mật khẩu phải có ít nhất 6 ký tự',
        );
      } else {
        _passwordValidation = FormFieldValidation(
          state: ValidationState.valid,
          value: value,
        );
      }
    });
  }

  /// Handle login
  void _handleLogin() {
    // Implement login logic
    print('Login with: ${_phoneController.text}, ${_passwordController.text}');
    // Navigate to profile list screen
    context.go('/profile');
  }

  /// Handle activation code
  void _handleActivationCode() {
    // Show activation code dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nhập mã kích hoạt'),
        content: TextField(
          controller: _activationCodeController,
          decoration: const InputDecoration(
            hintText: 'Mã kích hoạt',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle activation
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  /// Handle social login
  void _handleSocialLogin(SocialLoginType type) {
    print('Social login with: $type');
    // Implement social login logic
  }

  /// Handle sign up
  void _handleSignUp() {
    // Navigate to sign up screen
    context.push('/auth/signup');
  }
}
