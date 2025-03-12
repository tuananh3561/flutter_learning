import 'package:flutter/material.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';
import 'package:flutter_learning/presentation/screens/game_config/utils/color_utils.dart';

/// Widget chỉnh sửa thông tin chi tiết của một drop zone dưới dạng dialog
class ZoneEditorDialog extends StatefulWidget {
  final int currentEditingIndex;
  final String? positionX;
  final String? positionY;
  final String? sizeX;
  final String? sizeY;
  final Color backgroundColor;
  final Color borderColor;
  final String? borderRadius;
  final bool borderDashed;

  const ZoneEditorDialog({
    Key? key,
    required this.currentEditingIndex,
    this.positionX,
    this.positionY,
    this.sizeX,
    this.sizeY,
    required this.backgroundColor,
    required this.borderColor,
    this.borderRadius,
    required this.borderDashed,
  }) : super(key: key);

  @override
  State<ZoneEditorDialog> createState() => _ZoneEditorDialogState();

  /// Hiển thị dialog chỉnh sửa zone
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required int currentEditingIndex,
    String? positionX = '520.0',
    String? positionY = 'gameSize.y / 2 + 25.0',
    String? sizeX = '100.0',
    String? sizeY = '100.0',
    Color backgroundColor = const Color(0x50E3F2FD),
    Color borderColor = Colors.blue,
    String? borderRadius = '15.0',
    bool borderDashed = true,
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ZoneEditorDialog(
          currentEditingIndex: currentEditingIndex,
          positionX: positionX,
          positionY: positionY,
          sizeX: sizeX,
          sizeY: sizeY,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          borderDashed: borderDashed,
        );
      },
    );
  }
}

class _ZoneEditorDialogState extends State<ZoneEditorDialog> {
  late TextEditingController _positionXController;
  late TextEditingController _positionYController;
  late TextEditingController _sizeXController;
  late TextEditingController _sizeYController;
  late Color _backgroundColor;
  late Color _borderColor;
  late TextEditingController _borderRadiusController;
  late bool _borderDashed;

  @override
  void initState() {
    super.initState();
    _positionXController = TextEditingController(text: widget.positionX);
    _positionYController = TextEditingController(text: widget.positionY);
    _sizeXController = TextEditingController(text: widget.sizeX);
    _sizeYController = TextEditingController(text: widget.sizeY);
    _backgroundColor = widget.backgroundColor;
    _borderColor = widget.borderColor;
    _borderRadiusController = TextEditingController(text: widget.borderRadius);
    _borderDashed = widget.borderDashed;
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

  void _handleSave() {
    final result = {
      'position': {
        'x': _positionXController.text,
        'y': _positionYController.text,
      },
      'size': {
        'x': _sizeXController.text,
        'y': _sizeYController.text,
      },
      'style': {
        'backgroundColor': ColorUtils.toHex(_backgroundColor),
        'borderColor': ColorUtils.toHex(_borderColor),
        'borderRadius': _borderRadiusController.text,
        'borderDashed': _borderDashed,
      }
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.currentEditingIndex >= 0
                          ? 'Chỉnh sửa Zone'
                          : 'Thêm Zone mới',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Đóng',
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Position
                Text('Vị trí', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _positionXController,
                        decoration: const InputDecoration(
                          labelText: 'X',
                          border: OutlineInputBorder(),
                        ),
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Size
                Text('Kích thước',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sizeXController,
                        decoration: const InputDecoration(
                          labelText: 'Width',
                          border: OutlineInputBorder(),
                        ),
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Style
                Text('Kiểu dáng',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),

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
                TextField(
                  controller: _borderRadiusController,
                  decoration: const InputDecoration(
                    labelText: 'Bo góc viền',
                    helperText: 'Độ bo góc của drop zone',
                    border: OutlineInputBorder(),
                  ),
                ),

                // Border Dashed
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Viền đứt đoạn',
                              style: Theme.of(context).textTheme.titleSmall),
                          const Text(
                            'Sử dụng viền đứt đoạn thay vì viền liền',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                    width: double.tryParse(_sizeXController.text) ?? 100,
                    height: double.tryParse(_sizeYController.text) ?? 100,
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
                          double.tryParse(_borderRadiusController.text) ?? 15),
                    ),
                    child: const Center(
                      child: Text('Drop Zone'),
                    ),
                  ),
                ),

                // Action buttons
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.currentEditingIndex >= 0
                            ? Colors.orange
                            : Colors.blue,
                      ),
                      child: Text(widget.currentEditingIndex >= 0
                          ? 'Cập nhật'
                          : 'Thêm mới'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
