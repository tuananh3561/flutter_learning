import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final String value;
  final String? error;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  const PasswordInputField({
    Key? key,
    required this.value,
    this.error,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.value,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        errorText: widget.error,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: (_) => widget.onSubmitted(),
    );
  }
}
