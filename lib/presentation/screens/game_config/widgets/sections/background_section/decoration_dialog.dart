import 'package:flutter/material.dart';
import '../../config_editor_panel.dart';

/// Dialog để thêm mới hoặc chỉnh sửa phần tử trang trí (Decoration)
class DecorationDialog extends StatefulWidget {
  final Map<String, dynamic>? decorationItem;
  final Function(Map<String, dynamic>) onSave;

  const DecorationDialog({
    Key? key,
    this.decorationItem,
    required this.onSave,
  }) : super(key: key);

  @override
  State<DecorationDialog> createState() => _DecorationDialogState();
}

class _DecorationDialogState extends State<DecorationDialog> {
  // Decoration type for new items
  String _decorationType = 'image';

  // Values for decoration item
  String _idValue = '';
  String _imagePathValue = '';
  String _skeletonPathValue = '';
  String _atlasPathValue = '';
  String _animationNameValue = '';
  double _scaleValue = 1.0;
  double _positionX = 0.0;
  double _positionY = 0.0;
  bool _looping = true;
  bool _autoStart = true;

  @override
  void initState() {
    super.initState();

    // Nếu là chỉnh sửa, load dữ liệu cũ
    if (widget.decorationItem != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final item = widget.decorationItem!;

    _decorationType = item['type'] ?? 'image';
    _idValue = item['id'] ?? '';

    // Các thuộc tính chung
    if (item.containsKey('scale')) {
      _scaleValue = double.tryParse(item['scale'].toString()) ?? 1.0;
    }

    if (item.containsKey('position')) {
      _positionX = double.tryParse(item['position']['x'].toString()) ?? 0.0;
      _positionY = double.tryParse(item['position']['y'].toString()) ?? 0.0;
    }

    // Các thuộc tính riêng theo loại
    switch (_decorationType) {
      case 'image':
        _imagePathValue = item['image'] ?? '';
        break;

      case 'animation':
        _imagePathValue = item['image'] ?? '';
        _animationNameValue = item['animation'] ?? '';
        _looping = item['looping'] ?? true;
        _autoStart = item['auto_start'] ?? true;
        break;

      case 'spine':
        _skeletonPathValue = item['skeleton'] ?? '';
        _atlasPathValue = item['atlas'] ?? '';
        _animationNameValue = item['animation'] ?? 'Idie';
        break;
    }
  }

  // Giả lập upload file - thực tế sẽ cần thư viện file_picker
  Future<String?> _uploadFile(List<String>? allowedExtensions) async {
    // Dialog đơn giản để chọn file
    String? selectedPath;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn tệp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Danh sách file mẫu
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

  void _saveDecorationItem() {
    if (_idValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID không được để trống')),
      );
      return;
    }

    // Create decoration item based on type
    Map<String, dynamic> newItem = {
      'id': _idValue,
      'type': _decorationType,
      'scale': _scaleValue,
      'position': {'x': _positionX, 'y': _positionY},
    };

    switch (_decorationType) {
      case 'image':
        if (_imagePathValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Đường dẫn hình ảnh không được để trống')),
          );
          return;
        }
        newItem['image'] = _imagePathValue;
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
        newItem['image'] = _imagePathValue;
        newItem['animation'] = _animationNameValue;
        newItem['looping'] = _looping;
        newItem['auto_start'] = _autoStart;
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
        newItem['skeleton'] = _skeletonPathValue;
        newItem['atlas'] = _atlasPathValue;
        newItem['animation'] =
            _animationNameValue.isEmpty ? 'Idie' : _animationNameValue;
        newItem['click_animation'] = null;
        break;
    }

    // Call the save callback and close the dialog
    widget.onSave(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.decorationItem != null;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog title
              Text(
                isEditing
                    ? 'Chỉnh sửa phần tử trang trí'
                    : 'Thêm phần tử trang trí mới',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Type selector (disabled when editing)
              ConfigDropdown<String>(
                label: 'Loại phần tử',
                value: _decorationType,
                items: const ['image', 'animation', 'spine'],
                onChanged: isEditing
                    ? (_) {} // Dummy function khi editing, sẽ bị disable
                    : (value) {
                        setState(() {
                          _decorationType = value;
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

              // Scale for all types
              ConfigNumberField(
                label: 'Tỉ lệ (Scale)',
                value: _scaleValue,
                onChanged: (value) {
                  setState(() {
                    _scaleValue = value as double;
                  });
                },
                helperText: 'Tỉ lệ kích thước phần tử',
              ),

              // Position for all types
              Text('Vị trí', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ConfigNumberField(
                      label: 'X',
                      value: _positionX,
                      onChanged: (value) {
                        setState(() {
                          _positionX = value as double;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ConfigNumberField(
                      label: 'Y',
                      value: _positionY,
                      onChanged: (value) {
                        setState(() {
                          _positionY = value as double;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fields based on type
              if (_decorationType == 'image' || _decorationType == 'animation')
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

              // Animation specific fields
              if (_decorationType == 'animation') ...[
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

                // Animation options
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Lặp animation'),
                        value: _looping,
                        onChanged: (value) {
                          setState(() {
                            _looping = value ?? true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Tự động chạy'),
                        value: _autoStart,
                        onChanged: (value) {
                          setState(() {
                            _autoStart = value ?? true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],

              // Spine specific fields
              if (_decorationType == 'spine') ...[
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
                        final atlasPath = await _uploadFile(['txt', 'atlas']);
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

              // Action buttons
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveDecorationItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEditing ? Colors.orange : Colors.blue,
                    ),
                    child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
