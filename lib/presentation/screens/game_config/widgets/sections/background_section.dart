import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';

/// Widget để cấu hình hình nền
class BackgroundSection extends StatefulWidget {
  final Map<String, dynamic> backgroundConfig;
  final String backgroundConfigPath;
  final Function(Map<String, dynamic>) onBackgroundConfigChanged;
  final Function(String) onBackgroundPathChanged;

  const BackgroundSection({
    Key? key,
    required this.backgroundConfig,
    required this.backgroundConfigPath,
    required this.onBackgroundConfigChanged,
    required this.onBackgroundPathChanged,
  }) : super(key: key);

  @override
  State<BackgroundSection> createState() => _BackgroundSectionState();
}

class _BackgroundSectionState extends State<BackgroundSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _loadedBackgroundConfig = {};
  List<String> _availableBackgrounds = [];
  String? _selectedBackground;

  // Decoration type for new items
  String _newDecorationType = 'image';

  // Values for new decoration item
  String _idValue = '';
  String _imagePathValue = '';
  String _skeletonPathValue = '';
  String _atlasPathValue = '';
  String _animationNameValue = '';

  // Background image properties
  String _backgroundWidthValue = '1024';
  String _backgroundHeightValue = '576';

  @override
  void initState() {
    super.initState();
    _loadedBackgroundConfig =
        Map<String, dynamic>.from(widget.backgroundConfig);
    _loadBackgroundConfig();
    _loadAvailableBackgrounds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadBackgroundConfig() async {
    if (widget.backgroundConfigPath.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String jsonString =
          await rootBundle.loadString(widget.backgroundConfigPath);
      setState(() {
        _loadedBackgroundConfig = json.decode(jsonString);

        // Update background width/height values if they exist
        if (_loadedBackgroundConfig.containsKey('background_image')) {
          _backgroundWidthValue =
              (_loadedBackgroundConfig['background_image']['width'] ?? 1024)
                  .toString();
          _backgroundHeightValue =
              (_loadedBackgroundConfig['background_image']['height'] ?? 576)
                  .toString();
        }

        _isLoading = false;

        // Thông báo thay đổi cấu hình để cập nhật Preview
        _updateBackgroundConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải file cấu hình background: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAvailableBackgrounds() async {
    try {
      // Ở đây, bạn có thể tải danh sách các background có sẵn
      // Ví dụ: từ thư mục assets/backgrounds
      setState(() {
        _availableBackgrounds = [
          'assets/backgrounds/blue_sky.png',
          'assets/backgrounds/night_sky.png',
          'assets/backgrounds/mountains.png',
          'assets/backgrounds/ocean.png',
          'assets/backgrounds/forest.png',
          // Thêm các tùy chọn khác
        ];

        // Mặc định chọn background đầu tiên nếu chưa có selection
        if (_selectedBackground == null && _availableBackgrounds.isNotEmpty) {
          _selectedBackground = _availableBackgrounds.first;
        }
      });
    } catch (e) {
      print('Lỗi khi tải danh sách backgrounds: $e');
    }
  }

  void _updateBackgroundConfig() {
    // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
    widget.onBackgroundConfigChanged(_loadedBackgroundConfig);

    // In ra log để debug
    print('Background config updated: ${json.encode(_loadedBackgroundConfig)}');
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

    // Nếu là json (skeleton)
    if (extensions.contains('json')) {
      mockFiles.addAll([
        'assets/Feed the Shark/rong bien 1/skeleton.json',
        'assets/Feed the Shark/rong bien 2/skeleton.json',
        'assets/Feed the Shark/bong bong/skeleton.json',
      ]);
    }

    // Nếu là atlas
    if (extensions.contains('txt') || extensions.contains('atlas')) {
      mockFiles.addAll([
        'assets/Feed the Shark/rong bien 1/skeleton_hdr.atlas.txt',
        'assets/Feed the Shark/rong bien 2/skeleton_hdr.atlas.txt',
        'assets/Feed the Shark/bong bong/skeleton_hdr.atlas.txt',
      ]);
    }

    return mockFiles;
  }

  // Add new decoration item
  void _addDecorationItem() {
    if (_idValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID không được để trống')),
      );
      return;
    }

    // Get existing decoration list or create new one
    List<dynamic> decorationList = _loadedBackgroundConfig['decoration'] ?? [];

    // Create new decoration item based on type
    Map<String, dynamic> newItem = {
      'id': _idValue,
    };

    switch (_newDecorationType) {
      case 'image':
        if (_imagePathValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Đường dẫn hình ảnh không được để trống')),
          );
          return;
        }
        newItem['type'] = 'image';
        newItem['image'] = _imagePathValue;
        newItem['scale'] = 1.0;
        newItem['position'] = {'x': 0, 'y': 0};
        break;

      case 'animation':
        if (_imagePathValue.isEmpty || _animationNameValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Đường dẫn hình ảnh và tên animation không được để trống')),
          );
          return;
        }
        newItem['type'] = 'animation';
        newItem['image'] = _imagePathValue;
        newItem['animation'] = _animationNameValue;
        newItem['scale'] = 1.0;
        newItem['position'] = {'x': 0, 'y': 0};
        newItem['looping'] = true;
        newItem['auto_start'] = true;
        break;

      case 'spine':
        if (_skeletonPathValue.isEmpty || _atlasPathValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Đường dẫn skeleton và atlas không được để trống')),
          );
          return;
        }
        newItem['type'] = 'spine';
        newItem['skeleton'] = _skeletonPathValue;
        newItem['atlas'] = _atlasPathValue;
        newItem['scale'] = 0.25;
        newItem['position'] = {'x': 100, 'y': 100};
        newItem['animation'] =
            _animationNameValue.isEmpty ? 'Idie' : _animationNameValue;
        newItem['click_animation'] = null;
        break;
    }

    // Add to decoration list
    decorationList.add(newItem);

    // Update config
    setState(() {
      _loadedBackgroundConfig['decoration'] = decorationList;

      // Clear values
      _idValue = '';
      _imagePathValue = '';
      _skeletonPathValue = '';
      _atlasPathValue = '';
      _animationNameValue = '';

      // Sau khi cập nhật, gọi _updateBackgroundConfig để cập nhật Preview
      _updateBackgroundConfig();
    });
  }

  // Remove decoration item
  void _removeDecorationItem(int index) {
    List<dynamic> decorationList = _loadedBackgroundConfig['decoration'] ?? [];
    if (index >= 0 && index < decorationList.length) {
      setState(() {
        decorationList.removeAt(index);
        _loadedBackgroundConfig['decoration'] = decorationList;

        // Sau khi xóa, gọi _updateBackgroundConfig để cập nhật Preview
        _updateBackgroundConfig();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Hình Nền',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Đường dẫn đến file cấu hình
        ConfigTextField(
          label: 'Đường dẫn file cấu hình Background',
          value: widget.backgroundConfigPath,
          onChanged: (value) {
            widget.onBackgroundPathChanged(value);
          },
          helperText: 'Đường dẫn đến file JSON cấu hình background',
        ),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loadBackgroundConfig,
          child: const Text('Tải file cấu hình'),
        ),

        const SizedBox(height: 8),
        // Nút xem trước thay đổi cấu hình
        ElevatedButton(
          onPressed: _updateBackgroundConfig,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Cập nhật Preview'),
        ),

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
        else if (_loadedBackgroundConfig.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 32),
              Text('Cài Đặt Background',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),

              // Background Color
              ColorPickerField(
                label: 'Màu background',
                color: _getColorFromConfig(
                    _loadedBackgroundConfig['background_color'] ?? '#87CEEB'),
                onColorChanged: (color) {
                  setState(() {
                    _loadedBackgroundConfig['background_color'] =
                        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
                    _updateBackgroundConfig();
                  });
                },
              ),

              // Background Image
              const SizedBox(height: 16),
              Text('Hình nền', style: Theme.of(context).textTheme.titleSmall),

              // Current Background Image
              if (_loadedBackgroundConfig.containsKey('background_image'))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hình ảnh: ${_loadedBackgroundConfig['background_image']['image'] ?? 'Không có'}',
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
                            setState(() {
                              if (!_loadedBackgroundConfig
                                  .containsKey('background_image')) {
                                _loadedBackgroundConfig['background_image'] =
                                    {};
                              }
                              _loadedBackgroundConfig['background_image']
                                  ['image'] = imagePath;
                              _loadedBackgroundConfig['background_image']
                                      ['width'] =
                                  int.tryParse(_backgroundWidthValue) ?? 1024;
                              _loadedBackgroundConfig['background_image']
                                      ['height'] =
                                  int.tryParse(_backgroundHeightValue) ?? 576;
                              _updateBackgroundConfig();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

              // Upload new background image if none exists
              if (!_loadedBackgroundConfig.containsKey('background_image'))
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Hình Nền'),
                  onPressed: () async {
                    final imagePath = await _uploadFile(['png', 'jpg', 'jpeg']);
                    if (imagePath != null) {
                      setState(() {
                        _loadedBackgroundConfig['background_image'] = {
                          'image': imagePath,
                          'width': int.tryParse(_backgroundWidthValue) ?? 1024,
                          'height': int.tryParse(_backgroundHeightValue) ?? 576,
                        };
                        _updateBackgroundConfig();
                      });
                    }
                  },
                ),

              // Background Image Settings if image exists
              if (_loadedBackgroundConfig.containsKey('background_image'))
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
                          _loadedBackgroundConfig['background_image']['width'] =
                              int.tryParse(value) ?? 1024;
                          _updateBackgroundConfig();
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
                          _loadedBackgroundConfig['background_image']
                              ['height'] = int.tryParse(value) ?? 576;
                          _updateBackgroundConfig();
                        });
                      },
                      helperText: 'Chiều cao của hình nền',
                    ),
                  ],
                ),

              // Decoration section
              const Divider(height: 32),
              Text('Trang Trí (Decoration)',
                  style: Theme.of(context).textTheme.titleMedium),

              // Display current decoration items
              if (_loadedBackgroundConfig.containsKey('decoration') &&
                  (_loadedBackgroundConfig['decoration'] as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Danh sách các phần tử:',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),

                      // List of decoration items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (_loadedBackgroundConfig['decoration'] as List)
                                .length,
                        itemBuilder: (context, index) {
                          final item = (_loadedBackgroundConfig['decoration']
                              as List)[index];
                          return DecorationItemTile(
                            item: item,
                            onDelete: () => _removeDecorationItem(index),
                            onEdit: () {
                              // Thêm chức năng chỉnh sửa sau khi hoàn thiện
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Chức năng chỉnh sửa đang được phát triển')),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

              // Add new decoration item
              const SizedBox(height: 16),
              Text('Thêm phần tử mới:',
                  style: Theme.of(context).textTheme.bodyLarge),

              // Type selector
              ConfigDropdown<String>(
                label: 'Loại phần tử',
                value: _newDecorationType,
                items: const ['image', 'animation', 'spine'],
                onChanged: (value) {
                  setState(() {
                    _newDecorationType = value;
                  });
                },
                helperText: 'Loại phần tử trang trí',
              ),

              // ID for all types
              ConfigTextField(
                label: 'ID',
                value: _idValue,
                onChanged: (value) {
                  setState(() {
                    _idValue = value;
                  });
                },
                helperText: 'Định danh duy nhất cho phần tử',
              ),

              // Fields based on type
              if (_newDecorationType == 'image' ||
                  _newDecorationType == 'animation')
                Row(
                  children: [
                    Expanded(
                      child: ConfigTextField(
                        label: 'Đường dẫn hình ảnh',
                        value: _imagePathValue,
                        onChanged: (value) {
                          setState(() {
                            _imagePathValue = value;
                          });
                        },
                        helperText: 'Đường dẫn đến file hình ảnh',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () async {
                        final imagePath =
                            await _uploadFile(['png', 'jpg', 'jpeg']);
                        if (imagePath != null) {
                          setState(() {
                            _imagePathValue = imagePath;
                          });
                        }
                      },
                    ),
                  ],
                ),

              // Animation name for animation type
              if (_newDecorationType == 'animation')
                ConfigTextField(
                  label: 'Tên animation',
                  value: _animationNameValue,
                  onChanged: (value) {
                    setState(() {
                      _animationNameValue = value;
                    });
                  },
                  helperText: 'Tên của animation sẽ được chạy',
                ),

              // Spine specific fields
              if (_newDecorationType == 'spine')
                Column(
                  children: [
                    // Skeleton file
                    Row(
                      children: [
                        Expanded(
                          child: ConfigTextField(
                            label: 'File skeleton',
                            value: _skeletonPathValue,
                            onChanged: (value) {
                              setState(() {
                                _skeletonPathValue = value;
                              });
                            },
                            helperText: 'Đường dẫn đến file skeleton.json',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.upload_file),
                          onPressed: () async {
                            final skeletonPath = await _uploadFile(['json']);
                            if (skeletonPath != null) {
                              setState(() {
                                _skeletonPathValue = skeletonPath;
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    // Atlas file
                    Row(
                      children: [
                        Expanded(
                          child: ConfigTextField(
                            label: 'File atlas',
                            value: _atlasPathValue,
                            onChanged: (value) {
                              setState(() {
                                _atlasPathValue = value;
                              });
                            },
                            helperText: 'Đường dẫn đến file atlas',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.upload_file),
                          onPressed: () async {
                            final atlasPath =
                                await _uploadFile(['txt', 'atlas']);
                            if (atlasPath != null) {
                              setState(() {
                                _atlasPathValue = atlasPath;
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    // Animation name
                    ConfigTextField(
                      label: 'Tên animation',
                      value: _animationNameValue,
                      onChanged: (value) {
                        setState(() {
                          _animationNameValue = value;
                        });
                      },
                      helperText:
                          'Tên animation mặc định (để trống sẽ dùng "Idie")',
                    ),
                  ],
                ),

              // Add button
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addDecorationItem,
                child: const Text('Thêm phần tử'),
              ),
            ],
          ),
      ],
    );
  }

  Color _getColorFromConfig(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.white;
    }
  }
}

/// Widget hiển thị một phần tử trang trí
class DecorationItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const DecorationItemTile({
    Key? key,
    required this.item,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = item['type'] ?? 'unknown';
    final String id = item['id'] ?? 'Không có ID';

    IconData typeIcon;
    String typeDescription;
    String details = '';

    // Set icon and description based on type
    switch (type) {
      case 'image':
        typeIcon = Icons.image;
        typeDescription = 'Hình ảnh';
        details = 'Path: ${item['image'] ?? 'N/A'}';
        break;
      case 'animation':
        typeIcon = Icons.animation;
        typeDescription = 'Animation';
        details = 'Animation: ${item['animation'] ?? 'N/A'}';
        break;
      case 'spine':
        typeIcon = Icons.sports_gymnastics;
        typeDescription = 'Spine';
        details = 'Animation: ${item['animation'] ?? 'N/A'}';
        break;
      default:
        typeIcon = Icons.question_mark;
        typeDescription = 'Không xác định';
    }

    // Build position string if available
    String position = '';
    if (item.containsKey('position')) {
      final x = item['position']['x'] ?? 0;
      final y = item['position']['y'] ?? 0;
      position = 'Position: ($x, $y)';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(typeIcon, size: 36),
        title: Text('$id ($typeDescription)'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details),
            if (position.isNotEmpty) Text(position),
            if (item.containsKey('scale')) Text('Scale: ${item['scale']}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
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
            onTap: () => ColorPickerDialog.show(
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
