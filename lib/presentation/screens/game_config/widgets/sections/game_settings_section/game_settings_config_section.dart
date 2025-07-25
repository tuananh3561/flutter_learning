import 'package:flutter/material.dart';
import '../../config_editor_panel.dart';

/// Widget hiển thị và chỉnh sửa cài đặt trò chơi
class GameSettingsConfigSection extends StatelessWidget {
  final Map<String, dynamic> gameSettings;
  final Function(Map<String, dynamic>) onGameSettingsChanged;

  const GameSettingsConfigSection({
    Key? key,
    required this.gameSettings,
    required this.onGameSettingsChanged,
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
            Text('Cài đặt trò chơi',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ConfigNumberField(
              label: 'Số vòng chơi',
              value: gameSettings['requiredRounds'] ?? 5,
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['requiredRounds'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Số vòng chơi cần hoàn thành',
            ),
            ConfigNumberField(
              label: 'Số lựa chọn',
              value: gameSettings['numberOfChoices'] ?? 3,
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['numberOfChoices'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Số lựa chọn hiển thị trong mỗi vòng chơi',
            ),
            ConfigDropdown<String>(
              label: 'Loại trò chơi',
              value: gameSettings['typeGame'] ?? 'Drop',
              items: const ['Drop', 'Tap'],
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['typeGame'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Kiểu chơi (Drop hoặc Tap)',
            ),
            ConfigTextField(
              label: 'Đường dẫn cấu hình nền',
              value: gameSettings['backgroundConfigPath'] ?? '',
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['backgroundConfigPath'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Đường dẫn đến file cấu hình nền',
            ),
            ConfigNumberField(
              label: 'Giới hạn thời gian',
              value: gameSettings['timeLimit'] ?? 0,
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['timeLimit'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Thời gian giới hạn (giây) (0 = không giới hạn)',
            ),
            ConfigNumberField(
              label: 'Điểm cho câu trả lời đúng',
              value: gameSettings['scorePerCorrectAnswer'] ?? 10,
              onChanged: (value) {
                final updated = Map<String, dynamic>.from(gameSettings);
                updated['scorePerCorrectAnswer'] = value;
                onGameSettingsChanged(updated);
              },
              helperText: 'Số điểm nhận được cho mỗi câu trả lời đúng',
            ),
          ],
        ),
      ),
    );
  }
}
