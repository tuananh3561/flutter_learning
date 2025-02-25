// lib/features/auth/presentation/widgets/password_input_field.dart
import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class PasswordInputField2 extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String label;
  final String hint;

  const PasswordInputField2({
    Key? key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.label = 'Password',
    this.hint = 'Enter your password',
  }) : super(key: key);

  @override
  State<PasswordInputField2> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField2> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: widget.controller,
          label: widget.label,
          hint: widget.hint,
          errorText: widget.errorText,
          obscureText: _obscureText,
          onChanged: widget.onChanged,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildPasswordStrengthIndicator(widget.controller.text),
          ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    // Calculate password strength
    final hasMinLength = password.length >= 8;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    // Score based on criteria met
    int strength = 0;
    if (hasMinLength) strength++;
    if (hasLetter) strength++;
    if (hasNumber) strength++;
    if (hasSpecialChar) strength++;

    // Determine color and label based on strength
    Color color;
    String label;

    switch (strength) {
      case 1:
        color = Colors.red;
        label = 'Weak';
        break;
      case 2:
        color = Colors.orange;
        label = 'Fair';
        break;
      case 3:
        color = Colors.yellow[700]!;
        label = 'Good';
        break;
      case 4:
        color = Colors.green;
        label = 'Strong';
        break;
      default:
        color = Colors.grey;
        label = 'Too Short';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 4,
                backgroundColor: Colors.grey[300],
                color: color,
                minHeight: 5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCriteriaIndicator('8+ chars', hasMinLength),
            const SizedBox(width: 16),
            _buildCriteriaIndicator('Letter', hasLetter),
            const SizedBox(width: 16),
            _buildCriteriaIndicator('Number', hasNumber),
            const SizedBox(width: 16),
            _buildCriteriaIndicator('Symbol', hasSpecialChar),
          ],
        ),
      ],
    );
  }

  Widget _buildCriteriaIndicator(String title, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.cancel,
          color: isMet ? Colors.green : Colors.grey,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
