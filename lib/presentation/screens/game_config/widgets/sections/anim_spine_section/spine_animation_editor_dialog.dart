import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config_editor_panel.dart';

/// Dialog chỉnh sửa hoặc thêm mới spine animation
class SpineAnimationEditorDialog extends StatefulWidget {
  final int editingIndex;
  final String? id;
  final String? skeletonPath;
  final String? atlasPath;
  final String? selectedAnimation;
  final String? selectedSkin;
  final String? scaleX;
  final String? scaleY;
  final String? positionX;
  final String? positionY;

  const SpineAnimationEditorDialog({
    Key? key,
    required this.editingIndex,
    this.id,
    this.skeletonPath,
    this.atlasPath,
    this.selectedAnimation,
    this.selectedSkin,
    this.scaleX,
    this.scaleY,
    this.positionX,
    this.positionY,
  }) : super(key: key);

  @override
  State<SpineAnimationEditorDialog> createState() =>
      _SpineAnimationEditorDialogState();

  /// Hiển thị dialog chỉnh sửa spine animation
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required int editingIndex,
    String? id,
    String? skeletonPath,
    String? atlasPath,
    String? selectedAnimation,
    String? selectedSkin,
    String? scaleX = '0.25',
    String? scaleY = '0.25',
    String? positionX = '0',
    String? positionY = '0',
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SpineAnimationEditorDialog(
          editingIndex: editingIndex,
          id: id,
          skeletonPath: skeletonPath,
          atlasPath: atlasPath,
          selectedAnimation: selectedAnimation,
          selectedSkin: selectedSkin,
          scaleX: scaleX,
          scaleY: scaleY,
          positionX: positionX,
          positionY: positionY,
        );
      },
    );
  }
}

class _SpineAnimationEditorDialogState
    extends State<SpineAnimationEditorDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  // Form values
  late TextEditingController _idController;
  late TextEditingController _skeletonPathController;
  late TextEditingController _atlasPathController;
  late TextEditingController _scaleXController;
  late TextEditingController _scaleYController;
  late TextEditingController _positionXController;
  late TextEditingController _positionYController;

  String _selectedAnimationValue = '';
  String _selectedSkinValue = '';

  // Available animations and skins from skeleton file
  List<String> _availableAnimations = [];
  List<String> _availableSkins = [];

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.id ?? '');
    _skeletonPathController =
        TextEditingController(text: widget.skeletonPath ?? '');
    _atlasPathController = TextEditingController(text: widget.atlasPath ?? '');
    _scaleXController = TextEditingController(text: widget.scaleX ?? '0.25');
    _scaleYController = TextEditingController(text: widget.scaleY ?? '0.25');
    _positionXController = TextEditingController(text: widget.positionX ?? '0');
    _positionYController = TextEditingController(text: widget.positionY ?? '0');

    _selectedAnimationValue = widget.selectedAnimation ?? '';
    _selectedSkinValue = widget.selectedSkin ?? '';

    // Nếu đã có skeleton path, phân tích animations và skins
    if (widget.skeletonPath != null && widget.skeletonPath!.isNotEmpty) {
      _extractAnimationsAndSkins(widget.skeletonPath!);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _skeletonPathController.dispose();
    _atlasPathController.dispose();
    _scaleXController.dispose();
    _scaleYController.dispose();
    _positionXController.dispose();
    _positionYController.dispose();
    super.dispose();
  }

  // Giả lập upload file - thực tế sẽ cần thư viện file_picker
  Future<String?> _uploadFile(List<String>? allowedExtensions,
      {bool isDirectory = false}) async {
    String? selectedPath;

    // Hiển thị dialog chọn file mẫu
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isDirectory ? 'Chọn thư mục Spine' : 'Chọn tệp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Danh sách tệp mẫu dựa vào loại extension được chấp nhận
              ...(_getMockFileList(allowedExtensions, isDirectory)
                  .map((path) => ListTile(
                        title: Text(path.split('/').last),
                        subtitle: Text(isDirectory ? 'Thư mục' : 'Tệp'),
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

    // Nếu đã chọn thư mục spine, tự động phân tích file skeleton
    if (isDirectory && selectedPath != null) {
      await _analyzeSpineDirectory(selectedPath!);
    }

    return selectedPath;
  }

  // Tạo danh sách file mẫu dựa trên loại tệp được chấp nhận
  List<String> _getMockFileList(List<String>? extensions, bool isDirectory) {
    if (isDirectory) {
      // Danh sách thư mục spine mẫu
      return [
        'assets/Feed the Shark/rong bien 1',
        'assets/Feed the Shark/rong bien 2',
        'assets/Feed the Shark/bong bong',
        'assets/Spine/character1',
        'assets/Spine/character2',
      ];
    }

    if (extensions == null) return [];

    List<String> mockFiles = [];

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

  // Phân tích thư mục spine để lấy thông tin animations và skins
  Future<void> _analyzeSpineDirectory(String directoryPath) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trong một ứng dụng thực tế, bạn sẽ tìm file skeleton.json và atlas trong thư mục
      // Ở đây, chúng ta giả định rằng chúng có tên cố định
      final String skeletonPath = '$directoryPath/skeleton.json';
      final String atlasPath = '$directoryPath/skeleton_hdr.atlas.txt';

      // Lưu lại đường dẫn
      _skeletonPathController.text = skeletonPath;
      _atlasPathController.text = atlasPath;

      // Phân tích file skeleton để lấy animations và skins
      await _extractAnimationsAndSkins(skeletonPath);
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể phân tích thư mục Spine: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Phân tích file skeleton.json để lấy danh sách animations và skins
  Future<void> _extractAnimationsAndSkins(String skeletonPath) async {
    try {
      // Đọc file skeleton
      final String skeletonContent = await rootBundle.loadString(skeletonPath);
      final Map<String, dynamic> skeletonData = json.decode(skeletonContent);

      // Lấy danh sách animations
      final List<String> animations = [];
      if (skeletonData.containsKey('animations')) {
        animations.addAll(skeletonData['animations'].keys.cast<String>());
      }

      // Lấy danh sách skins
      final List<String> skins = [];
      if (skeletonData.containsKey('skins')) {
        if (skeletonData['skins'] is List) {
          // Spine 4.0+ format
          for (var skin in skeletonData['skins']) {
            if (skin is Map && skin.containsKey('name')) {
              skins.add(skin['name']);
            }
          }
        } else if (skeletonData['skins'] is Map) {
          // Spine 3.8 format
          skins.addAll(skeletonData['skins'].keys.cast<String>());
        }
      }

      setState(() {
        _availableAnimations = animations;
        _availableSkins = skins;

        // Set default values if available
        if (_availableAnimations.isNotEmpty &&
            _selectedAnimationValue.isEmpty) {
          _selectedAnimationValue = _availableAnimations.first;
        }

        if (_availableSkins.isNotEmpty && _selectedSkinValue.isEmpty) {
          _selectedSkinValue = _availableSkins.first;
        }
      });

      print('Detected animations: $_availableAnimations');
      print('Detected skins: $_availableSkins');
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể phân tích file skeleton: $e';
      });
    }
  }

  // Xử lý khi nhấn nút lưu
  void _handleSave() {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID không được để trống')),
      );
      return;
    }

    if (_skeletonPathController.text.isEmpty ||
        _atlasPathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đường dẫn skeleton và atlas không được để trống')),
      );
      return;
    }

    if (_selectedAnimationValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn animation')),
      );
      return;
    }

    // Tạo kết quả spine item
    final Map<String, dynamic> result = {
      'id': _idController.text,
      'skeleton': _skeletonPathController.text,
      'atlas': _atlasPathController.text,
      'animation': _selectedAnimationValue,
      'scale': {
        'x': double.tryParse(_scaleXController.text) ?? 0.25,
        'y': double.tryParse(_scaleYController.text) ?? 0.25
      },
      'position': {
        'x': double.tryParse(_positionXController.text) ?? 0,
        'y': double.tryParse(_positionYController.text) ?? 0
      },
    };

    // Thêm skin nếu đã chọn
    if (_selectedSkinValue.isNotEmpty) {
      result['skins'] = _selectedSkinValue;
    }

    // Trả kết quả về và đóng dialog
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 700),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.editingIndex >= 0
                  ? 'Chỉnh sửa Spine Animation'
                  : 'Thêm Spine Animation mới',
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Đóng',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // ID
                      ConfigTextField(
                        label: 'ID',
                        value: _idController.text,
                        onChanged: (value) {
                          _idController.text = value;
                        },
                        helperText: 'Định danh duy nhất cho spine animation',
                      ),

                      const SizedBox(height: 16),
                      // Upload từ thư mục spine
                      ElevatedButton.icon(
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Chọn thư mục Spine'),
                        onPressed: () async {
                          await _uploadFile(null, isDirectory: true);
                        },
                      ),

                      // Hoặc chọn file riêng biệt
                      const SizedBox(height: 8),
                      Text('Hoặc chọn từng file riêng biệt:',
                          style: Theme.of(context).textTheme.bodyLarge),

                      // Skeleton file
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'File skeleton',
                              value: _skeletonPathController.text,
                              onChanged: (value) {
                                _skeletonPathController.text = value;
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
                                  _skeletonPathController.text = skeletonPath;

                                  // Tự động phân tích file skeleton để lấy animations và skins
                                  _extractAnimationsAndSkins(skeletonPath);
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
                              value: _atlasPathController.text,
                              onChanged: (value) {
                                _atlasPathController.text = value;
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
                                  _atlasPathController.text = atlasPath;
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Animation selection
                      if (_availableAnimations.isNotEmpty)
                        ConfigDropdown<String>(
                          label: 'Animation',
                          value: _selectedAnimationValue.isEmpty
                              ? _availableAnimations.first
                              : _selectedAnimationValue,
                          items: _availableAnimations,
                          onChanged: (value) {
                            setState(() {
                              _selectedAnimationValue = value;
                            });
                          },
                          helperText: 'Chọn animation để hiển thị',
                        )
                      else
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Chưa phát hiện animations. Vui lòng chọn file skeleton.',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),

                      // Skin selection
                      if (_availableSkins.isNotEmpty)
                        ConfigDropdown<String>(
                          label: 'Skin',
                          value: _selectedSkinValue.isEmpty
                              ? _availableSkins.first
                              : _selectedSkinValue,
                          items: _availableSkins,
                          onChanged: (value) {
                            setState(() {
                              _selectedSkinValue = value;
                            });
                          },
                          helperText: 'Chọn skin cho spine animation',
                        ),

                      const SizedBox(height: 16),
                      Text('Vị trí và kích thước:',
                          style: Theme.of(context).textTheme.titleSmall),

                      // Scale
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Scale X',
                              value: _scaleXController.text,
                              onChanged: (value) {
                                _scaleXController.text = value;
                              },
                              helperText: 'Tỷ lệ theo chiều ngang',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ConfigTextField(
                              label: 'Scale Y',
                              value: _scaleYController.text,
                              onChanged: (value) {
                                _scaleYController.text = value;
                              },
                              helperText: 'Tỷ lệ theo chiều dọc',
                            ),
                          ),
                        ],
                      ),

                      // Position
                      Row(
                        children: [
                          Expanded(
                            child: ConfigTextField(
                              label: 'Position X',
                              value: _positionXController.text,
                              onChanged: (value) {
                                _positionXController.text = value;
                              },
                              helperText: 'Vị trí theo chiều ngang',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ConfigTextField(
                              label: 'Position Y',
                              value: _positionYController.text,
                              onChanged: (value) {
                                _positionYController.text = value;
                              },
                              helperText: 'Vị trí theo chiều dọc',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                    backgroundColor:
                        widget.editingIndex >= 0 ? Colors.orange : Colors.blue,
                  ),
                  child:
                      Text(widget.editingIndex >= 0 ? 'Cập nhật' : 'Thêm mới'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
