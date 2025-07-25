import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/auth_data.dart';

/// Password TextField Widget có thể tái sử dụng
/// Hỗ trợ show/hide password và responsive design theo Figma
class PasswordTextField extends StatefulWidget {
  /// Controller cho text field
  final TextEditingController controller;

  /// Callback khi text thay đổi
  final ValueChanged<String>? onChanged;

  /// Validation state hiện tại (optional)
  final FormFieldValidation? validation;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Custom width (optional, default 380 * scale)
  final double? width;

  /// Hint text (optional)
  final String hintText;

  /// Initial obscure state (default true)
  final bool initialObscureText;

  /// Custom text style (optional)
  final TextStyle? textStyle;

  /// Custom hint style (optional)
  final TextStyle? hintStyle;

  /// Background color (optional)
  final Color? backgroundColor;

  /// Border color (optional)
  final Color? borderColor;

  const PasswordTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.validation,
    this.scaleFactor = 1.0,
    this.width,
    this.hintText = 'Mật khẩu',
    this.initialObscureText = true,
    this.textStyle,
    this.hintStyle,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.initialObscureText;
  }

  /// Tính scaled value
  double _scale(double value) {
    return value * widget.scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width ?? (380 * widget.scaleFactor),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0xFFE5E5E5),
            border: Border.all(
              color: widget.borderColor ?? const Color(0xFFAFAFAF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_scale(12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscurePassword,
                  onChanged: widget.onChanged,
                  style: widget.textStyle ??
                      TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: _scale(20),
                        color: const Color(0xFFAFAFAF),
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle ??
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

              // Eye button
              Padding(
                padding: EdgeInsets.only(right: _scale(24)),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Container(
                    width: _scale(24),
                    height: _scale(24),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFAFAFAF),
                      size: _scale(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message (if validation provided)
        if (widget.validation?.hasError == true &&
            widget.validation?.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: _scale(8)),
            child: Text(
              widget.validation!.errorMessage!,
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
