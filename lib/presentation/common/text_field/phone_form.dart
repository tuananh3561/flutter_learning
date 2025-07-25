/// Phone form widget with country flag selector and validation
/// Thiết kế responsive theo Figma base size 428x926
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/auth_data.dart';

/// Widget form nhập số điện thoại với flag và validation
class PhoneForm extends StatelessWidget {
  /// Controller cho text input
  final TextEditingController controller;

  /// Callback khi số điện thoại thay đổi
  final ValueChanged<String> onChanged;

  /// Trạng thái validation hiện tại
  final FormFieldValidation validation;

  /// Scale factor để responsive
  final double scaleFactor;

  /// Placeholder text
  final String hintText;

  const PhoneForm({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.validation,
    required this.scaleFactor,
    this.hintText = 'Số điện thoại',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone input container
        Container(
          width: 380 * scaleFactor,
          padding: EdgeInsets.symmetric(
            horizontal: 24 * scaleFactor,
            vertical: 16 * scaleFactor,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(12 * scaleFactor),
            border: Border.all(
              color: validation.state == ValidationState.invalid
                  ? const Color(0xFFFF4B4B)
                  : const Color(0xFFAFAFAF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // VN flag and dropdown
              Row(
                children: [
                  Image.asset(
                    'assets/images/auth/vn_flag.png',
                    width: 28 * scaleFactor,
                    height: 20 * scaleFactor,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 4 * scaleFactor),
                  Image.asset(
                    'assets/images/auth/arrow_down.png',
                    width: 24 * scaleFactor,
                    height: 24 * scaleFactor,
                    fit: BoxFit.cover,
                  ),
                ],
              ),

              SizedBox(width: 4 * scaleFactor),

              // Divider
              Container(
                width: 1 * scaleFactor,
                height: 30 * scaleFactor,
                color: const Color(0xFFAFAFAF),
              ),

              SizedBox(width: 16 * scaleFactor),

              // Phone input
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  onChanged: onChanged,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 20 * scaleFactor,
                    color: const Color(0xFF4B4B4B),
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
            ],
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
