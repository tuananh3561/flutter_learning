import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:provider/provider.dart';

/// Dialog để thêm mới hoặc chỉnh sửa hiệu ứng âm thanh
class SoundEffectDialog extends StatefulWidget {
  final Map<String, dynamic>? soundEffect;
  final AssetModel? selectedAsset;
  final Function(Map<String, dynamic>, AssetModel?) onSave;

  const SoundEffectDialog({
    Key? key,
    this.soundEffect,
    this.selectedAsset,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SoundEffectDialog> createState() => _SoundEffectDialogState();
}

class _SoundEffectDialogState extends State<SoundEffectDialog> {
  final TextEditingController _effectNameController = TextEditingController();
  final TextEditingController _effectPathController = TextEditingController();
  double _effectVolume = 1.0;
  bool _effectLoop = false;
  AssetModel? _selectedAsset;

  @override
  void initState() {
    super.initState();
    // Nếu là chỉnh sửa, load dữ liệu cũ
    if (widget.soundEffect != null) {
      _effectNameController.text = widget.soundEffect!['name'] ?? '';
      _effectPathController.text = widget.soundEffect!['path'] ?? '';
      _effectVolume = widget.soundEffect!['volume']?.toDouble() ?? 1.0;
      _effectLoop = widget.soundEffect!['loop'] ?? false;
    }

    _selectedAsset = widget.selectedAsset;
  }

  @override
  void dispose() {
    _effectNameController.dispose();
    _effectPathController.dispose();
    super.dispose();
  }

  /// Hiển thị dialog chọn audio asset
  Future<void> _showAudioAssetSelector() async {
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

      // Hiển thị dialog để chọn audio
      final result = await showDialog<AssetModel?>(
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
                  'Chọn Hiệu Ứng Âm Thanh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                  child: ListView.builder(
                    itemCount: audioAssets.length,
                    itemBuilder: (context, index) {
                      final asset = audioAssets[index];
                      final isSelected = _selectedAsset?.id == asset.id;

                      return ListTile(
                        title: Text(asset.name),
                        subtitle: Text(asset.path),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                // Play audio preview (can be implemented later)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đang phát: ${asset.name}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            if (isSelected)
                              const Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                        selected: isSelected,
                        selectedTileColor: Colors.blue.withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            _selectedAsset = asset;
                            _effectPathController.text = asset.url ?? '';
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách âm thanh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveEffect() {
    if (_effectNameController.text.isEmpty ||
        _effectPathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên và đường dẫn không được để trống'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final effect = {
      'name': _effectNameController.text,
      'path': _effectPathController.text,
      'volume': _effectVolume,
      'loop': _effectLoop,
    };

    widget.onSave(effect, _selectedAsset);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.soundEffect != null;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing
                  ? 'Chỉnh sửa hiệu ứng âm thanh'
                  : 'Thêm hiệu ứng âm thanh mới',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Effect Name
            TextField(
              controller: _effectNameController,
              decoration: const InputDecoration(
                labelText: 'Tên hiệu ứng',
                border: OutlineInputBorder(),
                helperText: 'Ví dụ: click, correct, wrong, match, plane, ...',
              ),
            ),

            const SizedBox(height: 16),
            // Effect File Path
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _effectPathController,
                    decoration: const InputDecoration(
                      labelText: 'Chọn từ Asset Manager',
                      border: OutlineInputBorder(),
                      helperText: 'Đường dẫn tới tệp âm thanh (MP3, WAV)',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open, color: Colors.blue),
                  tooltip: 'Chọn từ Asset Manager',
                  onPressed: _showAudioAssetSelector,
                ),
              ],
            ),

            // Hiển thị thông tin asset đã chọn
            if (_selectedAsset != null && _effectPathController.text.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.audio_file, size: 24, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asset Manager: ${_selectedAsset!.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'URL: ${_selectedAsset!.url ?? "N/A"}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đang phát: ${_selectedAsset!.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      tooltip: 'Phát thử',
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            // Effect Volume
            Text('Âm lượng', style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                const Icon(Icons.volume_down, size: 20),
                Expanded(
                  child: Slider(
                    value: _effectVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(_effectVolume * 100).round()}%',
                    onChanged: (value) {
                      setState(() {
                        _effectVolume = value;
                      });
                    },
                  ),
                ),
                const Icon(Icons.volume_up, size: 20),
                SizedBox(
                  width: 50,
                  child: Text('${(_effectVolume * 100).round()}%'),
                )
              ],
            ),

            const SizedBox(height: 16),
            // Effect Loop
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lặp hiệu ứng',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Text(
                        'Tự động phát lại khi hiệu ứng kết thúc',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _effectLoop,
                  onChanged: (value) {
                    setState(() {
                      _effectLoop = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveEffect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.orange : Colors.blue,
                  ),
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
