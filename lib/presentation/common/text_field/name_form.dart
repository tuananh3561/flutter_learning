/// Name form widget có thể tái sử dụng
/// Hỗ trợ validation tên theo thiết kế Figma
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/auth_data.dart';

/// Widget form nhập tên với validation
class NameForm extends StatelessWidget {
  /// Controller cho text input
  final TextEditingController controller;

  /// Callback khi tên thay đổi
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

  /// Icon color (optional)
  final Color? iconColor;

  /// Hiển thị edit icon (default: true)
  final bool showEditIcon;

  const NameForm({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.validation,
    required this.scaleFactor,
    this.hintText = 'Họ và tên',
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.showEditIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name input container
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8 * scaleFactor),
            border: Border.all(
              color: validation.state == ValidationState.invalid
                  ? const Color(0xFFFF4B4B)
                  : const Color(0xFFAFAFAF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * scaleFactor,
                    vertical: 16 * scaleFactor,
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    onChanged: onChanged,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 16 * scaleFactor,
                      color: textColor ?? const Color(0xFF4B4B4B),
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 16 * scaleFactor,
                        color: const Color(0xFFAFAFAF),
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

              // Edit icon
              if (showEditIcon)
                Container(
                  padding: EdgeInsets.all(8 * scaleFactor),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18 * scaleFactor,
                    color: iconColor ?? const Color(0xFF777777),
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
