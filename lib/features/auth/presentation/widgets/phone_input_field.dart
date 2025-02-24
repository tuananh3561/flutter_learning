import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final String value;
  final String? error;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  const PhoneInputField({
    Key? key,
    required this.value,
    this.error,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Số điện thoại',
        prefixText: '+84 ',
        errorText: error,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmitted(),
    );
  }
}
