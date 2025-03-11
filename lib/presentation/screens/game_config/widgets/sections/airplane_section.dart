import 'package:flutter/material.dart';

/// Widget to edit airplane configuration
class AirplaneSection extends StatelessWidget {
  final Map<String, dynamic> airplaneConfig;
  final Function(Map<String, dynamic>) onAirplaneConfigChanged;

  const AirplaneSection({
    Key? key,
    required this.airplaneConfig,
    required this.onAirplaneConfigChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Airplane Configuration',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Placeholder for detailed implementation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Airplane Component Settings',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('This section would include fields for:'),
                const SizedBox(height: 8),
                const Text('• Skeleton and atlas file paths'),
                const Text('• Default animation'),
                const Text('• Position and scale settings'),
                const Text('• Animation configurations'),
                const Text('• Round animation mappings'),
                const Text('• Ending animation sequence'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
