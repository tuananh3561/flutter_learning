import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_learning/presentation/screens/game_config/utils/color_utils.dart';
import 'drop_zone_section/zones_list_widget.dart';
import 'drop_zone_section/zone_editor_dialog.dart';

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
  int _currentZoneId = 1;

  @override
  void initState() {
    super.initState();
    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build xong
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadDropZoneConfig();
    });
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
  Future<void> _startEditingZone(int index) async {
    if (index < 0 || index >= _zones.length) return;

    final zone = _zones[index];

    String? positionX;
    String? positionY;
    String? sizeX;
    String? sizeY;
    Color backgroundColor = Color(0x50E3F2FD);
    Color borderColor = Colors.blue;
    String? borderRadius;
    bool borderDashed = true;

    // Position
    if (zone.containsKey('position')) {
      positionX = zone['position']['x'].toString();
      positionY = zone['position']['y'].toString();
    }

    // Size
    if (zone.containsKey('size')) {
      sizeX = zone['size']['x'].toString();
      sizeY = zone['size']['y'].toString();
    }

    // Style
    if (zone.containsKey('style')) {
      final style = zone['style'];

      // Background color
      if (style.containsKey('backgroundColor')) {
        final colorStr = style['backgroundColor'] as String;
        if (colorStr.startsWith('#')) {
          backgroundColor = ColorUtils.fromHex(colorStr);
        }
      }

      // Border color
      if (style.containsKey('borderColor')) {
        final colorStr = style['borderColor'] as String;
        if (colorStr.startsWith('#')) {
          borderColor = ColorUtils.fromHex(colorStr);
        }
      }

      // Border radius
      if (style.containsKey('borderRadius')) {
        borderRadius = style['borderRadius'].toString();
      }

      // Border dashed
      if (style.containsKey('borderDashed')) {
        borderDashed = style['borderDashed'];
      }
    }

    // Hiển thị dialog chỉnh sửa
    final result = await ZoneEditorDialog.show(
      context,
      currentEditingIndex: index,
      positionX: positionX,
      positionY: positionY,
      sizeX: sizeX,
      sizeY: sizeY,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderDashed: borderDashed,
    );

    // Xử lý kết quả khi dialog đóng
    if (result != null) {
      final updatedZone = {
        'id': zone['id'],
        'position': {
          'x': _parsePositionValue(result['position']['x']),
          'y': _parsePositionValue(result['position']['y'], isYPosition: true),
        },
        'size': {
          'x': _parsePositionValue(result['size']['x']),
          'y': _parsePositionValue(result['size']['y']),
        },
        'style': result['style'],
      };

      setState(() {
        _zones[index] = updatedZone;
        _updateDropZoneConfig();
      });
    }
  }

  // Xử lý giá trị vị trí từ chuỗi về kiểu phù hợp (number hoặc giữ nguyên chuỗi nếu chứa biểu thức)
  dynamic _parsePositionValue(String value, {bool isYPosition = false}) {
    // Nếu chứa 'gameSize' hoặc biểu thức, giữ nguyên chuỗi
    if (isYPosition && value.contains('gameSize')) {
      return value;
    }

    // Chuyển đổi sang số nếu có thể
    if (value.contains('.')) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return int.tryParse(value) ?? 0;
    }
  }

  // Thêm zone mới
  Future<void> _addNewZone() async {
    // Hiển thị dialog thêm mới
    final result = await ZoneEditorDialog.show(
      context,
      currentEditingIndex: -1,
    );

    // Xử lý kết quả khi dialog đóng
    if (result != null) {
      final newZone = {
        'id': _currentZoneId,
        'position': {
          'x': _parsePositionValue(result['position']['x']),
          'y': _parsePositionValue(result['position']['y'], isYPosition: true),
        },
        'size': {
          'x': _parsePositionValue(result['size']['x']),
          'y': _parsePositionValue(result['size']['y']),
        },
        'style': result['style'],
      };

      setState(() {
        _zones.add(newZone);
        _currentZoneId++; // Tăng ID cho zone tiếp theo
        _updateDropZoneConfig();
      });
    }
  }

  // Xóa một zone
  void _deleteZone(int index) {
    if (index < 0 || index >= _zones.length) return;

    setState(() {
      _zones.removeAt(index);
      _updateDropZoneConfig();
    });
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
                ZonesListWidget(
                  zones: _zones,
                  currentEditingIndex: -1, // Không còn chế độ chỉnh sửa cố định
                  onEditZone: _startEditingZone,
                  onDeleteZone: _deleteZone,
                  onAddNew: _addNewZone,
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
