import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_learning/presentation/common/auth/auth_screen_layout.dart';
import 'package:flutter_learning/presentation/common/auth/auth_character_image.dart';
import 'package:flutter_learning/presentation/common/auth/auth_title.dart';
import 'package:flutter_learning/presentation/common/auth/auth_subtitle.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_button.dart';
import 'package:flutter_learning/presentation/common/text_field/otp_input.dart';

/// Màn hình nhập mã kích hoạt (Activation Code)
/// Theo thiết kế Figma node-id=2014-22605
/// Kích thước base: 428x926px
class ActivationScreen extends StatefulWidget {
  /// Source để biết màn hình được gọi từ đâu
  final String? source;

  const ActivationScreen({
    super.key,
    this.source,
  });

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String _activationCode = '';
  bool _isLoading = false;

  void _onActivationCodeChanged(String code) {
    setState(() {
      _activationCode = code;
    });
  }

  void _onActivate() {
    if (_activationCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ mã kích hoạt'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate activation process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // TODO: Implement actual activation logic
      // For now, just show success message and navigate
      if (_activationCode == '1234') {
        // Success case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kích hoạt thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate based on source
        if (widget.source == 'intro') {
          context.go('/sign-in');
        } else {
          context.go('/home');
        }
      } else {
        // Error case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mã kích hoạt không chính xác'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _onCancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return AuthScreenLayout(
      showHeader: true,
      headerTitle: 'Kích hoạt tài khoản',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character Image
            AuthCharacterImage(
              imagePath: 'assets/images/auth/otp_character.png',
              width: 200,
              height: 160,
              scaleFactor: scaleFactor,
            ),

            SizedBox(height: 48 * scaleFactor),

            // Title
            AuthTitle(
              text: 'Nhập mã kích hoạt',
              scaleFactor: scaleFactor,
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            ),

            SizedBox(height: 16 * scaleFactor),

            // Subtitle
            AuthSubtitle(
              text: 'Vui lòng nhập mã kích hoạt 4 chữ số được cung cấp',
              scaleFactor: scaleFactor,
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            ),

            SizedBox(height: 48 * scaleFactor),

            // Activation Code Input
            OTPInput(
              onChanged: _onActivationCodeChanged,
              scaleFactor: scaleFactor,
              autoFocus: true,
              length: 4,
            ),

            SizedBox(height: 48 * scaleFactor),

            // Action Buttons
            Column(
              children: [
                // Confirm Button
                CustomButton(
                  text: 'Xác nhận',
                  onPressed: _activationCode.length == 4 && !_isLoading
                      ? _onActivate
                      : null,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  enabled: _activationCode.length == 4 && !_isLoading,
                  customScale: scaleFactor,
                ),

                SizedBox(height: 16 * scaleFactor),

                // Cancel Button
                CustomButton(
                  text: 'Huỷ',
                  onPressed: _isLoading ? null : _onCancel,
                  type: ButtonType.secondary,
                  size: ButtonSize.large,
                  enabled: !_isLoading,
                  customScale: scaleFactor,
                ),
              ],
            ),

            SizedBox(height: 32 * scaleFactor),

            // Help Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
              child: Text(
                'Không có mã kích hoạt? Liên hệ hỗ trợ để được trợ giúp.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14 * scaleFactor,
                  color: const Color(0xFF777777),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
