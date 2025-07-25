import 'package:flutter/material.dart';
import 'game_settings_section/index.dart';

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
        Text('Cấu hình trò chơi',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Game Info Section
        GameInfoSection(
          gameInfo: gameInfo,
          onGameInfoChanged: onGameInfoChanged,
        ),

        // Game Settings Section
        GameSettingsConfigSection(
          gameSettings: gameSettings,
          onGameSettingsChanged: onGameSettingsChanged,
        ),
      ],
    );
  }
}
