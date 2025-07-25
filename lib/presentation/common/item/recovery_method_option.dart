/// Recovery Method Option widget có thể tái sử dụng
/// Hỗ trợ SMS và Email recovery options theo thiết kế Figma
library;

import 'package:flutter/material.dart';
import '../../../data/models/forgot_password_data.dart';

/// Widget cho từng option khôi phục mật khẩu
class RecoveryMethodOption extends StatelessWidget {
  /// Phương thức khôi phục (SMS hoặc Email)
  final RecoveryMethod method;

  /// Text hiển thị cho option
  final String title;

  /// Icon cho option
  final IconData icon;

  /// Callback khi option được chọn
  final VoidCallback onTap;

  /// Scale factor để responsive
  final double scaleFactor;

  /// Có phải là option được recommend không (màu xanh lá)
  final bool isPrimary;

  const RecoveryMethodOption({
    super.key,
    required this.method,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.scaleFactor,
    this.isPrimary = false,
  });

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _scale(380),
        height: _scale(60),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF92C73D) : Colors.white,
          borderRadius: BorderRadius.circular(_scale(12)),
          border: !isPrimary
              ? Border.all(
                  color: const Color(0xFFE5E5E5),
                  width: 2,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Content
            Positioned(
              left: _scale(16),
              top: _scale(16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: _scale(24),
                    color: isPrimary ? Colors.white : const Color(0xFFAFAFAF),
                  ),
                  SizedBox(width: _scale(8)),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: _scale(20),
                      color: isPrimary ? Colors.white : const Color(0xFFAFAFAF),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Positioned(
              right: _scale(16),
              top: _scale(18),
              child: Icon(
                Icons.arrow_forward_ios,
                size: _scale(20),
                color: isPrimary ? Colors.white : const Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
