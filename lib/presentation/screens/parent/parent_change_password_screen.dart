import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/change_password_data.dart';
import 'package:flutter_learning/presentation/common/text_field/password_field_component.dart';
import 'package:flutter_learning/presentation/common/app_header.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_button.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_link.dart';

/// Màn hình thay đổi mật khẩu cho parent
class ParentChangePasswordScreen extends StatefulWidget {
  final Function(ChangePasswordData)? onPasswordChanged;

  const ParentChangePasswordScreen({
    super.key,
    this.onPasswordChanged,
  });

  @override
  State<ParentChangePasswordScreen> createState() =>
      _ParentChangePasswordScreenState();
}

class _ParentChangePasswordScreenState
    extends State<ParentChangePasswordScreen> {
  late ChangePasswordData _passwordData;

  @override
  void initState() {
    super.initState();
    _passwordData = ChangePasswordData.getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header using AppHeader
            AppHeader(
              title: 'Thay đổi mật khẩu',
              scaleFactor: scale,
              height: 60,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Column(
                    children: [
                      // Gap to first field - y: 108 (từ top) - 60 (header) - 30 (title height) = 18px
                      SizedBox(height: 18 * scale),

                      // Current password field
                      PasswordFieldComponent(
                        label: 'Mật khẩu hiện tại',
                        placeholder: 'Mật khẩu hiện tại',
                        value: _passwordData.currentPassword,
                        errorText:
                            _passwordData.validation.currentPasswordError,
                        onChanged: _onCurrentPasswordChanged,
                        scale: scale,
                      ),

                      // Gap between fields - theo Figma y: 220 - 108 = 112px, nhưng tối ưu UX
                      SizedBox(height: 48 * scale),

                      // New password field
                      PasswordFieldComponent(
                        label: 'Mật khẩu mới',
                        placeholder: 'Mật khẩu mới',
                        value: _passwordData.newPassword,
                        errorText: _passwordData.validation.newPasswordError,
                        onChanged: _onNewPasswordChanged,
                        scale: scale,
                      ),

                      // Gap between fields - theo Figma y: 332 - 220 = 112px, nhưng tối ưu UX
                      SizedBox(height: 48 * scale),

                      // Confirm password field
                      PasswordFieldComponent(
                        label: 'Nhập lại mật khẩu',
                        placeholder: 'Nhập lại mật khẩu',
                        value: _passwordData.confirmPassword,
                        errorText:
                            _passwordData.validation.confirmPasswordError,
                        onChanged: _onConfirmPasswordChanged,
                        scale: scale,
                      ),

                      // Gap to save button - theo Figma y: 724 - 332 = 392px, nhưng tối ưu UX
                      SizedBox(height: 180 * scale),

                      // Save button using CustomButton
                      CustomButton(
                        text: 'Lưu thay đổi',
                        onPressed:
                            _passwordData.canSave ? _onSavePressed : null,
                        enabled: _passwordData.canSave,
                        type: ButtonType.primary,
                        size: ButtonSize.xl,
                        customScale: scale,
                      ),

                      // Gap to forgot password link - theo Figma y: 802 - 724 = 78px, nhưng tối ưu UX
                      SizedBox(height: 20 * scale),

                      // Forgot password link using CustomLink
                      CustomLink(
                        text: 'Quên mật khẩu',
                        onTap: _onForgotPasswordPressed,
                        scale: scale,
                      ),

                      SizedBox(height: 24 * scale),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle current password change
  void _onCurrentPasswordChanged(String value) {
    setState(() {
      _passwordData = _passwordData.copyWith(
        currentPassword: value,
        validation: ChangePasswordValidation.validateData(
          _passwordData.copyWith(currentPassword: value),
        ),
      );
    });
  }

  /// Handle new password change
  void _onNewPasswordChanged(String value) {
    setState(() {
      _passwordData = _passwordData.copyWith(
        newPassword: value,
        validation: ChangePasswordValidation.validateData(
          _passwordData.copyWith(newPassword: value),
        ),
      );
    });
  }

  /// Handle confirm password change
  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _passwordData = _passwordData.copyWith(
        confirmPassword: value,
        validation: ChangePasswordValidation.validateData(
          _passwordData.copyWith(confirmPassword: value),
        ),
      );
    });
  }

  /// Handle save button press
  void _onSavePressed() {
    if (_passwordData.canSave) {
      // TODO: Implement actual password change logic
      if (widget.onPasswordChanged != null) {
        widget.onPasswordChanged!(_passwordData);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu thay đổi mật khẩu thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  /// Handle forgot password button press
  void _onForgotPasswordPressed() {
    // TODO: Implement forgot password logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng quên mật khẩu sẽ được cập nhật sau!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
