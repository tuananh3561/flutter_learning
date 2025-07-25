import 'package:flutter/material.dart';

/// Widget hiển thị các cài đặt chung cho âm thanh
class GlobalSettingsSection extends StatelessWidget {
  final bool soundEnabled;
  final double masterVolume;
  final Function(bool) onSoundEnabledChanged;
  final Function(double) onMasterVolumeChanged;

  const GlobalSettingsSection({
    Key? key,
    required this.soundEnabled,
    required this.masterVolume,
    required this.onSoundEnabledChanged,
    required this.onMasterVolumeChanged,
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
            Text('Cài đặt chung',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // Enable/disable sounds
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kích hoạt Âm thanh',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Text(
                        'Bật/tắt tất cả âm thanh trong game',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: soundEnabled,
                  onChanged: onSoundEnabledChanged,
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Master Volume
            Text('Âm lượng tổng',
                style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: masterVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(masterVolume * 100).round()}%',
                    onChanged: soundEnabled ? onMasterVolumeChanged : null,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text('${(masterVolume * 100).round()}%'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
