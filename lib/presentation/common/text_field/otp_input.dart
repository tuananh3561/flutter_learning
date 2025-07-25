/// OTP Input widget có thể tái sử dụng
/// Hỗ trợ nhập mã OTP 4 chữ số theo thiết kế Figma
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget cho việc nhập OTP 4 chữ số
class OTPInput extends StatefulWidget {
  /// Callback khi OTP thay đổi
  final ValueChanged<String> onChanged;

  /// Scale factor để responsive
  final double scaleFactor;

  /// Giá trị OTP ban đầu (optional)
  final String? initialValue;

  /// Số lượng ô input (default: 4)
  final int length;

  /// Auto focus vào ô đầu tiên
  final bool autoFocus;

  const OTPInput({
    super.key,
    required this.onChanged,
    required this.scaleFactor,
    this.initialValue,
    this.length = 4,
    this.autoFocus = false,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    // Set initial value if provided
    if (widget.initialValue != null) {
      _otp = widget.initialValue!;
      _setupInitialValues();
    }

    _setupControllers();

    // Auto focus first field if enabled
    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _setupInitialValues() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].text = i < _otp.length ? _otp[i] : '';
    }
  }

  void _setupControllers() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
    }
  }

  void _onTextChanged(int index) {
    final value = _controllers[index].text;

    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    // Update OTP string
    _otp = _controllers.map((controller) => controller.text).join();
    widget.onChanged(_otp);
  }

  void _onKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Move to previous field when backspace on empty field
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  /// Tính scaled value
  double _scale(double value) {
    return value * widget.scaleFactor;
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: _scale(83),
      height: _scale(86),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(12)),
        border: Border.all(
          color: const Color(0xFFAFAFAF),
          width: 1,
        ),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) => _onKeyEvent(index, event),
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: _scale(36),
            color: const Color(0xFF4B4B4B),
            height: 1.5,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _onTextChanged(index);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.length; i++) ...[
          _buildOTPBox(i),
          if (i < widget.length - 1) SizedBox(width: _scale(16)),
        ],
      ],
    );
  }
}
