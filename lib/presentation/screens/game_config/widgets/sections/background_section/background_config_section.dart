import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';
import 'package:flutter_learning/presentation/screens/game_config/utils/color_utils.dart';

/// Widget hiển thị và chỉnh sửa cấu hình chung và hình nền
class BackgroundConfigSection extends StatefulWidget {
  final Map<String, dynamic> backgroundConfig;
  final String backgroundConfigPath;
  final Function(Map<String, dynamic>) onBackgroundConfigChanged;
  final Function(String) onBackgroundPathChanged;
  final Function() onLoadBackgroundConfig;

  const BackgroundConfigSection({
    Key? key,
    required this.backgroundConfig,
    required this.backgroundConfigPath,
    required this.onBackgroundConfigChanged,
    required this.onBackgroundPathChanged,
    required this.onLoadBackgroundConfig,
  }) : super(key: key);

  @override
  State<BackgroundConfigSection> createState() =>
      _BackgroundConfigSectionState();
}

class _BackgroundConfigSectionState extends State<BackgroundConfigSection> {
  // Background image properties
  String _backgroundWidthValue = '1024';
  String _backgroundHeightValue = '576';

  @override
  void initState() {
    super.initState();
    _updateWidthHeightFromConfig();
  }

  @override
  void didUpdateWidget(BackgroundConfigSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backgroundConfig != widget.backgroundConfig) {
      _updateWidthHeightFromConfig();
    }
  }

  void _updateWidthHeightFromConfig() {
    // Update background width/height values if they exist
    if (widget.backgroundConfig.containsKey('background_image')) {
      setState(() {
        _backgroundWidthValue =
            (widget.backgroundConfig['background_image']['width'] ?? 1024)
                .toString();
        _backgroundHeightValue =
            (widget.backgroundConfig['background_image']['height'] ?? 576)
                .toString();
      });
    }
  }

  // Giả lập upload file - thực tế sẽ cần thư viện file_picker
  Future<String?> _uploadFile(List<String>? allowedExtensions) async {
    // Trong phiên bản này, chúng ta sẽ sử dụng một dialog đơn giản để chọn từ một danh sách
    // tệp có sẵn thay vì thực sự tải lên

    String? selectedPath;

    // Hiển thị dialog chọn file mẫu
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn tệp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Danh sách tệp mẫu dựa vào loại extension được chấp nhận
              ...(_getMockFileList(allowedExtensions).map((path) => ListTile(
                    title: Text(path.split('/').last),
                    onTap: () {
                      selectedPath = path;
                      Navigator.pop(context);
                    },
                  ))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );

    return selectedPath;
  }

  // Tạo danh sách file mẫu dựa trên loại tệp được chấp nhận
  List<String> _getMockFileList(List<String>? extensions) {
    if (extensions == null) return [];

    List<String> mockFiles = [];

    // Nếu là hình ảnh
    if (extensions.contains('png') || extensions.contains('jpg')) {
      mockFiles.addAll([
        'assets/backgrounds/blue_sky.png',
        'assets/backgrounds/mountains.png',
        'assets/backgrounds/ocean.jpg',
      ]);
    }

    return mockFiles;
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
            Text('Cấu hình chung',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // Đường dẫn đến file cấu hình
            ConfigTextField(
              label: 'Đường dẫn file cấu hình Background',
              value: widget.backgroundConfigPath,
              onChanged: widget.onBackgroundPathChanged,
              helperText: 'Đường dẫn đến file JSON cấu hình background',
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onLoadBackgroundConfig,
                    child: const Text('Tải file cấu hình'),
                  ),
                ),
                const SizedBox(width: 8),
                // Nút xem trước thay đổi cấu hình
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget
                        .onBackgroundConfigChanged(widget.backgroundConfig),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Cập nhật Preview'),
                  ),
                ),
              ],
            ),

            if (widget.backgroundConfig.isNotEmpty) ...[
              const Divider(height: 32),
              Text('Thiết lập nền',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),

              // Background Color
              ColorPickerField(
                label: 'Màu background',
                color: ColorUtils.fromHex(
                    widget.backgroundConfig['background_color'] ?? '#87CEEB'),
                onColorChanged: (color) {
                  final updatedConfig =
                      Map<String, dynamic>.from(widget.backgroundConfig);
                  updatedConfig['background_color'] =
                      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
                  widget.onBackgroundConfigChanged(updatedConfig);
                },
              ),

              // Background Image
              const SizedBox(height: 16),
              Text('Hình nền', style: Theme.of(context).textTheme.titleSmall),

              // Current Background Image
              if (widget.backgroundConfig.containsKey('background_image'))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hình ảnh: ${widget.backgroundConfig['background_image']['image'] ?? 'Không có'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // Upload new background image
                          final imagePath =
                              await _uploadFile(['png', 'jpg', 'jpeg']);
                          if (imagePath != null) {
                            final updatedConfig = Map<String, dynamic>.from(
                                widget.backgroundConfig);
                            if (!updatedConfig
                                .containsKey('background_image')) {
                              updatedConfig['background_image'] = {};
                            }
                            updatedConfig['background_image']['image'] =
                                imagePath;
                            updatedConfig['background_image']['width'] =
                                int.tryParse(_backgroundWidthValue) ?? 1024;
                            updatedConfig['background_image']['height'] =
                                int.tryParse(_backgroundHeightValue) ?? 576;

                            widget.onBackgroundConfigChanged(updatedConfig);
                          }
                        },
                      ),
                    ],
                  ),
                ),

              // Upload new background image if none exists
              if (!widget.backgroundConfig.containsKey('background_image'))
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Hình Nền'),
                  onPressed: () async {
                    final imagePath = await _uploadFile(['png', 'jpg', 'jpeg']);
                    if (imagePath != null) {
                      final updatedConfig =
                          Map<String, dynamic>.from(widget.backgroundConfig);
                      updatedConfig['background_image'] = {
                        'image': imagePath,
                        'width': int.tryParse(_backgroundWidthValue) ?? 1024,
                        'height': int.tryParse(_backgroundHeightValue) ?? 576,
                      };
                      widget.onBackgroundConfigChanged(updatedConfig);
                    }
                  },
                ),

              // Background Image Settings if image exists
              if (widget.backgroundConfig.containsKey('background_image'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Width
                    ConfigTextField(
                      label: 'Chiều rộng',
                      value: _backgroundWidthValue,
                      onChanged: (value) {
                        setState(() {
                          _backgroundWidthValue = value;
                          final updatedConfig = Map<String, dynamic>.from(
                              widget.backgroundConfig);
                          updatedConfig['background_image']['width'] =
                              int.tryParse(value) ?? 1024;
                          widget.onBackgroundConfigChanged(updatedConfig);
                        });
                      },
                      helperText: 'Chiều rộng của hình nền',
                    ),

                    // Height
                    ConfigTextField(
                      label: 'Chiều cao',
                      value: _backgroundHeightValue,
                      onChanged: (value) {
                        setState(() {
                          _backgroundHeightValue = value;
                          final updatedConfig = Map<String, dynamic>.from(
                              widget.backgroundConfig);
                          updatedConfig['background_image']['height'] =
                              int.tryParse(value) ?? 576;
                          widget.onBackgroundConfigChanged(updatedConfig);
                        });
                      },
                      helperText: 'Chiều cao của hình nền',
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

/// ColorPickerField cho phép chọn màu
class ColorPickerField extends StatelessWidget {
  final String label;
  final Color color;
  final Function(Color) onColorChanged;

  const ColorPickerField({
    Key? key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          GestureDetector(
            onTap: () => ColorPickerDialog.showBlockPicker(
              context,
              color,
              (newColor) => onColorChanged(newColor),
              title: label,
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
              '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'),
        ],
      ),
    );
  }
}
