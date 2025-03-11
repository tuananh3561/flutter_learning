import 'package:flutter/material.dart';

/// Widget to edit vocabulary configuration
class VocabularySection extends StatelessWidget {
  final Map<String, dynamic> vocabularyConfig;
  final Function(Map<String, dynamic>) onVocabularyConfigChanged;

  const VocabularySection({
    Key? key,
    required this.vocabularyConfig,
    required this.onVocabularyConfigChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vocabulary Configuration',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Placeholder for detailed implementation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vocabulary Source',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('This section would include fields for:'),
                const SizedBox(height: 8),
                const Text('• Source type (internal or external)'),
                const Text('• External API configuration (if applicable)'),
                const SizedBox(height: 16),
                Text('Vocabulary Items',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('This section would include:'),
                const SizedBox(height: 8),
                const Text('• List of vocabulary items'),
                const Text('• Text for each item'),
                const Text('• Audio file path'),
                const Text('• Image file path'),
                const Text('• Add/remove vocabulary items'),
                const Text('• Edit existing vocabulary items'),
                const SizedBox(height: 16),
                Text('Vocabulary Groups',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('This section would include:'),
                const SizedBox(height: 8),
                const Text('• Group management (categories, levels)'),
                const Text('• Difficulty settings'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
