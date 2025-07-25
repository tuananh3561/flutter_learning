import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:provider/provider.dart';

/// Widget hiển thị cài đặt âm thanh từ vựng
class WordSoundsSection extends StatefulWidget {
  final bool wordSoundsEnabled;
  final String wordSoundPathTemplate;
  final double wordSoundVolume;
  final Function(bool) onWordSoundsEnabledChanged;
  final Function(String) onWordSoundPathTemplateChanged;
  final Function(double) onWordSoundVolumeChanged;
  final Function() onUpdateSoundConfig;

  const WordSoundsSection({
    Key? key,
    required this.wordSoundsEnabled,
    required this.wordSoundPathTemplate,
    required this.wordSoundVolume,
    required this.onWordSoundsEnabledChanged,
    required this.onWordSoundPathTemplateChanged,
    required this.onWordSoundVolumeChanged,
    required this.onUpdateSoundConfig,
  }) : super(key: key);

  @override
  State<WordSoundsSection> createState() => _WordSoundsSectionState();
}

class _WordSoundsSectionState extends State<WordSoundsSection> {
  final TextEditingController _wordSoundPathTemplateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _wordSoundPathTemplateController.text = widget.wordSoundPathTemplate;
  }

  @override
  void didUpdateWidget(WordSoundsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wordSoundPathTemplate != widget.wordSoundPathTemplate) {
      _wordSoundPathTemplateController.text = widget.wordSoundPathTemplate;
    }
  }

  @override
  void dispose() {
    _wordSoundPathTemplateController.dispose();
    super.dispose();
  }

  /// Hiển thị dialog chọn mẫu âm thanh từ vựng
  Future<void> _showWordSoundAssetDialog() async {
    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final audioAssets =
          await assetRepository.getAssetsByType(AssetType.audio);

      if (audioAssets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Không có file âm thanh nào. Hãy upload trong Asset Manager'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Hiển thị dialog để chọn audio sample
      final selected = await showDialog<AssetModel?>(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn âm thanh mẫu từ Asset Manager',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Từ file được chọn, hệ thống sẽ tự động tạo template cho thư mục chứa các file âm thanh từ vựng',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Search field
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm âm thanh...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Filter functionality would be implemented here
                  },
                ),

                const SizedBox(height: 16),

                // List of audio assets
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                      itemCount: audioAssets.length,
                      itemBuilder: (context, index) {
                        final asset = audioAssets[index];

                        return ListTile(
                          leading:
                              const Icon(Icons.audio_file, color: Colors.blue),
                          title: Text(asset.name),
                          subtitle: Text(asset.path),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.green),
                            onPressed: () {
                              // Play audio preview
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đang phát: ${asset.name}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).pop(asset);
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (selected != null) {
        final path = selected.path;
        final dirPath = path.substring(0, path.lastIndexOf('/') + 1);
        _wordSoundPathTemplateController.text =
            '$dirPath{word}.${path.split('.').last}';
        widget.onWordSoundPathTemplateChanged(
            _wordSoundPathTemplateController.text);
        widget.onUpdateSoundConfig();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tạo template từ file ${selected.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Lỗi hiển thị dialog chọn mẫu âm thanh từ vựng: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi hiển thị dialog chọn mẫu âm thanh từ vựng: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              children: [
                Text('Âm thanh từ vựng',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            const SizedBox(height: 16),

            // Enable/disable Word Sounds
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kích hoạt Âm thanh từ vựng',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Text(
                        'Bật/tắt âm thanh cho từ vựng trong game',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.wordSoundsEnabled,
                  onChanged: widget.onWordSoundsEnabledChanged,
                ),
              ],
            ),

            if (widget.wordSoundsEnabled) ...[
              const SizedBox(height: 16),
              // Word Sound Path Template
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _wordSoundPathTemplateController,
                      decoration: const InputDecoration(
                        labelText: 'Template từ Asset Manager',
                        border: OutlineInputBorder(),
                        helperText:
                            'Sử dụng {word} để thay thế bằng từ cần phát (VD: assets/sounds/words/{word}.mp3)',
                        prefixIcon:
                            Icon(Icons.library_music, color: Colors.blue),
                      ),
                      onChanged: (value) {
                        widget.onWordSoundPathTemplateChanged(value);
                      },
                      onEditingComplete: widget.onUpdateSoundConfig,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open, color: Colors.blue),
                    tooltip: 'Chọn mẫu từ Asset Manager',
                    onPressed: _showWordSoundAssetDialog,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Word Sound Volume
              Text('Âm lượng phát âm từ vựng',
                  style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: [
                  const Icon(Icons.volume_down, size: 20),
                  Expanded(
                    child: Slider(
                      value: widget.wordSoundVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(widget.wordSoundVolume * 100).round()}%',
                      onChanged: (value) {
                        widget.onWordSoundVolumeChanged(value);
                      },
                      onChangeEnd: (value) {
                        widget.onUpdateSoundConfig();
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up, size: 20),
                  SizedBox(
                    width: 50,
                    child: Text('${(widget.wordSoundVolume * 100).round()}%'),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
