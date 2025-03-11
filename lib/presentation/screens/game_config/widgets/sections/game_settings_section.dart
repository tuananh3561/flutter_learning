import 'package:flutter/material.dart';
import '../config_editor_panel.dart';

/// Widget to edit game settings
class GameSettingsSection extends StatelessWidget {
  final Map<String, dynamic> gameSettings;
  final Map<String, dynamic> gameInfo;
  final Function(Map<String, dynamic>) onGameSettingsChanged;
  final Function(Map<String, dynamic>) onGameInfoChanged;

  const GameSettingsSection({
    Key? key,
    required this.gameSettings,
    required this.gameInfo,
    required this.onGameSettingsChanged,
    required this.onGameInfoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Game Info Section
        Text('Game Information', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        ConfigTextField(
          label: 'Game Name',
          value: gameInfo['name'] ?? '',
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameInfo);
            updated['name'] = value;
            onGameInfoChanged(updated);
          },
          helperText: 'The name of the game',
        ),

        ConfigTextField(
          label: 'Description',
          value: gameInfo['description'] ?? '',
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameInfo);
            updated['description'] = value;
            onGameInfoChanged(updated);
          },
          helperText: 'Short description of the game',
        ),

        ConfigTextField(
          label: 'Version',
          value: gameInfo['version'] ?? '1.0.0',
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameInfo);
            updated['version'] = value;
            onGameInfoChanged(updated);
          },
          helperText: 'Version number (e.g. 1.0.0)',
        ),

        const Divider(height: 32),

        // Game Settings Section
        Text('Game Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        ConfigNumberField(
          label: 'Required Rounds',
          value: gameSettings['requiredRounds'] ?? 5,
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['requiredRounds'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Number of rounds required to complete the game',
        ),

        ConfigNumberField(
          label: 'Number of Choices',
          value: gameSettings['numberOfChoices'] ?? 3,
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['numberOfChoices'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Number of choices displayed in each round',
        ),

        ConfigDropdown<String>(
          label: 'Game Type',
          value: gameSettings['typeGame'] ?? 'Drop',
          items: const ['Drop', 'Tap'],
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['typeGame'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Type of gameplay (Drop or Tap)',
        ),

        ConfigTextField(
          label: 'Background Config Path',
          value: gameSettings['backgroundConfigPath'] ?? '',
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['backgroundConfigPath'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Path to the background configuration file',
        ),

        ConfigNumberField(
          label: 'Time Limit',
          value: gameSettings['timeLimit'] ?? 0,
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['timeLimit'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Time limit in seconds (0 for no limit)',
        ),

        ConfigNumberField(
          label: 'Score Per Correct Answer',
          value: gameSettings['scorePerCorrectAnswer'] ?? 10,
          onChanged: (value) {
            final updated = Map<String, dynamic>.from(gameSettings);
            updated['scorePerCorrectAnswer'] = value;
            onGameSettingsChanged(updated);
          },
          helperText: 'Points earned for each correct answer',
        ),
      ],
    );
  }
}
