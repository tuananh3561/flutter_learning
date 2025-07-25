import 'package:flutter/material.dart';
import '../../config_editor_panel.dart';

/// Widget hiển thị và chỉnh sửa thông tin trò chơi
class GameInfoSection extends StatelessWidget {
  final Map<String, dynamic> gameInfo;
  final Function(Map<String, dynamic>) onGameInfoChanged;

  const GameInfoSection({
    Key? key,
    required this.gameInfo,
    required this.onGameInfoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin trò chơi',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ConfigTextField(
              label: 'Tên trò chơi',
              value: gameInfo['name'] ?? '',
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameInfo);
                updated['name'] = value;
                onGameInfoChanged(updated);
              },
              helperText: 'Tên hiển thị của trò chơi',
            ),
            ConfigTextField(
              label: 'Mô tả',
              value: gameInfo['description'] ?? '',
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameInfo);
                updated['description'] = value;
                onGameInfoChanged(updated);
              },
              helperText: 'Mô tả ngắn về trò chơi',
            ),
            ConfigTextField(
              label: 'Phiên bản',
              value: gameInfo['version'] ?? '1.0.0',
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameInfo);
                updated['version'] = value;
                onGameInfoChanged(updated);
              },
              helperText: 'Số phiên bản (VD: 1.0.0)',
            ),
          ],
        ),
      ),
    );
  }
}
