import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';
import 'package:flutter_learning/presentation/screens/game_config/utils/color_utils.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_learning/presentation/screens/game_config/widgets/sections/asset_manager_section/image_asset_selector.dart';

/// Widget để cấu hình câu hỏi trong game
class QuestionSection extends StatefulWidget {
  final Map<String, dynamic> questionConfig;
  final Function(Map<String, dynamic>) onQuestionConfigChanged;

  const QuestionSection({
    Key? key,
    required this.questionConfig,
    required this.onQuestionConfigChanged,
  }) : super(key: key);

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _currentQuestionConfig = {};

  // BoxQuestion values
  final TextEditingController _boxPositionXController = TextEditingController();
  final TextEditingController _boxPositionYController = TextEditingController();
  final TextEditingController _boxSizeXController = TextEditingController();
  final TextEditingController _boxSizeYController = TextEditingController();
  final TextEditingController _boxBorderRadiusController =
      TextEditingController();
  Color _boxBackgroundColor = Colors.white;

  // TargetImage values
  String _targetType = 'image';
  final TextEditingController _targetPathController = TextEditingController();
  final TextEditingController _targetPositionXController =
      TextEditingController();
  final TextEditingController _targetPositionYController =
      TextEditingController();
  final TextEditingController _targetSizeXController = TextEditingController();
  final TextEditingController _targetSizeYController = TextEditingController();
  Color _targetBorderColor = Colors.grey.withOpacity(0.5);
  final TextEditingController _targetPriorityController =
      TextEditingController();
  bool _showTextOnCorrect = true;
  Color _textColor = Colors.green;
  final TextEditingController _textFontSizeController = TextEditingController();
  String _textFontWeight = 'bold';

  // Asset Manager
  AssetModel? _selectedImageAsset;

  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build xong
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadQuestionConfig();
    });
  }

  @override
  void dispose() {
    _boxPositionXController.dispose();
    _boxPositionYController.dispose();
    _boxSizeXController.dispose();
    _boxSizeYController.dispose();
    _boxBorderRadiusController.dispose();
    _targetPathController.dispose();
    _targetPositionXController.dispose();
    _targetPositionYController.dispose();
    _targetSizeXController.dispose();
    _targetSizeYController.dispose();
    _targetPriorityController.dispose();
    _textFontSizeController.dispose();
    super.dispose();
  }

  void _loadQuestionConfig() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentQuestionConfig = Map<String, dynamic>.from(widget.questionConfig);
    });

    try {
      // Parse box question data
      if (_currentQuestionConfig.containsKey('boxQuestion')) {
        final boxQuestion = _currentQuestionConfig['boxQuestion'];

        // Position
        if (boxQuestion.containsKey('position')) {
          _boxPositionXController.text =
              boxQuestion['position']['x'].toString();
          _boxPositionYController.text =
              boxQuestion['position']['y'].toString();
        }

        // Size
        if (boxQuestion.containsKey('size')) {
          _boxSizeXController.text = boxQuestion['size']['x'].toString();
          _boxSizeYController.text = boxQuestion['size']['y'].toString();
        }

        // Background color
        if (boxQuestion.containsKey('backgroundColor')) {
          final colorStr = boxQuestion['backgroundColor'] as String;
          if (colorStr.startsWith('#')) {
            _boxBackgroundColor = ColorUtils.fromHex(colorStr);
          }
        }

        // Border radius
        if (boxQuestion.containsKey('borderRadius')) {
          _boxBorderRadiusController.text =
              boxQuestion['borderRadius'].toString();
        }
      }

      // Parse target image data
      if (_currentQuestionConfig.containsKey('targetImage')) {
        final targetImage = _currentQuestionConfig['targetImage'];

        // Type
        if (targetImage.containsKey('type')) {
          _targetType = targetImage['type'];
        }

        // Path
        if (targetImage.containsKey('path')) {
          _targetPathController.text = targetImage['path'];

          // Kiểm tra nếu đường dẫn là URL, tải asset tương ứng
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _loadImageAssetFromPath(_targetPathController.text);
          });
        }

        // Position
        if (targetImage.containsKey('position')) {
          _targetPositionXController.text =
              targetImage['position']['x'].toString();
          _targetPositionYController.text =
              targetImage['position']['y'].toString();
        }

        // Size
        if (targetImage.containsKey('size')) {
          _targetSizeXController.text = targetImage['size']['x'].toString();
          _targetSizeYController.text = targetImage['size']['y'].toString();
        }

        // Border color
        if (targetImage.containsKey('borderColor')) {
          final colorStr = targetImage['borderColor'] as String;
          if (colorStr.startsWith('#')) {
            _targetBorderColor = ColorUtils.fromHex(colorStr);
          }
        }

        // Priority
        if (targetImage.containsKey('priority')) {
          _targetPriorityController.text = targetImage['priority'].toString();
        }

        // Show text on correct
        if (targetImage.containsKey('showTextOnCorrect')) {
          _showTextOnCorrect = targetImage['showTextOnCorrect'];
        }

        // Text style
        if (targetImage.containsKey('textStyle')) {
          final textStyle = targetImage['textStyle'];

          if (textStyle.containsKey('color')) {
            final colorStr = textStyle['color'] as String;
            if (colorStr.startsWith('#')) {
              _textColor = ColorUtils.fromHex(colorStr);
            }
          }

          if (textStyle.containsKey('fontSize')) {
            _textFontSizeController.text = textStyle['fontSize'].toString();
          }

          if (textStyle.containsKey('fontWeight')) {
            _textFontWeight = textStyle['fontWeight'];
          }
        }
      }

      // Không gọi _updateQuestionConfig() ở đây nữa
      // Thay vào đó, cập nhật UI và báo rằng dữ liệu đã được tải xong
      setState(() {
        _isLoading = false;
      });

      // Cập nhật cấu hình sau khi frame hiện tại được render xong
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _updateQuestionConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải cấu hình câu hỏi: $e';
        _isLoading = false;
      });
    }
  }

  /// Tìm kiếm asset image dựa vào đường dẫn
  Future<void> _loadImageAssetFromPath(String path) async {
    if (path.isEmpty) return;

    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final imageAssets =
          await assetRepository.getAssetsByType(AssetType.image);

      for (var asset in imageAssets) {
        // Kiểm tra đường dẫn chính xác hoặc URL
        if ((asset.url ?? '') == path || asset.name == path) {
          setState(() {
            _selectedImageAsset = asset;
          });
          break;
        }
      }
    } catch (e) {
      print('Không thể tìm image asset: $e');
    }
  }

  void _updateQuestionConfig() {
    // Xây dựng cấu hình boxQuestion
    final boxQuestion = {
      'position': {
        'x': double.tryParse(_boxPositionXController.text) ?? 460.0,
        'y': _boxPositionYController.text.contains('gameSize')
            ? _boxPositionYController.text
            : double.tryParse(_boxPositionYController.text) ?? 0.0,
      },
      'size': {
        'x': double.tryParse(_boxSizeXController.text) ?? 220.0,
        'y': double.tryParse(_boxSizeYController.text) ?? 360.0,
      },
      'backgroundColor': ColorUtils.toHex(_boxBackgroundColor),
      'borderRadius': double.tryParse(_boxBorderRadiusController.text) ?? 15.0,
    };

    // Xây dựng cấu hình targetImage
    final targetImage = {
      'type': _targetType,
      'path': _targetPathController.text,
      'position': {
        'x': double.tryParse(_targetPositionXController.text) ?? 500.0,
        'y': _targetPositionYController.text.contains('gameSize')
            ? _targetPositionYController.text
            : double.tryParse(_targetPositionYController.text) ?? 0.0,
      },
      'size': {
        'x': double.tryParse(_targetSizeXController.text) ?? 150.0,
        'y': double.tryParse(_targetSizeYController.text) ?? 150.0,
      },
      'borderColor': ColorUtils.toHex(_targetBorderColor),
      'priority': int.tryParse(_targetPriorityController.text) ?? 80,
      'showTextOnCorrect': _showTextOnCorrect,
      'textStyle': {
        'color': ColorUtils.toHex(_textColor),
        'fontSize': int.tryParse(_textFontSizeController.text) ?? 24,
        'fontWeight': _textFontWeight,
      },
    };

    // Cập nhật cấu hình
    _currentQuestionConfig = {
      'boxQuestion': boxQuestion,
      'targetImage': targetImage,
    };

    // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
    widget.onQuestionConfigChanged(_currentQuestionConfig);

    // In ra log để debug
    print('Question config updated: ${json.encode(_currentQuestionConfig)}');
  }

  /// Hiển thị dialog chọn image asset
  Future<void> _showImageAssetSelector() async {
    try {
      // Sử dụng widget mới ImageAssetSelector để chọn hình ảnh
      final selected = await showImageAssetSelector(
        context,
        initialSelectedAsset: _selectedImageAsset,
      );

      if (selected != null) {
        setState(() {
          _selectedImageAsset = selected;
          _targetPathController.text = selected.url ?? '';
          _updateQuestionConfig();
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

  /// Upload hình ảnh mới
  Future<void> _uploadNewImage() async {
    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);

      // Hiển thị dialog để lấy tên cho hình ảnh
      final String? customName = await showDialog<String>(
        context: context,
        builder: (context) {
          final TextEditingController nameController = TextEditingController();
          return AlertDialog(
            title: const Text('Tên hình ảnh'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nhập tên cho hình ảnh này:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên...',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập tên!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, nameController.text);
                },
                child: const Text('Xác nhận'),
              ),
            ],
          );
        },
      );

      if (customName == null || customName.isEmpty) {
        return;
      }

      // Mở file picker để chọn hình ảnh
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      // Hiển thị indicator khi đang upload
      _showUploadingDialog();

      try {
        AssetModel? uploadedAsset;

        // Sử dụng phương thức phù hợp tùy thuộc vào nền tảng
        if (kIsWeb) {
          if (result.files.first.bytes != null) {
            // Upload trên web
            uploadedAsset = await assetRepository.uploadImageAssetWeb(
              result.files.first.bytes!,
              result.files.first.name,
              customName: customName,
            );
          }
        } else {
          if (result.files.first.path != null) {
            // Upload trên mobile/desktop
            final file = File(result.files.first.path!);
            uploadedAsset = await assetRepository.uploadImageAsset(
              file,
              customName: customName,
            );
          }
        }

        // Đóng dialog upload
        Navigator.of(context, rootNavigator: true).pop();

        if (uploadedAsset != null) {
          setState(() {
            _selectedImageAsset = uploadedAsset;
            _targetPathController.text = uploadedAsset?.url ?? '';
            _updateQuestionConfig();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Tải lên hình ảnh "${uploadedAsset.name}" thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải lên hình ảnh. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Đóng dialog upload nếu có lỗi
        Navigator.of(context, rootNavigator: true).pop();
        rethrow;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên hình ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hiển thị dialog khi đang tải lên
  Future<void> _showUploadingDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải lên hình ảnh...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Câu Hỏi', style: Theme.of(context).textTheme.titleLarge),
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
              // Box Question Configuration
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Box Question',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Box Position
                      Text('Vị trí',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _boxPositionXController,
                              decoration: const InputDecoration(
                                labelText: 'X',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _boxPositionYController,
                              decoration: const InputDecoration(
                                labelText: 'Y',
                                helperText: 'Hỗ trợ gameSize.y',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Box Size
                      Text('Kích thước',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _boxSizeXController,
                              decoration: const InputDecoration(
                                labelText: 'Width',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _boxSizeYController,
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Box Background Color
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
                                _boxBackgroundColor,
                                (color) {
                                  setState(() {
                                    _boxBackgroundColor = color;
                                    _updateQuestionConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _boxBackgroundColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Border Radius
                      ConfigTextField(
                        label: 'Border Radius',
                        value: _boxBorderRadiusController.text,
                        onChanged: (value) {
                          _boxBorderRadiusController.text = value;
                          _updateQuestionConfig();
                        },
                        helperText: 'Độ bo góc của box',
                      ),
                    ],
                  ),
                ),
              ),

              // Target Image Configuration
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cấu Hình Target Image',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Target Type
                      ConfigDropdown<String>(
                        label: 'Loại',
                        value: _targetType,
                        items: const ['image', 'spine', 'animation'],
                        onChanged: (value) {
                          setState(() {
                            _targetType = value;
                            _updateQuestionConfig();
                          });
                        },
                        helperText: 'Loại target hiển thị',
                      ),

                      // Path with Asset Manager integration
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Đường dẫn / Hình ảnh'),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _targetPathController,
                                  decoration: const InputDecoration(
                                    labelText: 'Đường dẫn',
                                    helperText:
                                        'Đường dẫn hình ảnh hoặc chọn từ Asset Manager',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    _updateQuestionConfig();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.image_search),
                                    label: const Text('Chọn hình'),
                                    onPressed: _showImageAssetSelector,
                                  ),
                                  if (_targetType == 'image' &&
                                      _selectedImageAsset != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      width: 100,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _selectedImageAsset!.url ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Target Position
                      Text('Vị trí',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _targetPositionXController,
                              decoration: const InputDecoration(
                                labelText: 'X',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _targetPositionYController,
                              decoration: const InputDecoration(
                                labelText: 'Y',
                                helperText: 'Hỗ trợ gameSize.y',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Target Size
                      Text('Kích thước',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _targetSizeXController,
                              decoration: const InputDecoration(
                                labelText: 'Width',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _targetSizeYController,
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _updateQuestionConfig();
                              },
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
                                _targetBorderColor,
                                (color) {
                                  setState(() {
                                    _targetBorderColor = color;
                                    _updateQuestionConfig();
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _targetBorderColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Priority
                      ConfigTextField(
                        label: 'Priority',
                        value: _targetPriorityController.text,
                        onChanged: (value) {
                          _targetPriorityController.text = value;
                          _updateQuestionConfig();
                        },
                        helperText: 'Độ ưu tiên hiển thị (z-index)',
                      ),

                      const SizedBox(height: 16),
                      // Show Text On Correct
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hiển thị chữ khi đúng',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const Text(
                                  'Hiển thị text khi trả lời đúng',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _showTextOnCorrect,
                            onChanged: (value) {
                              setState(() {
                                _showTextOnCorrect = value;
                                _updateQuestionConfig();
                              });
                            },
                          ),
                        ],
                      ),

                      if (_showTextOnCorrect) ...[
                        const SizedBox(height: 16),
                        // Text Style
                        Text('Kiểu chữ',
                            style: Theme.of(context).textTheme.titleSmall),

                        const SizedBox(height: 8),
                        // Text Color
                        Row(
                          children: [
                            Expanded(
                              child: const Text('Màu chữ'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await ColorPickerDialog.show(
                                  context,
                                  _textColor,
                                  (color) {
                                    setState(() {
                                      _textColor = color;
                                      _updateQuestionConfig();
                                    });
                                  },
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _textColor,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        // Font Size
                        ConfigTextField(
                          label: 'Cỡ chữ',
                          value: _textFontSizeController.text,
                          onChanged: (value) {
                            _textFontSizeController.text = value;
                            _updateQuestionConfig();
                          },
                          helperText: 'Kích thước font chữ',
                        ),

                        const SizedBox(height: 8),
                        // Font Weight
                        ConfigDropdown<String>(
                          label: 'Độ đậm',
                          value: _textFontWeight,
                          items: const [
                            'normal',
                            'bold',
                            'w300',
                            'w400',
                            'w500',
                            'w600',
                            'w700',
                            'w800',
                            'w900'
                          ],
                          onChanged: (value) {
                            setState(() {
                              _textFontWeight = value;
                              _updateQuestionConfig();
                            });
                          },
                          helperText: 'Độ đậm của font chữ',
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Update button
              ElevatedButton(
                onPressed: _updateQuestionConfig,
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
