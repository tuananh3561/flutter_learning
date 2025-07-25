import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';

/// Widget hiển thị cài đặt nhạc nền cho game
class BackgroundMusicSection extends StatefulWidget {
  final bool bgmEnabled;
  final String bgmPath;
  final double bgmVolume;
  final bool bgmLoop;
  final double bgmFadeInDuration;
  final double bgmFadeOutDuration;
  final bool randomizePlaylist;
  final int selectedBgmPreset;
  final List<Map<String, dynamic>> bgmPresets;
  final AssetModel? selectedBgmAsset;
  final Function(bool) onBgmEnabledChanged;
  final Function(String) onBgmPathChanged;
  final Function(double) onBgmVolumeChanged;
  final Function(bool) onBgmLoopChanged;
  final Function(double) onBgmFadeInDurationChanged;
  final Function(double) onBgmFadeOutDurationChanged;
  final Function(bool) onRandomizePlaylistChanged;
  final Function(int) onSelectedBgmPresetChanged;
  final Function(AssetModel) onSelectedBgmAssetChanged;
  final Function() onUpdateSoundConfig;

  const BackgroundMusicSection({
    Key? key,
    required this.bgmEnabled,
    required this.bgmPath,
    required this.bgmVolume,
    required this.bgmLoop,
    required this.bgmFadeInDuration,
    required this.bgmFadeOutDuration,
    required this.randomizePlaylist,
    required this.selectedBgmPreset,
    required this.bgmPresets,
    this.selectedBgmAsset,
    required this.onBgmEnabledChanged,
    required this.onBgmPathChanged,
    required this.onBgmVolumeChanged,
    required this.onBgmLoopChanged,
    required this.onBgmFadeInDurationChanged,
    required this.onBgmFadeOutDurationChanged,
    required this.onRandomizePlaylistChanged,
    required this.onSelectedBgmPresetChanged,
    required this.onSelectedBgmAssetChanged,
    required this.onUpdateSoundConfig,
  }) : super(key: key);

  @override
  State<BackgroundMusicSection> createState() => _BackgroundMusicSectionState();
}

class _BackgroundMusicSectionState extends State<BackgroundMusicSection> {
  final TextEditingController _bgmPathController = TextEditingController();
  bool _showBgmInfo = false;

  @override
  void initState() {
    super.initState();
    _bgmPathController.text = widget.bgmPath;
  }

  @override
  void didUpdateWidget(BackgroundMusicSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bgmPath != widget.bgmPath) {
      _bgmPathController.text = widget.bgmPath;
    }
  }

  @override
  void dispose() {
    _bgmPathController.dispose();
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
                  'Chọn Nhạc Nền',
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
                      final isSelected =
                          widget.selectedBgmAsset?.id == asset.id;

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
                          Navigator.of(context).pop(asset);
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

      if (result != null) {
        _bgmPathController.text = result.url ?? '';
        widget.onBgmPathChanged(_bgmPathController.text);
        widget.onSelectedBgmAssetChanged(result);
        widget.onUpdateSoundConfig();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách âm thanh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Trích xuất thông tin file nhạc (giả lập)
  Map<String, String> _extractBgmFileInfo() {
    final path = _bgmPathController.text;
    if (path.isEmpty) {
      return {
        'fileName': 'Chưa chọn tệp',
        'fileSize': 'N/A',
        'duration': 'N/A',
        'format': 'N/A',
      };
    }

    // Giả lập thông tin file
    final fileName = path.split('/').last;
    final fileExt = fileName.split('.').last.toLowerCase();
    String format;
    switch (fileExt) {
      case 'mp3':
        format = 'MPEG Audio Layer III';
        break;
      case 'wav':
        format = 'Waveform Audio';
        break;
      case 'ogg':
        format = 'Ogg Vorbis';
        break;
      default:
        format = fileExt.toUpperCase();
    }

    return {
      'fileName': fileName,
      'fileSize': '${(2 + fileName.length * 0.3).toStringAsFixed(2)}MB',
      'duration': '${(30 + fileName.length * 2).toStringAsFixed(0)}s',
      'format': format,
    };
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
                Text('Nhạc nền',
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

            // Enable/disable BGM
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kích hoạt Nhạc nền',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Text(
                        'Bật/tắt nhạc nền trong game',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.bgmEnabled,
                  onChanged: widget.onBgmEnabledChanged,
                ),
              ],
            ),

            if (widget.bgmEnabled) ...[
              const SizedBox(height: 16),

              // BGM Preset selection
              Text('Chọn nhạc có sẵn',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: widget.selectedBgmPreset,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: List.generate(widget.bgmPresets.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(widget.bgmPresets[index]['name']),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    widget.onSelectedBgmPresetChanged(value);
                    if (value > 0) {
                      _bgmPathController.text =
                          widget.bgmPresets[value]['path'];
                      widget.onBgmPathChanged(_bgmPathController.text);
                      widget.onUpdateSoundConfig();
                    }
                  }
                },
              ),

              const SizedBox(height: 16),
              // BGM File Path
              Text('Đường dẫn tệp nhạc nền',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bgmPathController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'assets/sounds/background.mp3',
                        helperText:
                            'Đường dẫn tới tệp âm thanh (MP3, WAV, OGG)',
                        labelText: 'Chọn từ Asset Manager',
                      ),
                      onChanged: (value) {
                        int presetIndex = widget.bgmPresets
                            .indexWhere((preset) => preset['path'] == value);
                        if (presetIndex > 0) {
                          widget.onSelectedBgmPresetChanged(presetIndex);
                        } else {
                          widget.onSelectedBgmPresetChanged(0); // Tùy chỉnh
                        }
                        widget.onBgmPathChanged(value);
                      },
                      onEditingComplete: widget.onUpdateSoundConfig,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open, color: Colors.blue),
                    tooltip: 'Chọn từ Asset Manager',
                    onPressed: _showAudioAssetSelector,
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      setState(() {
                        _showBgmInfo = !_showBgmInfo;
                      });
                    },
                    tooltip: 'Hiện thông tin tệp',
                  ),
                ],
              ),

              // Hiển thị thông tin asset đã chọn
              if (widget.selectedBgmAsset != null &&
                  _bgmPathController.text.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.audio_file,
                          size: 24, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Asset Manager: ${widget.selectedBgmAsset!.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'URL: ${widget.selectedBgmAsset!.url ?? "N/A"}',
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
                              content: Text(
                                  'Đang phát: ${widget.selectedBgmAsset!.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        tooltip: 'Phát thử',
                      ),
                    ],
                  ),
                ),

              // BGM File Info
              if (_showBgmInfo) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thông tin tệp nhạc:',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _bgmPathController.text.isEmpty
                          ? const Text('Chưa chọn tệp nhạc nền')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._extractBgmFileInfo().entries.map(
                                      (entry) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              TextSpan(
                                                text: '${entry.key}: ',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: entry.value),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.play_arrow,
                                          size: 18),
                                      label: const Text('Phát thử'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Đang phát: ${_bgmPathController.text}'),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              // BGM Volume
              Text('Âm lượng nhạc nền',
                  style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: [
                  const Icon(Icons.volume_down, size: 20),
                  Expanded(
                    child: Slider(
                      value: widget.bgmVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      label: '${(widget.bgmVolume * 100).round()}%',
                      onChanged: (value) {
                        widget.onBgmVolumeChanged(value);
                      },
                      onChangeEnd: (value) {
                        widget.onUpdateSoundConfig();
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up, size: 20),
                  SizedBox(
                    width: 50,
                    child: Text('${(widget.bgmVolume * 100).round()}%'),
                  )
                ],
              ),

              const SizedBox(height: 16),
              // Fade In/Out Duration
              Text('Hiệu ứng mờ dần',
                  style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Thời gian mờ vào (giây):'),
                        const SizedBox(height: 4),
                        Slider(
                          value: widget.bgmFadeInDuration,
                          min: 0.0,
                          max: 5.0,
                          divisions: 10,
                          label: widget.bgmFadeInDuration.toStringAsFixed(1),
                          onChanged: (value) {
                            widget.onBgmFadeInDurationChanged(value);
                          },
                          onChangeEnd: (value) {
                            widget.onUpdateSoundConfig();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child:
                        Text('${widget.bgmFadeInDuration.toStringAsFixed(1)}s'),
                  )
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Thời gian mờ ra (giây):'),
                        const SizedBox(height: 4),
                        Slider(
                          value: widget.bgmFadeOutDuration,
                          min: 0.0,
                          max: 5.0,
                          divisions: 10,
                          label: widget.bgmFadeOutDuration.toStringAsFixed(1),
                          onChanged: (value) {
                            widget.onBgmFadeOutDurationChanged(value);
                          },
                          onChangeEnd: (value) {
                            widget.onUpdateSoundConfig();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                        '${widget.bgmFadeOutDuration.toStringAsFixed(1)}s'),
                  )
                ],
              ),

              const SizedBox(height: 16),
              // BGM Loop & Randomize
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: widget.bgmLoop,
                          onChanged: (value) {
                            widget.onBgmLoopChanged(value ?? true);
                            widget.onUpdateSoundConfig();
                          },
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lặp nhạc nền',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Text(
                                'Tự động phát lại khi kết thúc',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: widget.randomizePlaylist,
                          onChanged: (value) {
                            widget.onRandomizePlaylistChanged(value ?? false);
                            widget.onUpdateSoundConfig();
                          },
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phát ngẫu nhiên',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Text(
                                'Với nhiều tệp nhạc',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
