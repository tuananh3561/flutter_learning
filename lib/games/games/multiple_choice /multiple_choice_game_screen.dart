import 'package:flutter/material.dart';

import 'multiple_choice_wrapper.dart';

/// Màn hình game Multiple Choice
class MultipleChoiceGameScreen extends StatelessWidget {
  /// Constructor
  const MultipleChoiceGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MultipleChoiceWrapper(),
    );
  }
}
