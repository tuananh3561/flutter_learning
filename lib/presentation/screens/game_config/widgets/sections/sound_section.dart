import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/sections/sound_section/index.dart';
import 'package:provider/provider.dart';

/// Widget để cấu hình âm thanh trong game
class SoundSection extends StatefulWidget {
  final Map<String, dynamic> soundConfig;
  final Function(Map<String, dynamic>) onSoundConfigChanged;

  const SoundSection({
    Key? key,
    required this.soundConfig,
    required this.onSoundConfigChanged,
  }) : super(key: key);

  @override
  State<SoundSection> createState() => _SoundSectionState();
}

class _SoundSectionState extends State<SoundSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _currentSoundConfig = {};

  // Global settings
  bool _soundEnabled = true;
  double _masterVolume = 1.0;

  // Background music settings
  bool _bgmEnabled = true;
  String _bgmPath = '';
  double _bgmVolume = 1.0;
  bool _bgmLoop = true;
  double _bgmFadeInDuration = 2.0;
  double _bgmFadeOutDuration = 2.0;
  int _selectedBgmPreset = 0;
  bool _randomizePlaylist = false;

  // Danh sách preset nhạc nền
  final List<Map<String, dynamic>> _bgmPresets = [
    {'name': 'Tùy chỉnh', 'path': ''},
    {'name': 'Nhạc vui nhộn', 'path': '../../assets/sounds/bgm/happy.mp3'},
    {'name': 'Nhạc thư giãn', 'path': '../../assets/sounds/bgm/relax.mp3'},
    {'name': 'Nhạc hồi hộp', 'path': '../../assets/sounds/bgm/suspense.mp3'},
    {'name': 'Nhạc phiêu lưu', 'path': '../../assets/sounds/bgm/adventure.mp3'},
  ];

  // Sound effects list
  List<Map<String, dynamic>> _soundEffects = [];

  // Word sounds settings
  bool _wordSoundsEnabled = true;
  String _wordSoundPathTemplate = '';
  double _wordSoundVolume = 1.0;

  // Asset Manager
  AssetModel? _selectedBgmAsset;
  List<AssetModel?> _soundEffectAssets = [];

  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build xong
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadSoundConfig();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Tải cấu hình âm thanh từ props
  Future<void> _loadSoundConfig() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.soundConfig.isEmpty) {
        _isLoading = false;
        return;
      }

      // Tải cài đặt chung
      _soundEnabled = widget.soundConfig['enabled'] ?? true;
      _masterVolume = widget.soundConfig['masterVolume']?.toDouble() ?? 1.0;

      // Tải cài đặt nhạc nền
      final bgmData = widget.soundConfig['backgroundMusic'];
      if (bgmData is String) {
        // Nếu backgroundMusic là string (định dạng cũ), coi như đó là đường dẫn
        _bgmPath = bgmData;
      } else {
        // Nếu là Map hoặc null
        final bgm = bgmData as Map<String, dynamic>? ?? {};
        _bgmEnabled = bgm['enabled'] ?? true;
        _bgmPath = bgm['path'] ?? '';
        _bgmVolume = bgm['volume']?.toDouble() ?? 1.0;
        _bgmLoop = bgm['loop'] ?? true;
        _bgmFadeInDuration = bgm['fadeInDuration']?.toDouble() ?? 2.0;
        _bgmFadeOutDuration = bgm['fadeOutDuration']?.toDouble() ?? 2.0;
        _randomizePlaylist = bgm['randomizePlaylist'] ?? false;
      }

      // Kiểm tra và thiết lập preset dựa trên đường dẫn
      int presetIndex =
          _bgmPresets.indexWhere((preset) => preset['path'] == _bgmPath);
      if (presetIndex > 0) {
        _selectedBgmPreset = presetIndex;
      } else {
        _selectedBgmPreset = 0; // Tùy chỉnh
      }

      // Tải hiệu ứng âm thanh
      final effectsData = widget.soundConfig['soundEffects'];
      if (effectsData is List) {
        _soundEffects = effectsData
            .where((e) => e is Map)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } else {
        _soundEffects = [];
      }

      // Tải cài đặt âm thanh từ vựng
      final wordSoundsData = widget.soundConfig['wordSounds'];
      if (wordSoundsData is String) {
        // Nếu wordSounds là chuỗi, giả sử đó là template path
        _wordSoundPathTemplate = wordSoundsData;
        _wordSoundsEnabled = true;
        _wordSoundVolume = 1.0;
      } else if (wordSoundsData is Map) {
        // Nếu wordSounds là Map
        final wordSounds = wordSoundsData as Map<String, dynamic>;
        _wordSoundsEnabled = wordSounds['enabled'] ?? true;
        _wordSoundPathTemplate = wordSounds['pathTemplate'] ?? '';
        _wordSoundVolume = wordSounds['volume']?.toDouble() ?? 1.0;
      } else {
        // Mặc định nếu không có dữ liệu
        _wordSoundsEnabled = true;
        _wordSoundPathTemplate = '';
        _wordSoundVolume = 1.0;
      }

      // Update UI
      setState(() {
        _isLoading = false;
      });

      // Tải các asset từ đường dẫn
      _loadAssetsFromPaths();

      // Cập nhật cấu hình sau khi frame hiện tại được render xong
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _updateSoundConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải cấu hình âm thanh: $e';
        _isLoading = false;
      });
      print('Error loading sound config: $e');
    }
  }

  void _updateSoundConfig() {
    try {
      // Tạo cấu hình mới
      _currentSoundConfig = {
        'enabled': _soundEnabled,
        'masterVolume': _masterVolume,
        'backgroundMusic': {
          'enabled': _bgmEnabled,
          'path': _bgmPath,
          'volume': _bgmVolume,
          'loop': _bgmLoop,
          'fadeInDuration': _bgmFadeInDuration,
          'fadeOutDuration': _bgmFadeOutDuration,
          'randomizePlaylist': _randomizePlaylist,
        },
        'soundEffects': _soundEffects,
        'wordSounds': {
          'enabled': _wordSoundsEnabled,
          'pathTemplate': _wordSoundPathTemplate,
          'volume': _wordSoundVolume,
        },
      };

      // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
      widget.onSoundConfigChanged(_currentSoundConfig);

      // In ra log để debug
      print('Sound config updated: ${json.encode(_currentSoundConfig)}');
    } catch (e) {
      print('Error updating sound config: $e');
    }
  }

  /// Tải các asset đã lưu từ đường dẫn
  Future<void> _loadAssetsFromPaths() async {
    try {
      if (_currentSoundConfig.isEmpty) return;

      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final audioAssets =
          await assetRepository.getAssetsByType(AssetType.audio);

      // Tải nhạc nền
      if (_bgmPath.isNotEmpty) {
        for (var asset in audioAssets) {
          if ((asset.url ?? '') == _bgmPath || asset.path == _bgmPath) {
            _selectedBgmAsset = asset;
            break;
          }
        }
      }

      // Tải sound effects
      _soundEffectAssets = List.filled(_soundEffects.length, null);
      for (int i = 0; i < _soundEffects.length; i++) {
        final effectPath = _soundEffects[i]['path'] as String? ?? '';
        if (effectPath.isNotEmpty) {
          for (var asset in audioAssets) {
            if ((asset.url ?? '') == effectPath || asset.path == effectPath) {
              _soundEffectAssets[i] = asset;
              break;
            }
          }
        }
      }

      if (mounted) {
        setState(() {}); // Cập nhật UI với các asset đã tìm thấy
      }
    } catch (e) {
      print('Không thể tải assets từ đường dẫn: $e');
    }
  }

  // Handlers for sound effect operations
  void _handleEffectUpdated(
      Map<String, dynamic> effect, AssetModel? asset, int index) {
    setState(() {
      if (index >= 0 && index < _soundEffects.length) {
        // Cập nhật effect đã tồn tại
        _soundEffects[index] = effect;
        _soundEffectAssets[index] = asset;
      }
      // Cập nhật cấu hình
      _updateSoundConfig();
    });
  }

  void _handleEffectDeleted(int index) {
    setState(() {
      _soundEffects.removeAt(index);
      _soundEffectAssets.removeAt(index);
      // Cập nhật cấu hình
      _updateSoundConfig();
    });
  }

  void _handleEffectAdded(Map<String, dynamic> effect, AssetModel? asset) {
    setState(() {
      // Thêm effect mới
      _soundEffects.add(effect);
      _soundEffectAssets.add(asset);
      // Cập nhật cấu hình
      _updateSoundConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Âm Thanh',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          )
        else
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Global Settings
            GlobalSettingsSection(
              soundEnabled: _soundEnabled,
              masterVolume: _masterVolume,
              onSoundEnabledChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                  _updateSoundConfig();
                });
              },
              onMasterVolumeChanged: (value) {
                setState(() {
                  _masterVolume = value;
                });
              },
            ),

            if (_soundEnabled) ...[
              // Background Music Settings
              BackgroundMusicSection(
                bgmEnabled: _bgmEnabled,
                bgmPath: _bgmPath,
                bgmVolume: _bgmVolume,
                bgmLoop: _bgmLoop,
                bgmFadeInDuration: _bgmFadeInDuration,
                bgmFadeOutDuration: _bgmFadeOutDuration,
                randomizePlaylist: _randomizePlaylist,
                selectedBgmPreset: _selectedBgmPreset,
                bgmPresets: _bgmPresets,
                selectedBgmAsset: _selectedBgmAsset,
                onBgmEnabledChanged: (value) {
                  setState(() {
                    _bgmEnabled = value;
                    _updateSoundConfig();
                  });
                },
                onBgmPathChanged: (value) {
                  setState(() {
                    _bgmPath = value;
                  });
                },
                onBgmVolumeChanged: (value) {
                  setState(() {
                    _bgmVolume = value;
                  });
                },
                onBgmLoopChanged: (value) {
                  setState(() {
                    _bgmLoop = value;
                  });
                },
                onBgmFadeInDurationChanged: (value) {
                  setState(() {
                    _bgmFadeInDuration = value;
                  });
                },
                onBgmFadeOutDurationChanged: (value) {
                  setState(() {
                    _bgmFadeOutDuration = value;
                  });
                },
                onRandomizePlaylistChanged: (value) {
                  setState(() {
                    _randomizePlaylist = value;
                  });
                },
                onSelectedBgmPresetChanged: (value) {
                  setState(() {
                    _selectedBgmPreset = value;
                  });
                },
                onSelectedBgmAssetChanged: (asset) {
                  setState(() {
                    _selectedBgmAsset = asset;
                  });
                },
                onUpdateSoundConfig: _updateSoundConfig,
              ),

              // Sound Effects
              SoundEffectsSection(
                soundEffects: _soundEffects,
                soundEffectAssets: _soundEffectAssets,
                onEffectUpdated: _handleEffectUpdated,
                onEffectDeleted: _handleEffectDeleted,
                onEffectAdded: _handleEffectAdded,
              ),

              // Word Sounds Settings
              WordSoundsSection(
                wordSoundsEnabled: _wordSoundsEnabled,
                wordSoundPathTemplate: _wordSoundPathTemplate,
                wordSoundVolume: _wordSoundVolume,
                onWordSoundsEnabledChanged: (value) {
                  setState(() {
                    _wordSoundsEnabled = value;
                    _updateSoundConfig();
                  });
                },
                onWordSoundPathTemplateChanged: (value) {
                  setState(() {
                    _wordSoundPathTemplate = value;
                  });
                },
                onWordSoundVolumeChanged: (value) {
                  setState(() {
                    _wordSoundVolume = value;
                  });
                },
                onUpdateSoundConfig: _updateSoundConfig,
              ),

              // Update button
              ElevatedButton(
                onPressed: _updateSoundConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Cập nhật Preview'),
              ),
            ],
          ]),
      ],
    );
  }
}
