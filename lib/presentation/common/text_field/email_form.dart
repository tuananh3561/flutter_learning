/// Email form widget có thể tái sử dụng
/// Hỗ trợ validation email theo thiết kế Figma
library;

import 'package:flutter/material.dart';

import '../../../data/models/auth_data.dart';

/// Widget form nhập email với validation
class EmailForm extends StatelessWidget {
  /// Controller cho text input
  final TextEditingController controller;

  /// Callback khi email thay đổi
  final ValueChanged<String> onChanged;

  /// Trạng thái validation hiện tại
  final FormFieldValidation validation;

  /// Scale factor để responsive
  final double scaleFactor;

  /// Placeholder text
  final String hintText;

  /// Background color (optional)
  final Color? backgroundColor;

  /// Text color (optional)
  final Color? textColor;

  const EmailForm({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.validation,
    required this.scaleFactor,
    this.hintText = 'abc@gmail.com',
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email input container
        Container(
          width: 380 * scaleFactor,
          padding: EdgeInsets.symmetric(
            horizontal: 24 * scaleFactor,
            vertical: 16 * scaleFactor,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(12 * scaleFactor),
            border: Border.all(
              color: validation.state == ValidationState.invalid
                  ? const Color(0xFFFF4B4B)
                  : const Color(0xFFAFAFAF),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            onChanged: onChanged,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 20 * scaleFactor,
              color: textColor ?? const Color(0xFF4B4B4B),
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 20 * scaleFactor,
                color: const Color(0xFFAFAFAF),
                height: 1.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),

        // Error message
        if (validation.state == ValidationState.invalid)
          Padding(
            padding: EdgeInsets.only(top: 8 * scaleFactor),
            child: Text(
              validation.errorMessage ?? '',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14 * scaleFactor,
                color: const Color(0xFFFF4B4B),
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}
