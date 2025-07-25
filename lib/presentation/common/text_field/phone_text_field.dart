import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/auth_data.dart';

/// Phone/Username TextField Widget có thể tái sử dụng
/// Hỗ trợ validation và responsive design theo Figma
class PhoneTextField extends StatelessWidget {
  /// Controller cho text field
  final TextEditingController controller;

  /// Callback khi text thay đổi
  final ValueChanged<String>? onChanged;

  /// Validation state hiện tại
  final FormFieldValidation validation;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Custom width (optional, default 380 * scale)
  final double? width;

  /// Hint text (optional)
  final String hintText;

  /// Callback khi nhấn clear button
  final VoidCallback? onClear;

  /// Custom text style (optional)
  final TextStyle? textStyle;

  /// Custom hint style (optional)
  final TextStyle? hintStyle;

  const PhoneTextField({
    Key? key,
    required this.controller,
    required this.validation,
    this.onChanged,
    this.scaleFactor = 1.0,
    this.width,
    this.hintText = 'Số điện thoại/Tên đăng nhập',
    this.onClear,
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width ?? (380 * scaleFactor),
          decoration: BoxDecoration(
            color: validation.hasError ? Colors.white : const Color(0xFFE5E5E5),
            border: Border.all(
              color: validation.hasError
                  ? const Color(0xFFFF4B4B)
                  : const Color(0xFFAFAFAF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_scale(12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: textStyle ??
                      TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: _scale(20),
                        color: const Color(0xFFAFAFAF),
                      ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: hintStyle ??
                        TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: _scale(20),
                          color: const Color(0xFFAFAFAF),
                        ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: _scale(24),
                      vertical: _scale(16),
                    ),
                  ),
                ),
              ),

              // Clear button (when error)
              if (validation.hasError)
                Padding(
                  padding: EdgeInsets.only(right: _scale(24)),
                  child: GestureDetector(
                    onTap: () {
                      controller.clear();
                      if (onClear != null) {
                        onClear!();
                      } else if (onChanged != null) {
                        onChanged!('');
                      }
                    },
                    child: Container(
                      width: _scale(24),
                      height: _scale(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFAFAFAF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: _scale(16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Error message
        if (validation.hasError && validation.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: _scale(8)),
            child: Text(
              validation.errorMessage!,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: _scale(14),
                color: const Color(0xFFFF4B4B),
              ),
            ),
          ),
      ],
    );
  }
}
