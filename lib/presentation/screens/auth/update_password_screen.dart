import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_learning/core/services/lottie_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/auth_data.dart';
import '../../../data/models/forgot_password_data.dart';

/// Update password screen - cập nhật mật khẩu mới
class UpdatePasswordScreen extends StatefulWidget {
  final ForgotPasswordData? forgotPasswordData;

  const UpdatePasswordScreen({
    super.key,
    this.forgotPasswordData,
  });

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late ForgotPasswordData _forgotPasswordData;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _forgotPasswordData =
        widget.forgotPasswordData ?? const ForgotPasswordData();
    _newPasswordController.text = _forgotPasswordData.newPassword;
    _confirmPasswordController.text = _forgotPasswordData.confirmPassword;
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  double _getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return math.min(screenWidth / 428.0, screenHeight / 926.0).clamp(0.8, 1.8);
  }

  void _validateNewPassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          newPassword: password,
          passwordValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (password.length < 6) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          newPassword: password,
          passwordValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Mật khẩu cần ít nhất 6 ký tự',
          ),
        );
      } else {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          newPassword: password,
          passwordValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
      }
      _updateState();
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      if (confirmPassword.isEmpty) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation:
              const FormFieldValidation(state: ValidationState.initial),
        );
      } else if (confirmPassword != _newPasswordController.text) {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation: const FormFieldValidation(
            state: ValidationState.invalid,
            errorMessage: 'Mật khẩu không trùng khớp',
          ),
        );
      } else {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          confirmPassword: confirmPassword,
          confirmPasswordValidation:
              const FormFieldValidation(state: ValidationState.valid),
        );
      }
      _updateState();
    });
  }

  void _updateState() {
    if (_forgotPasswordData.canUpdatePassword) {
      _forgotPasswordData = _forgotPasswordData.copyWith(
        updatePasswordState: UpdatePasswordState.filled,
      );
    } else if (_newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      _forgotPasswordData = _forgotPasswordData.copyWith(
        updatePasswordState: UpdatePasswordState.unfilled,
      );
    } else {
      _forgotPasswordData = _forgotPasswordData.copyWith(
        updatePasswordState: UpdatePasswordState.unfilled,
      );
    }
  }

  void _onUpdatePassword() {
    if (_forgotPasswordData.canUpdatePassword) {
      // TODO: Implement update password logic
      // For now, simulate success
      setState(() {
        _forgotPasswordData = _forgotPasswordData.copyWith(
          updatePasswordState: UpdatePasswordState.success,
        );
      });

      // Navigate to sign in after delay
      Future.delayed(const Duration(seconds: 2), () {
        context.go('/sign-in');
      });
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required Function(String) onChanged,
    required FormFieldValidation validation,
    required double scaleFactor,
    required double topPosition,
  }) {
    return Positioned(
      left: 24 * scaleFactor,
      top: topPosition,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 380 * scaleFactor,
            height: 56 * scaleFactor,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(12 * scaleFactor),
              border: Border.all(
                color: validation.state == ValidationState.invalid
                    ? const Color(0xFFFF4B4B)
                    : validation.state == ValidationState.valid
                        ? const Color(0xFF92C73D)
                        : const Color(0xFFAFAFAF),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // TextFormField (hidden)
                Positioned.fill(
                  child: TextFormField(
                    controller: controller,
                    obscureText: !isVisible,
                    onChanged: onChanged,
                    style: const TextStyle(
                      color: Colors.transparent,
                    ),
                    cursorColor: Colors.transparent,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24 * scaleFactor,
                        vertical: 16 * scaleFactor,
                      ),
                    ),
                  ),
                ),

                // Custom display
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24 * scaleFactor,
                        vertical: 16 * scaleFactor,
                      ),
                      child: Row(
                        children: [
                          // Password text or placeholder
                          Expanded(
                            child: Text(
                              controller.text.isEmpty ? label : controller.text,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 20 * scaleFactor,
                                color: controller.text.isEmpty
                                    ? const Color(0xFFAFAFAF)
                                    : const Color(0xFF4B4B4B),
                                height: 1.5,
                              ),
                            ),
                          ),

                          // Eye icon
                          GestureDetector(
                            onTap: onToggleVisibility,
                            child: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24 * scaleFactor,
                              color: const Color(0xFFAFAFAF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Success/Error message
          if (validation.state == ValidationState.valid)
            Padding(
              padding: EdgeInsets.only(top: 8 * scaleFactor),
              child: Text(
                label.contains('lại')
                    ? 'Mật khẩu trùng khớp'
                    : 'Mật khẩu khả dụng',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * scaleFactor,
                  color: const Color(0xFF92C73D),
                  height: 1.5,
                ),
              ),
            )
          else if (validation.state == ValidationState.invalid)
            Padding(
              padding: EdgeInsets.only(top: 8 * scaleFactor),
              child: Text(
                validation.errorMessage ?? '',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * scaleFactor,
                  color: const Color(0xFFFF4B4B),
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = _getScaleFactor(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            height: math.max(screenHeight, 926 * scaleFactor),
            child: Stack(
              children: [
                // Back button
                Positioned(
                  left: 24 * scaleFactor,
                  top: 60 * scaleFactor,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 24 * scaleFactor,
                      height: 24 * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12 * scaleFactor),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: 24 * scaleFactor,
                        color: const Color(0xFF4B4B4B),
                      ),
                    ),
                  ),
                ),

                // Character image
                // Positioned(
                //   left: 147 * scaleFactor,
                //   top: 75.5 * scaleFactor,
                //   child: Image.asset(
                //     'assets/images/auth/update_password_character.png',
                //     width: 134 * scaleFactor,
                //     height: 152 * scaleFactor,
                //     fit: BoxFit.contain,
                //   ),
                // ),

                Lottie.asset(
                  'assets/lottie/monkey_write.lottie',
                  decoder: customDecoder,
                  width: 134,
                  height: 152,
                ),

                // Title
                Positioned(
                  left: 105 * scaleFactor,
                  top: 236 * scaleFactor,
                  child: Text(
                    'Cập nhật mật khẩu',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 24 * scaleFactor,
                      color: const Color(0xFF4B4B4B),
                      height: 1.5,
                    ),
                  ),
                ),

                // New password field
                _buildPasswordField(
                  label: 'Mật khẩu mới',
                  controller: _newPasswordController,
                  isVisible: _isNewPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  onChanged: _validateNewPassword,
                  validation: _forgotPasswordData.passwordValidation,
                  scaleFactor: scaleFactor,
                  topPosition: 315 * scaleFactor,
                ),

                // Confirm password field
                _buildPasswordField(
                  label: 'Nhập lại mật khẩu',
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  onChanged: _validateConfirmPassword,
                  validation: _forgotPasswordData.confirmPasswordValidation,
                  scaleFactor: scaleFactor,
                  topPosition: 393 * scaleFactor,
                ),

                // Update button
                Positioned(
                  left: 24 * scaleFactor,
                  top: 801.5 * scaleFactor,
                  child: GestureDetector(
                    onTap: _forgotPasswordData.canUpdatePassword
                        ? _onUpdatePassword
                        : null,
                    child: Container(
                      width: 380 * scaleFactor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32 * scaleFactor,
                        vertical: 12 * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: _forgotPasswordData.canUpdatePassword
                            ? const Color(0xFF36BFFA)
                            : const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(12 * scaleFactor),
                        boxShadow: [
                          BoxShadow(
                            color: _forgotPasswordData.canUpdatePassword
                                ? const Color(0xFF00B2FF)
                                : const Color(0xFFAFAFAF),
                            offset: Offset(0, 4 * scaleFactor),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Cập nhật',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 20 * scaleFactor,
                            color: _forgotPasswordData.canUpdatePassword
                                ? Colors.white
                                : const Color(0xFFAFAFAF),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Success overlay (shown when updatePasswordState is success)
                if (_forgotPasswordData.updatePasswordState ==
                    UpdatePasswordState.success)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Container(
                          width: 300 * scaleFactor,
                          height: 200 * scaleFactor,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16 * scaleFactor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 64 * scaleFactor,
                                color: const Color(0xFF92C73D),
                              ),
                              SizedBox(height: 16 * scaleFactor),
                              Text(
                                'Cập nhật mật khẩu thành công!',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18 * scaleFactor,
                                  color: const Color(0xFF4B4B4B),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8 * scaleFactor),
                              Text(
                                'Đang chuyển hướng đến màn hình đăng nhập...',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * scaleFactor,
                                  color: const Color(0xFF777777),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
