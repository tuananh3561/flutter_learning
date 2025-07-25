import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_learning/presentation/common/text_field/password_text_field.dart';
import 'package:flutter_learning/data/models/auth_data.dart';

/// Password field component với show/hide functionality
class PasswordFieldComponent extends StatefulWidget {
  final String label;
  final String placeholder;
  final String value;
  final String? errorText;
  final Function(String) onChanged;
  final double scale;

  const PasswordFieldComponent({
    super.key,
    required this.label,
    required this.placeholder,
    required this.value,
    this.errorText,
    required this.onChanged,
    this.scale = 1.0,
  });

  @override
  State<PasswordFieldComponent> createState() => _PasswordFieldComponentState();
}

class _PasswordFieldComponentState extends State<PasswordFieldComponent> {
  late TextEditingController _controller;
  FormFieldValidation? _validation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _updateValidation();
  }

  @override
  void didUpdateWidget(PasswordFieldComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
    if (oldWidget.errorText != widget.errorText) {
      _updateValidation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Update validation từ errorText
  void _updateValidation() {
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      _validation = FormFieldValidation(
        state: ValidationState.invalid,
        errorMessage: widget.errorText,
      );
    } else {
      _validation = FormFieldValidation(
        state: ValidationState.valid,
        errorMessage: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            // Password icon
            Container(
              width: 24 * widget.scale,
              height: 24 * widget.scale,
              child: _buildPasswordIcon(),
            ),

            SizedBox(width: 8 * widget.scale),

            // Label text
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 16 * widget.scale,
                height: 1.5,
                color: Color(0xFF6F6F6F),
              ),
            ),
          ],
        ),

        SizedBox(height: 8 * widget.scale),

        // Password input field using PasswordTextField
        PasswordTextField(
          controller: _controller,
          onChanged: widget.onChanged,
          validation: _validation,
          scaleFactor: widget.scale,
          hintText: widget.placeholder,
          backgroundColor: Colors.white,
          borderColor:
              widget.errorText != null ? Colors.red : Color(0xFFAFAFAF),
          textStyle: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16 * widget.scale,
            height: 1.5,
            color: Color(0xFF4B4B4B),
          ),
          hintStyle: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16 * widget.scale,
            height: 1.5,
            color: Color(0xFFAFAFAF),
          ),
        ),
      ],
    );
  }

  /// Build password icon
  Widget _buildPasswordIcon() {
    return SvgPicture.asset(
      'assets/images/parent/password_icon.svg',
      width: 24 * widget.scale,
      height: 24 * widget.scale,
      colorFilter: ColorFilter.mode(
        Color(0xFF130F26),
        BlendMode.srcIn,
      ),
    );
  }
}
