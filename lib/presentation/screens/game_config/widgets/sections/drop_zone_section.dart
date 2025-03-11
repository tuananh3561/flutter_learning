import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';

/// Widget để cấu hình các drop zone trong game
class DropZoneSection extends StatefulWidget {
  final Map<String, dynamic> dropZoneConfig;
  final Function(Map<String, dynamic>) onDropZoneConfigChanged;

  const DropZoneSection({
    Key? key,
    required this.dropZoneConfig,
    required this.onDropZoneConfigChanged,
  }) : super(key: key);

  @override
  State<DropZoneSection> createState() => _DropZoneSectionState();
}

class _DropZoneSectionState extends State<DropZoneSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _currentDropZoneConfig = {};

  // Global settings
  bool _enabled = true;

  // Drop zone list
  List<Map<String, dynamic>> _zones = [];

  // Current editing zone state
  int _currentEditingIndex = -1;
  int _currentZoneId = 1;
  final TextEditingController _positionXController = TextEditingController();
  final TextEditingController _positionYController = TextEditingController();
  final TextEditingController _sizeXController = TextEditingController();
  final TextEditingController _sizeYController = TextEditingController();
  Color _backgroundColor = Color(0x50E3F2FD);
  Color _borderColor = Colors.blue;
  final TextEditingController _borderRadiusController = TextEditingController();
  bool _borderDashed = true;

  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build xong
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadDropZoneConfig();
    });
  }

  @override
  void dispose() {
    _positionXController.dispose();
    _positionYController.dispose();
    _sizeXController.dispose();
    _sizeYController.dispose();
    _borderRadiusController.dispose();
    super.dispose();
  }

  void _loadDropZoneConfig() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentDropZoneConfig = Map<String, dynamic>.from(widget.dropZoneConfig);
    });

    try {
      // Parse enabled status
      if (_currentDropZoneConfig.containsKey('enabled')) {
        _enabled = _currentDropZoneConfig['enabled'];
      }

      // Parse zones
      if (_currentDropZoneConfig.containsKey('zones') &&
          _currentDropZoneConfig['zones'] is List) {
        _zones =
            List<Map<String, dynamic>>.from(_currentDropZoneConfig['zones']);

        // Find the highest ID to avoid duplicates when adding new zones
        if (_zones.isNotEmpty) {
          int maxId = 0;
          for (final zone in _zones) {
            if (zone.containsKey('id') &&
                zone['id'] is int &&
                zone['id'] > maxId) {
              maxId = zone['id'];
            }
          }
          _currentZoneId = maxId + 1;
        }
      } else {
        _zones = [];
      }

      // Set initial editing values to defaults
      _resetEditingForm();

      // Update UI
      setState(() {
        _isLoading = false;
      });

      // Cập nhật cấu hình sau khi frame hiện tại được render xong
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _updateDropZoneConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải cấu hình drop zone: $e';
        _isLoading = false;
      });
    }
  }

  void _resetEditingForm() {
    _positionXController.text = '520.0';
    _positionYController.text = 'gameSize.y / 2 + 25.0';
    _sizeXController.text = '100.0';
    _sizeYController.text = '100.0';
    _backgroundColor = Color(0x50E3F2FD);
    _borderColor = Colors.blue;
    _borderRadiusController.text = '15.0';
    _borderDashed = true;

    _currentEditingIndex = -1;
  }

  void _updateDropZoneConfig() {
    try {
      // Tạo cấu hình mới
      _currentDropZoneConfig = {
        'enabled': _enabled,
        'zones': _zones,
      };

      // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
      widget.onDropZoneConfigChanged(_currentDropZoneConfig);

      // In ra log để debug
      print('Drop zone config updated: ${json.encode(_currentDropZoneConfig)}');
    } catch (e) {
      print('Error updating drop zone config: $e');
    }
  }

  // Bắt đầu chỉnh sửa một zone
  void _startEditingZone(int index) {
    if (index < 0 || index >= _zones.length) return;

    final zone = _zones[index];

    setState(() {
      _currentEditingIndex = index;

      // Position
      if (zone.containsKey('position')) {
        _positionXController.text = zone['position']['x'].toString();
        _positionYController.text = zone['position']['y'].toString();
      }

      // Size
      if (zone.containsKey('size')) {
        _sizeXController.text = zone['size']['x'].toString();
        _sizeYController.text = zone['size']['y'].toString();
      }

      // Style
      if (zone.containsKey('style')) {
        final style = zone['style'];

        // Background color
        if (style.containsKey('backgroundColor')) {
          final colorStr = style['backgroundColor'] as String;
          if (colorStr.startsWith('#')) {
            _backgroundColor = _colorFromHex(colorStr);
          }
        }

        // Border color
        if (style.containsKey('borderColor')) {
          final colorStr = style['borderColor'] as String;
          if (colorStr.startsWith('#')) {
            _borderColor = _colorFromHex(colorStr);
          }
        }

        // Border radius
        if (style.containsKey('borderRadius')) {
          _borderRadiusController.text = style['borderRadius'].toString();
        }

        // Border dashed
        if (style.containsKey('borderDashed')) {
          _borderDashed = style['borderDashed'];
        }
      }
    });
  }

  // Lưu thông tin zone đang chỉnh sửa
  void _saveEditingZone() {
    final zone = {
      'id': _currentEditingIndex >= 0
          ? _zones[_currentEditingIndex]['id']
          : _currentZoneId,
      'position': {
        'x': _positionXController.text.contains('.')
            ? double.tryParse(_positionXController.text) ?? 520.0
            : int.tryParse(_positionXController.text) ?? 520,
        'y': _positionYController.text.contains('gameSize')
            ? _positionYController.text
            : (_positionYController.text.contains('.')
                ? double.tryParse(_positionYController.text) ?? 0.0
                : int.tryParse(_positionYController.text) ?? 0),
      },
      'size': {
        'x': _sizeXController.text.contains('.')
            ? double.tryParse(_sizeXController.text) ?? 100.0
            : int.tryParse(_sizeXController.text) ?? 100,
        'y': _sizeYController.text.contains('.')
            ? double.tryParse(_sizeYController.text) ?? 100.0
            : int.tryParse(_sizeYController.text) ?? 100,
      },
      'style': {
        'backgroundColor': _colorToHex(_backgroundColor),
        'borderColor': _colorToHex(_borderColor),
        'borderRadius': double.tryParse(_borderRadiusController.text) ?? 15.0,
        'borderDashed': _borderDashed,
      },
    };

    setState(() {
      if (_currentEditingIndex >= 0 && _currentEditingIndex < _zones.length) {
        // Cập nhật zone đã tồn tại
        _zones[_currentEditingIndex] = zone;
      } else {
        // Thêm zone mới
        _zones.add(zone);
        _currentZoneId++; // Tăng ID cho zone tiếp theo
      }

      // Reset form
      _resetEditingForm();

      // Cập nhật cấu hình
      _updateDropZoneConfig();
    });
  }

  // Xóa một zone
  void _deleteZone(int index) {
    if (index < 0 || index >= _zones.length) return;

    setState(() {
      _zones.removeAt(index);

      // Nếu đang chỉnh sửa zone bị xóa, reset form
      if (_currentEditingIndex == index) {
        _resetEditingForm();
      }
      // Nếu đang chỉnh sửa zone sau zone bị xóa, cập nhật index
      else if (_currentEditingIndex > index) {
        _currentEditingIndex--;
      }

      // Cập nhật cấu hình
      _updateDropZoneConfig();
    });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Drop Zone',
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
              // Global settings
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cài đặt chung',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Enable/disable drop zones
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kích hoạt Drop Zones',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const Text(
                                  'Bật/tắt tính năng drop zones trong game',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _enabled,
                            onChanged: (value) {
                              setState(() {
                                _enabled = value;
                                _updateDropZoneConfig();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (_enabled) ...[
                // Zones list
                Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Danh sách Drop Zones',
                                style: Theme.of(context).textTheme.titleMedium),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm Zone'),
                              onPressed: () {
                                _resetEditingForm();
                                _saveEditingZone();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_zones.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                  'Chưa có drop zone nào. Nhấn "Thêm Zone" để tạo mới.'),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _zones.length,
                            itemBuilder: (context, index) {
                              final zone = _zones[index];
                              final isSelected = index == _currentEditingIndex;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8.0),
                                color: isSelected ? Colors.blue.shade50 : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: isSelected
                                      ? BorderSide(
                                          color: Colors.blue.shade300, width: 2)
                                      : BorderSide.none,
                                ),
                                child: ListTile(
                                  title: Text('Zone ID: ${zone['id']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Position: (${zone['position']['x']}, ${zone['position']['y']})'),
                                      Text(
                                          'Size: ${zone['size']['x']} x ${zone['size']['y']}'),
                                      if (zone.containsKey('style'))
                                        Text(
                                            'Border Radius: ${zone['style']['borderRadius']}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            _startEditingZone(index),
                                        tooltip: 'Chỉnh sửa',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteZone(index),
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
                ),

                // Zone editor
                Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            _currentEditingIndex >= 0
                                ? 'Chỉnh sửa Zone (ID: ${_zones[_currentEditingIndex]['id']})'
                                : 'Thêm Zone mới',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),

                        // Position
                        Text('Vị trí',
                            style: Theme.of(context).textTheme.titleSmall),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _positionXController,
                                decoration: const InputDecoration(
                                  labelText: 'X',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Không cập nhật config cho đến khi lưu
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _positionYController,
                                decoration: const InputDecoration(
                                  labelText: 'Y',
                                  helperText: 'Hỗ trợ gameSize.y',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Không cập nhật config cho đến khi lưu
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Size
                        Text('Kích thước',
                            style: Theme.of(context).textTheme.titleSmall),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _sizeXController,
                                decoration: const InputDecoration(
                                  labelText: 'Width',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Không cập nhật config cho đến khi lưu
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _sizeYController,
                                decoration: const InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Không cập nhật config cho đến khi lưu
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Style
                        Text('Kiểu dáng',
                            style: Theme.of(context).textTheme.titleSmall),

                        // Background Color
                        Row(
                          children: [
                            Expanded(
                              child: Text('Màu nền',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await ColorPickerDialog.show(
                                  context,
                                  _backgroundColor,
                                  (color) {
                                    setState(() {
                                      _backgroundColor = color;
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
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await ColorPickerDialog.show(
                                  context,
                                  _borderColor,
                                  (color) {
                                    setState(() {
                                      _borderColor = color;
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
                        // Border Radius
                        ConfigTextField(
                          label: 'Bo góc viền',
                          value: _borderRadiusController.text,
                          onChanged: (value) {
                            _borderRadiusController.text = value;
                          },
                          helperText: 'Độ bo góc của drop zone',
                        ),

                        // Border Dashed
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Viền đứt đoạn',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const Text(
                                    'Sử dụng viền đứt đoạn thay vì viền liền',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _borderDashed,
                              onChanged: (value) {
                                setState(() {
                                  _borderDashed = value;
                                });
                              },
                            ),
                          ],
                        ),

                        // Preview
                        const SizedBox(height: 24),
                        Text('Xem trước',
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width:
                                double.tryParse(_sizeXController.text) ?? 100,
                            height:
                                double.tryParse(_sizeYController.text) ?? 100,
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              border: _borderDashed
                                  ? Border.all(
                                      color: _borderColor,
                                      width: 2,
                                    )
                                  : Border.all(
                                      color: _borderColor,
                                      width: 2,
                                    ),
                              borderRadius: BorderRadius.circular(
                                  double.tryParse(
                                          _borderRadiusController.text) ??
                                      15),
                            ),
                            child: const Center(
                              child: Text('Drop Zone'),
                            ),
                          ),
                        ),

                        // Action buttons
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            if (_currentEditingIndex >= 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _resetEditingForm,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                  ),
                                  child: const Text('Hủy chỉnh sửa'),
                                ),
                              ),
                            if (_currentEditingIndex >= 0)
                              const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveEditingZone,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _currentEditingIndex >= 0
                                      ? Colors.orange
                                      : Colors.blue,
                                ),
                                child: Text(_currentEditingIndex >= 0
                                    ? 'Cập nhật'
                                    : 'Thêm mới'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Update button
              ElevatedButton(
                onPressed: _updateDropZoneConfig,
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
