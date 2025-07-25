import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';
import 'package:flutter_learning/presentation/screens/game_config/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/sections/asset_manager_section/image_asset_selector.dart';

/// Widget để cấu hình câu trả lời trong game
class AnswerSection extends StatefulWidget {
  final Map<String, dynamic> answerConfig;
  final Function(Map<String, dynamic>) onAnswerConfigChanged;

  const AnswerSection({
    Key? key,
    required this.answerConfig,
    required this.onAnswerConfigChanged,
  }) : super(key: key);

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _currentAnswerConfig = {};

  // Layout values
  bool _useIndividualPositions = true;
  final TextEditingController _startPositionXController =
      TextEditingController();
  final TextEditingController _startPositionYController =
      TextEditingController();
  final TextEditingController _buttonSizeXController = TextEditingController();
  final TextEditingController _buttonSizeYController = TextEditingController();
  final TextEditingController _spacingController = TextEditingController();

  // Button positions list
  List<Map<String, dynamic>> _buttonPositions = [];

  // Style values
  Color _backgroundColor = Colors.white;
  Color _borderColor = Colors.blue;
  final TextEditingController _borderWidthController = TextEditingController();
  final TextEditingController _borderRadiusController = TextEditingController();
  Color _correctColor = Colors.green;
  Color _incorrectColor = Colors.red;

  // Icon settings
  final TextEditingController _iconPathController = TextEditingController();
  final TextEditingController _iconSizeXController = TextEditingController();
  final TextEditingController _iconSizeYController = TextEditingController();
  String _iconPosition = 'center';
  bool _animateOnHover = true;

  // Sound effects
  final TextEditingController _clickSoundController = TextEditingController();
  final TextEditingController _correctSoundController = TextEditingController();
  final TextEditingController _wrongSoundController = TextEditingController();

  // Asset Manager
  AssetModel? _selectedIconAsset;
  AssetModel? _selectedClickSoundAsset;
  AssetModel? _selectedCorrectSoundAsset;
  AssetModel? _selectedWrongSoundAsset;

  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build xong
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadAnswerConfig();
    });
  }

  @override
  void dispose() {
    _startPositionXController.dispose();
    _startPositionYController.dispose();
    _buttonSizeXController.dispose();
    _buttonSizeYController.dispose();
    _spacingController.dispose();
    _borderWidthController.dispose();
    _borderRadiusController.dispose();
    _iconPathController.dispose();
    _iconSizeXController.dispose();
    _iconSizeYController.dispose();
    _clickSoundController.dispose();
    _correctSoundController.dispose();
    _wrongSoundController.dispose();
    super.dispose();
  }

  void _loadAnswerConfig() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentAnswerConfig = Map<String, dynamic>.from(widget.answerConfig);
    });

    try {
      // Parse audio buttons data
      if (_currentAnswerConfig.containsKey('audioButtons')) {
        final audioButtons = _currentAnswerConfig['audioButtons'];

        // Parse layout
        if (audioButtons.containsKey('layout')) {
          final layout = audioButtons['layout'];

          if (layout.containsKey('useIndividualPositions')) {
            _useIndividualPositions = layout['useIndividualPositions'];
          }

          if (layout.containsKey('startPosition')) {
            _startPositionXController.text =
                layout['startPosition']['x'].toString();
            _startPositionYController.text =
                layout['startPosition']['y'].toString();
          }

          if (layout.containsKey('buttonSize')) {
            _buttonSizeXController.text = layout['buttonSize']['x'].toString();
            _buttonSizeYController.text = layout['buttonSize']['y'].toString();
          }

          if (layout.containsKey('spacing')) {
            _spacingController.text = layout['spacing'].toString();
          }

          if (layout.containsKey('buttonPositions') &&
              layout['buttonPositions'] is List) {
            _buttonPositions =
                List<Map<String, dynamic>>.from(layout['buttonPositions']);
          } else {
            _buttonPositions = [];
          }
        }

        // Parse style
        if (audioButtons.containsKey('style')) {
          final style = audioButtons['style'];

          if (style.containsKey('backgroundColor')) {
            final colorStr = style['backgroundColor'] as String;
            if (colorStr.startsWith('#')) {
              _backgroundColor = ColorUtils.fromHex(colorStr);
            }
          }

          if (style.containsKey('borderColor')) {
            final colorStr = style['borderColor'] as String;
            if (colorStr.startsWith('#')) {
              _borderColor = ColorUtils.fromHex(colorStr);
            }
          }

          if (style.containsKey('borderWidth')) {
            _borderWidthController.text = style['borderWidth'].toString();
          }

          if (style.containsKey('borderRadius')) {
            _borderRadiusController.text = style['borderRadius'].toString();
          }

          if (style.containsKey('correctColor')) {
            final colorStr = style['correctColor'] as String;
            if (colorStr.startsWith('#')) {
              _correctColor = ColorUtils.fromHex(colorStr);
            }
          }

          if (style.containsKey('incorrectColor')) {
            final colorStr = style['incorrectColor'] as String;
            if (colorStr.startsWith('#')) {
              _incorrectColor = ColorUtils.fromHex(colorStr);
            }
          }
        }

        // Parse icon settings
        if (audioButtons.containsKey('iconSettings')) {
          final iconSettings = audioButtons['iconSettings'];

          if (iconSettings.containsKey('path')) {
            _iconPathController.text = iconSettings['path'];
          }

          if (iconSettings.containsKey('size')) {
            _iconSizeXController.text = iconSettings['size']['x'].toString();
            _iconSizeYController.text = iconSettings['size']['y'].toString();
          }

          if (iconSettings.containsKey('position')) {
            _iconPosition = iconSettings['position'];
          }

          if (iconSettings.containsKey('animateOnHover')) {
            _animateOnHover = iconSettings['animateOnHover'];
          }
        }

        // Parse sound effects
        if (audioButtons.containsKey('soundEffects')) {
          final soundEffects = audioButtons['soundEffects'];

          if (soundEffects.containsKey('click')) {
            _clickSoundController.text = soundEffects['click'];
          }

          if (soundEffects.containsKey('correct')) {
            _correctSoundController.text = soundEffects['correct'];
          }

          if (soundEffects.containsKey('wrong')) {
            _wrongSoundController.text = soundEffects['wrong'];
          }
        }
      }

      // Cập nhật UI và báo rằng dữ liệu đã được tải xong
      setState(() {
        _isLoading = false;
      });

      // Tải các asset từ đường dẫn
      _loadAssetsFromPaths();

      // Cập nhật cấu hình sau khi frame hiện tại được render xong
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _updateAnswerConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải cấu hình câu trả lời: $e';
        _isLoading = false;
      });
    }
  }

  // Chuyển đổi từ màu hex sang Color
  Color _colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7 || hexString.length == 9) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else if (hexString.length == 8) {
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return Colors.black;
  }

  // Chuyển đổi từ Color sang hex string
  String _colorToHex(Color color, {bool withAlpha = true}) {
    if (withAlpha) {
      return '#${color.value.toRadixString(16).padLeft(8, '0')}';
    } else {
      return '#${color.value.toRadixString(16).substring(2).padLeft(6, '0')}';
    }
  }

  void _updateAnswerConfig() {
    try {
      // Xây dựng cấu hình audioButtons
      final audioButtons = {
        'layout': {
          'useIndividualPositions': _useIndividualPositions,
          'startPosition': {
            'x': double.tryParse(_startPositionXController.text) ?? 720.0,
            'y': _startPositionYController.text.contains('gameSize')
                ? _startPositionYController.text
                : double.tryParse(_startPositionYController.text) ?? 0.0,
          },
          'buttonSize': {
            'x': double.tryParse(_buttonSizeXController.text) ?? 100.0,
            'y': double.tryParse(_buttonSizeYController.text) ?? 100.0,
          },
          'spacing': double.tryParse(_spacingController.text) ?? 20.0,
          'buttonPositions': _buttonPositions,
        },
        'style': {
          'backgroundColor': _colorToHex(_backgroundColor),
          'borderColor': _colorToHex(_borderColor),
          'borderWidth': double.tryParse(_borderWidthController.text) ?? 2.0,
          'borderRadius': double.tryParse(_borderRadiusController.text) ?? 15.0,
          'correctColor': _colorToHex(_correctColor),
          'incorrectColor': _colorToHex(_incorrectColor),
        },
        'iconSettings': {
          'path': _iconPathController.text,
          'size': {
            'x': double.tryParse(_iconSizeXController.text) ?? 40.0,
            'y': double.tryParse(_iconSizeYController.text) ?? 40.0,
          },
          'position': _iconPosition,
          'animateOnHover': _animateOnHover,
        },
        'soundEffects': {
          'click': _clickSoundController.text,
          'correct': _correctSoundController.text,
          'wrong': _wrongSoundController.text,
        },
      };

      // Cập nhật cấu hình
      _currentAnswerConfig = {
        'audioButtons': audioButtons,
      };

      // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
      widget.onAnswerConfigChanged(_currentAnswerConfig);

      // In ra log để debug
      print('Answer config updated: ${json.encode(_currentAnswerConfig)}');
    } catch (e) {
      print('Error updating answer config: $e');
    }
  }

  // Thêm một vị trí mới cho button
  void _addButtonPosition() {
    setState(() {
      _buttonPositions.add({
        'x': 720.0,
        'y': 'gameSize.y / 2',
      });
      _updateAnswerConfig();
    });
  }

  // Cập nhật vị trí của button tại index
  void _updateButtonPosition(int index, String key, String value) {
    if (index >= 0 && index < _buttonPositions.length) {
      setState(() {
        if (value.contains('gameSize')) {
          _buttonPositions[index][key] = value;
        } else {
          _buttonPositions[index][key] = double.tryParse(value) ?? 0.0;
        }
        _updateAnswerConfig();
      });
    }
  }

  // Xóa vị trí của button tại index
  void _removeButtonPosition(int index) {
    if (index >= 0 && index < _buttonPositions.length) {
      setState(() {
        _buttonPositions.removeAt(index);
        _updateAnswerConfig();
      });
    }
  }

  // Hiển thị dialog đăng tải file
  Future<void> _showFileUploadDialog(
      String title, TextEditingController controller) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chọn từ danh sách hoặc nhập đường dẫn:'),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: controller.text),
              onChanged: (value) => controller.text = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Đường dẫn file',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: ListView(
                children: _getSampleFiles(title)
                    .map((file) => ListTile(
                          title: Text(file.split('/').last),
                          subtitle: Text(file),
                          onTap: () {
                            controller.text = file;
                            Navigator.pop(context, file);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Chọn'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        controller.text = result;
        _updateAnswerConfig();
      });
    }
  }

  // Tạo mẫu danh sách file dựa trên loại
  List<String> _getSampleFiles(String title) {
    if (title.contains('Icon')) {
      return [
        '../../assets/Multiple Choice/audio_icon.png',
        '../../assets/images/common/audio_icon.png',
        '../../assets/images/common/play_button.png',
      ];
    } else if (title.contains('Sound')) {
      return [
        '../../assets/Multiple Choice/SFX click.wav',
        '../../assets/Multiple Choice/SFX đúng.mp3',
        '../../assets/Multiple Choice/SFX sai.wav',
        '../../assets/Feed the Shark/SFX_coin.wav',
      ];
    }
    return [];
  }

  /// Hiển thị dialog chọn icon asset
  Future<void> _showIconAssetSelector() async {
    try {
      // Sử dụng widget ImageAssetSelectorDialog để chọn hình ảnh
      final selected = await showImageAssetSelector(
        context,
        initialSelectedAsset: _selectedIconAsset,
      );

      if (selected != null) {
        setState(() {
          _selectedIconAsset = selected;
          _iconPathController.text = selected.url ?? '';
          _updateAnswerConfig();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách hình ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Hiển thị dialog chọn audio asset
  Future<void> _showAudioAssetSelector(
      String title, TextEditingController controller,
      {AssetModel? initialSelectedAsset,
      Function(AssetModel)? onAssetSelected}) async {
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
                Text(
                  'Chọn $title',
                  style: const TextStyle(
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
                      final isSelected = initialSelectedAsset?.id == asset.id;

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
        setState(() {
          controller.text = result.url ?? '';
          if (onAssetSelected != null) {
            onAssetSelected(result);
          }
          _updateAnswerConfig();
        });
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

  /// Tải các asset đã lưu từ đường dẫn
  Future<void> _loadAssetsFromPaths() async {
    try {
      if (_currentAnswerConfig.isEmpty) return;

      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);

      // Tải icon asset
      if (_iconPathController.text.isNotEmpty) {
        final imageAssets =
            await assetRepository.getAssetsByType(AssetType.image);
        for (var asset in imageAssets) {
          if ((asset.url ?? '') == _iconPathController.text ||
              asset.path == _iconPathController.text) {
            _selectedIconAsset = asset;
            break;
          }
        }
      }

      // Tải sound assets
      final audioAssets =
          await assetRepository.getAssetsByType(AssetType.audio);

      // Click sound
      if (_clickSoundController.text.isNotEmpty) {
        for (var asset in audioAssets) {
          if ((asset.url ?? '') == _clickSoundController.text ||
              asset.path == _clickSoundController.text) {
            _selectedClickSoundAsset = asset;
            break;
          }
        }
      }

      // Correct sound
      if (_correctSoundController.text.isNotEmpty) {
        for (var asset in audioAssets) {
          if ((asset.url ?? '') == _correctSoundController.text ||
              asset.path == _correctSoundController.text) {
            _selectedCorrectSoundAsset = asset;
            break;
          }
        }
      }

      // Wrong sound
      if (_wrongSoundController.text.isNotEmpty) {
        for (var asset in audioAssets) {
          if ((asset.url ?? '') == _wrongSoundController.text ||
              asset.path == _wrongSoundController.text) {
            _selectedWrongSoundAsset = asset;
            break;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Câu Trả Lời',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Layout Configuration
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Layout',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // UseIndividualPositions
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sử dụng vị trí riêng cho mỗi nút',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const Text(
                                  'Nếu bật, mỗi nút sẽ có vị trí riêng biệt',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _useIndividualPositions,
                            onChanged: (value) {
                              setState(() {
                                _useIndividualPositions = value;
                                _updateAnswerConfig();
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Start Position
                      Text('Vị trí bắt đầu',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _startPositionXController,
                              decoration: const InputDecoration(
                                labelText: 'X',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _startPositionYController,
                              decoration: const InputDecoration(
                                labelText: 'Y',
                                helperText: 'Hỗ trợ gameSize.y',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Button Size
                      Text('Kích thước nút',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _buttonSizeXController,
                              decoration: const InputDecoration(
                                labelText: 'Width',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _buttonSizeYController,
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Spacing
                      ConfigTextField(
                        label: 'Khoảng cách giữa các nút',
                        value: _spacingController.text,
                        onChanged: (value) {
                          _spacingController.text = value;
                          _updateAnswerConfig();
                        },
                        helperText:
                            'Khoảng cách giữa các nút khi không dùng vị trí riêng',
                      ),

                      if (_useIndividualPositions) ...[
                        const SizedBox(height: 16),
                        // Button Positions list
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Vị trí các nút',
                                style: Theme.of(context).textTheme.titleSmall),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm nút'),
                              onPressed: _addButtonPosition,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _buttonPositions.length,
                          itemBuilder: (context, index) {
                            final position = _buttonPositions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'X',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: TextEditingController(
                                            text: position['x'].toString()),
                                        onChanged: (value) {
                                          _updateButtonPosition(
                                              index, 'x', value);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Y',
                                          helperText: 'Hỗ trợ gameSize.y',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: TextEditingController(
                                            text: position['y'].toString()),
                                        onChanged: (value) {
                                          _updateButtonPosition(
                                              index, 'y', value);
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        _removeButtonPosition(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Style Configuration
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Style',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Background Color
                      Row(
                        children: [
                          Expanded(
                            child: Text('Màu nền',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ColorPickerDialog.show(
                                context,
                                _backgroundColor,
                                (color) {
                                  setState(() {
                                    _backgroundColor = color;
                                    _updateAnswerConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _backgroundColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Border Color
                      Row(
                        children: [
                          Expanded(
                            child: Text('Màu viền',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ColorPickerDialog.show(
                                context,
                                _borderColor,
                                (color) {
                                  setState(() {
                                    _borderColor = color;
                                    _updateAnswerConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _borderColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Border Width
                      ConfigTextField(
                        label: 'Độ rộng viền',
                        value: _borderWidthController.text,
                        onChanged: (value) {
                          _borderWidthController.text = value;
                          _updateAnswerConfig();
                        },
                        helperText: 'Độ rộng của viền nút',
                      ),

                      // Border Radius
                      ConfigTextField(
                        label: 'Bo góc',
                        value: _borderRadiusController.text,
                        onChanged: (value) {
                          _borderRadiusController.text = value;
                          _updateAnswerConfig();
                        },
                        helperText: 'Độ bo góc của nút',
                      ),

                      const SizedBox(height: 16),
                      // Correct Color
                      Row(
                        children: [
                          Expanded(
                            child: Text('Màu khi đúng',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ColorPickerDialog.show(
                                context,
                                _correctColor,
                                (color) {
                                  setState(() {
                                    _correctColor = color;
                                    _updateAnswerConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _correctColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Incorrect Color
                      Row(
                        children: [
                          Expanded(
                            child: Text('Màu khi sai',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ColorPickerDialog.show(
                                context,
                                _incorrectColor,
                                (color) {
                                  setState(() {
                                    _incorrectColor = color;
                                    _updateAnswerConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _incorrectColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Icon Settings
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Icon',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Icon Path
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Đường dẫn icon',
                              value: _iconPathController.text,
                              onChanged: (value) {
                                _iconPathController.text = value;
                                _updateAnswerConfig();
                              },
                              helperText: 'Đường dẫn đến file icon',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: _showIconAssetSelector,
                          ),
                        ],
                      ),

                      // Hiển thị icon đã chọn
                      if (_selectedIconAsset != null &&
                          _iconPathController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Text('Icon đã chọn:'),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: _selectedIconAsset!.url ?? '',
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 20),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedIconAsset!.name,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),
                      // Icon Size
                      Text('Kích thước icon',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _iconSizeXController,
                              decoration: const InputDecoration(
                                labelText: 'Width',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _iconSizeYController,
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateAnswerConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Icon Position
                      ConfigDropdown<String>(
                        label: 'Vị trí icon',
                        value: _iconPosition,
                        items: const [
                          'center',
                          'left',
                          'right',
                          'top',
                          'bottom'
                        ],
                        onChanged: (value) {
                          setState(() {
                            _iconPosition = value;
                            _updateAnswerConfig();
                          });
                        },
                        helperText: 'Vị trí của icon trong nút',
                      ),

                      // Animate on hover
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hiệu ứng hover',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const Text(
                                  'Hiệu ứng khi di chuột vào nút',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _animateOnHover,
                            onChanged: (value) {
                              setState(() {
                                _animateOnHover = value;
                                _updateAnswerConfig();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Sound Effects
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Âm Thanh',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Click Sound
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Âm thanh click',
                              value: _clickSoundController.text,
                              onChanged: (value) {
                                _clickSoundController.text = value;
                                _updateAnswerConfig();
                              },
                              helperText: 'Âm thanh khi click vào nút',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: () {
                              _showAudioAssetSelector(
                                'Chọn Sound Effect',
                                _clickSoundController,
                                initialSelectedAsset: _selectedClickSoundAsset,
                                onAssetSelected: (asset) {
                                  _selectedClickSoundAsset = asset;
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      // Hiển thị tên file âm thanh click đã chọn
                      if (_selectedClickSoundAsset != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.audio_file, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedClickSoundAsset!.name,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Correct Sound
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Âm thanh đúng',
                              value: _correctSoundController.text,
                              onChanged: (value) {
                                _correctSoundController.text = value;
                                _updateAnswerConfig();
                              },
                              helperText: 'Âm thanh khi trả lời đúng',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: () {
                              _showAudioAssetSelector(
                                'Chọn Sound Effect',
                                _correctSoundController,
                                initialSelectedAsset:
                                    _selectedCorrectSoundAsset,
                                onAssetSelected: (asset) {
                                  _selectedCorrectSoundAsset = asset;
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      // Hiển thị tên file âm thanh đúng đã chọn
                      if (_selectedCorrectSoundAsset != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.audio_file,
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedCorrectSoundAsset!.name,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Wrong Sound
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Âm thanh sai',
                              value: _wrongSoundController.text,
                              onChanged: (value) {
                                _wrongSoundController.text = value;
                                _updateAnswerConfig();
                              },
                              helperText: 'Âm thanh khi trả lời sai',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: () {
                              _showAudioAssetSelector(
                                'Chọn Sound Effect',
                                _wrongSoundController,
                                initialSelectedAsset: _selectedWrongSoundAsset,
                                onAssetSelected: (asset) {
                                  _selectedWrongSoundAsset = asset;
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      // Hiển thị tên file âm thanh sai đã chọn
                      if (_selectedWrongSoundAsset != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.audio_file,
                                  size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedWrongSoundAsset!.name,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Update button
              ElevatedButton(
                onPressed: _updateAnswerConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Cập nhật Preview'),
              ),
            ],
          ),
      ],
    );
  }
}
