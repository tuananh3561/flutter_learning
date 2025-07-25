import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/sections/sound_section/sound_effect_dialog.dart';

/// Widget hiển thị cài đặt hiệu ứng âm thanh
class SoundEffectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> soundEffects;
  final List<AssetModel?> soundEffectAssets;
  final Function(Map<String, dynamic>, AssetModel?, int) onEffectUpdated;
  final Function(int) onEffectDeleted;
  final Function(Map<String, dynamic>, AssetModel?) onEffectAdded;

  const SoundEffectsSection({
    Key? key,
    required this.soundEffects,
    required this.soundEffectAssets,
    required this.onEffectUpdated,
    required this.onEffectDeleted,
    required this.onEffectAdded,
  }) : super(key: key);

  void _showSoundEffectDialog(BuildContext context, {int? index}) {
    Map<String, dynamic>? soundEffect;
    AssetModel? selectedAsset;

    if (index != null && index >= 0 && index < soundEffects.length) {
      soundEffect = Map<String, dynamic>.from(soundEffects[index]);
      selectedAsset = soundEffectAssets[index];
    }

    showDialog(
      context: context,
      builder: (context) => SoundEffectDialog(
        soundEffect: soundEffect,
        selectedAsset: selectedAsset,
        onSave: (effect, asset) {
          if (index != null) {
            onEffectUpdated(effect, asset, index);
          } else {
            onEffectAdded(effect, asset);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Hiệu ứng âm thanh',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Asset Manager',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm hiệu ứng'),
                  onPressed: () => _showSoundEffectDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (soundEffects.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'Chưa có hiệu ứng âm thanh nào. Hãy thêm hiệu ứng mới.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: soundEffects.length,
                itemBuilder: (context, index) {
                  final effect = soundEffects[index];
                  final asset = index < soundEffectAssets.length
                      ? soundEffectAssets[index]
                      : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(effect['name'] ?? 'Không có tên'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (asset != null)
                            Text('File: ${asset.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12))
                          else
                            Text('Đường dẫn: ${effect['path']}'),
                          Text(
                              'Âm lượng: ${((effect['volume'] ?? 1.0) * 100).round()}%'),
                          Text(
                              'Lặp: ${(effect['loop'] ?? false) ? 'Có' : 'Không'}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.green),
                            onPressed: () {
                              // Giả lập phát âm thanh
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đang phát: ${effect['name']}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            tooltip: 'Phát thử',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showSoundEffectDialog(context, index: index),
                            tooltip: 'Chỉnh sửa',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onEffectDeleted(index),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
