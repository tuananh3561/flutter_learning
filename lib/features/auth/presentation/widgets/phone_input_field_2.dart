// lib/features/auth/presentation/widgets/phone_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text_field.dart';

class PhoneInputField2 extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;

  const PhoneInputField2({
    Key? key,
    required this.controller,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'Phone Number',
      hint: 'Enter your phone number',
      errorText: errorText,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      suffixIcon: const Icon(Icons.phone),
      maxLength: 15,
    );
  }
}

/// Format phone number input
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow digits and '+'
    final newText = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure '+' is only at the beginning
    if (newText.contains('+') && !newText.startsWith('+')) {
      final cleaned = newText.replaceAll('+', '');
      return TextEditingValue(
        text: '+$cleaned',
        selection: TextSelection.collapsed(offset: '+$cleaned'.length),
      );
    }

    // Remove duplicate '+'
    if (newText.startsWith('+') && newText.substring(1).contains('+')) {
      final parts = newText.split('+');
      final cleaned = '+' + parts.skip(1).join('');
      return TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
