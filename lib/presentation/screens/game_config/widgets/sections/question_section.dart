import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../config_editor_panel.dart';

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
            _boxBackgroundColor = _colorFromHex(colorStr);
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
            _targetBorderColor = _colorFromHex(colorStr);
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
              _textColor = _colorFromHex(colorStr);
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
      'backgroundColor': _colorToHex(_boxBackgroundColor),
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
      'borderColor': _colorToHex(_targetBorderColor),
      'priority': int.tryParse(_targetPriorityController.text) ?? 80,
      'showTextOnCorrect': _showTextOnCorrect,
      'textStyle': {
        'color': _colorToHex(_textColor),
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

  // Hiển thị color picker
  Future<void> _showColorPicker(BuildContext context, Color initialColor,
      Function(Color) onColorChanged) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Chọn'),
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      onColorChanged(result);
    }
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
                              await _showColorPicker(
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

                      // Path
                      ConfigTextField(
                        label: 'Đường dẫn',
                        value: _targetPathController.text,
                        onChanged: (value) {
                          _targetPathController.text = value;
                          _updateQuestionConfig();
                        },
                        helperText:
                            'Đường dẫn đến file hình ảnh, hỗ trợ template {text}',
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
                              await _showColorPicker(
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
                                await _showColorPicker(
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
