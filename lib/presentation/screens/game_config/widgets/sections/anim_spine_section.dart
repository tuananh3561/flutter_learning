import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config_editor_panel.dart';

/// Widget để cấu hình spine animations
class AnimSpineSection extends StatefulWidget {
  final Map<String, dynamic> animSpineConfig;
  final String animSpineConfigPath;
  final Function(Map<String, dynamic>) onAnimSpineConfigChanged;
  final Function(String) onAnimSpinePathChanged;

  const AnimSpineSection({
    Key? key,
    required this.animSpineConfig,
    required this.animSpineConfigPath,
    required this.onAnimSpineConfigChanged,
    required this.onAnimSpinePathChanged,
  }) : super(key: key);

  @override
  State<AnimSpineSection> createState() => _AnimSpineSectionState();
}

class _AnimSpineSectionState extends State<AnimSpineSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _loadedAnimSpineConfig = {};

  // Values for new spine animation
  String _idValue = '';
  String _skeletonPathValue = '';
  String _atlasPathValue = '';
  String _selectedAnimationValue = '';
  String _selectedSkinValue = '';

  // Scale values
  String _scaleXValue = '0.25';
  String _scaleYValue = '0.25';

  // Position values
  String _positionXValue = '0';
  String _positionYValue = '0';

  // Available animations and skins detected from skeleton file
  List<String> _availableAnimations = [];
  List<String> _availableSkins = [];

  // Current selected spine config for editing
  Map<String, dynamic>? _currentEditingSpine;
  int _currentEditingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadedAnimSpineConfig = Map<String, dynamic>.from(widget.animSpineConfig);
    _loadAnimSpineConfig();
  }

  Future<void> _loadAnimSpineConfig() async {
    if (widget.animSpineConfigPath.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String jsonString =
          await rootBundle.loadString(widget.animSpineConfigPath);
      setState(() {
        _loadedAnimSpineConfig = json.decode(jsonString);
        _isLoading = false;

        // Thông báo thay đổi cấu hình để cập nhật Preview
        _updateAnimSpineConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải file cấu hình Spine Animation: $e';
        _isLoading = false;
      });
    }
  }

  void _updateAnimSpineConfig() {
    // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
    widget.onAnimSpineConfigChanged(_loadedAnimSpineConfig);

    // In ra log để debug
    print(
        'Spine Animation config updated: ${json.encode(_loadedAnimSpineConfig)}');
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
      _skeletonPathValue = skeletonPath;
      _atlasPathValue = atlasPath;

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
        if (_availableAnimations.isNotEmpty) {
          _selectedAnimationValue = _availableAnimations.first;
        }

        if (_availableSkins.isNotEmpty) {
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

  // Thêm spine animation mới
  void _addSpineAnimation() {
    if (_idValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID không được để trống')),
      );
      return;
    }

    if (_skeletonPathValue.isEmpty || _atlasPathValue.isEmpty) {
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

    // Get existing spine_animations list or create new one
    List<dynamic> spineList = _loadedAnimSpineConfig['spine_animations'] ?? [];

    // Create new spine item
    Map<String, dynamic> newItem = {
      'id': _idValue,
      'skeleton': _skeletonPathValue,
      'atlas': _atlasPathValue,
      'animation': _selectedAnimationValue,
      'scale': {
        'x': double.tryParse(_scaleXValue) ?? 0.25,
        'y': double.tryParse(_scaleYValue) ?? 0.25
      },
      'position': {
        'x': double.tryParse(_positionXValue) ?? 0,
        'y': double.tryParse(_positionYValue) ?? 0
      },
    };

    // Thêm skin nếu đã chọn
    if (_selectedSkinValue.isNotEmpty) {
      newItem['skins'] = _selectedSkinValue;
    }

    // Add to spine list
    if (_currentEditingIndex >= 0 && _currentEditingIndex < spineList.length) {
      // Cập nhật phần tử đang chỉnh sửa
      spineList[_currentEditingIndex] = newItem;
    } else {
      // Thêm phần tử mới
      spineList.add(newItem);
    }

    // Update config
    setState(() {
      _loadedAnimSpineConfig['spine_animations'] = spineList;

      // Clear values
      _resetForm();

      // Sau khi cập nhật, gọi _updateAnimSpineConfig để cập nhật Preview
      _updateAnimSpineConfig();
    });
  }

  // Bắt đầu chỉnh sửa spine animation
  void _startEditSpineAnimation(int index) {
    List<dynamic> spineList = _loadedAnimSpineConfig['spine_animations'] ?? [];
    if (index >= 0 && index < spineList.length) {
      final item = spineList[index];

      setState(() {
        _currentEditingSpine = Map<String, dynamic>.from(item);
        _currentEditingIndex = index;

        // Cập nhật giá trị form từ item đang chỉnh sửa
        _idValue = item['id'] ?? '';
        _skeletonPathValue = item['skeleton'] ?? '';
        _atlasPathValue = item['atlas'] ?? '';
        _selectedAnimationValue = item['animation'] ?? '';
        _selectedSkinValue = item['skins'] ?? '';

        // Scale
        if (item.containsKey('scale')) {
          _scaleXValue = (item['scale']['x'] ?? 0.25).toString();
          _scaleYValue = (item['scale']['y'] ?? 0.25).toString();
        } else {
          _scaleXValue = '0.25';
          _scaleYValue = '0.25';
        }

        // Position
        if (item.containsKey('position')) {
          _positionXValue = (item['position']['x'] ?? 0).toString();
          _positionYValue = (item['position']['y'] ?? 0).toString();
        } else {
          _positionXValue = '0';
          _positionYValue = '0';
        }

        // Tự động phân tích file skeleton để lấy animations và skins
        _extractAnimationsAndSkins(_skeletonPathValue);
      });
    }
  }

  // Reset form về trạng thái mặc định
  void _resetForm() {
    setState(() {
      _idValue = '';
      _skeletonPathValue = '';
      _atlasPathValue = '';
      _selectedAnimationValue = '';
      _selectedSkinValue = '';
      _scaleXValue = '0.25';
      _scaleYValue = '0.25';
      _positionXValue = '0';
      _positionYValue = '0';
      _currentEditingSpine = null;
      _currentEditingIndex = -1;
      _availableAnimations = [];
      _availableSkins = [];
    });
  }

  // Xóa spine animation
  void _removeSpineAnimation(int index) {
    List<dynamic> spineList = _loadedAnimSpineConfig['spine_animations'] ?? [];
    if (index >= 0 && index < spineList.length) {
      setState(() {
        spineList.removeAt(index);
        _loadedAnimSpineConfig['spine_animations'] = spineList;

        // Reset form nếu đang chỉnh sửa phần tử bị xóa
        if (_currentEditingIndex == index) {
          _resetForm();
        } else if (_currentEditingIndex > index) {
          // Cập nhật lại index nếu đang chỉnh sửa phần tử sau phần tử bị xóa
          _currentEditingIndex--;
        }

        // Sau khi xóa, gọi _updateAnimSpineConfig để cập nhật Preview
        _updateAnimSpineConfig();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Spine Animation',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Đường dẫn đến file cấu hình
        ConfigTextField(
          label: 'Đường dẫn file cấu hình Spine Animation',
          value: widget.animSpineConfigPath,
          onChanged: (value) {
            widget.onAnimSpinePathChanged(value);
          },
          helperText: 'Đường dẫn đến file JSON cấu hình spine animations',
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _loadAnimSpineConfig,
                child: const Text('Tải file cấu hình'),
              ),
            ),
            const SizedBox(width: 8),
            // Nút xem trước thay đổi cấu hình
            Expanded(
              child: ElevatedButton(
                onPressed: _updateAnimSpineConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Cập nhật Preview'),
              ),
            ),
          ],
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
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 32),

              // Hiển thị danh sách các spine animations hiện có
              if (_loadedAnimSpineConfig.containsKey('spine_animations') &&
                  (_loadedAnimSpineConfig['spine_animations'] as List)
                      .isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Danh sách Spine Animations',
                            style: Theme.of(context).textTheme.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _resetForm,
                          tooltip: 'Thêm mới',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Danh sách spine animations
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          (_loadedAnimSpineConfig['spine_animations'] as List)
                              .length,
                      itemBuilder: (context, index) {
                        final item = (_loadedAnimSpineConfig['spine_animations']
                            as List)[index];
                        return SpineAnimationTile(
                          item: item,
                          isSelected: index == _currentEditingIndex,
                          onEdit: () => _startEditSpineAnimation(index),
                          onDelete: () => _removeSpineAnimation(index),
                        );
                      },
                    ),

                    const Divider(height: 32),
                  ],
                ),

              // Form thêm/sửa spine animation
              Text(
                  _currentEditingIndex >= 0
                      ? 'Chỉnh sửa Spine Animation'
                      : 'Thêm Spine Animation mới',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),

              // ID
              ConfigTextField(
                label: 'ID',
                value: _idValue,
                onChanged: (value) {
                  setState(() {
                    _idValue = value;
                  });
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
                Text('Chưa phát hiện animations',
                    style: TextStyle(color: Colors.orange.shade800)),

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
                      value: _scaleXValue,
                      onChanged: (value) {
                        setState(() {
                          _scaleXValue = value;
                        });
                      },
                      helperText: 'Tỷ lệ theo chiều ngang',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ConfigTextField(
                      label: 'Scale Y',
                      value: _scaleYValue,
                      onChanged: (value) {
                        setState(() {
                          _scaleYValue = value;
                        });
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
                      value: _positionXValue,
                      onChanged: (value) {
                        setState(() {
                          _positionXValue = value;
                        });
                      },
                      helperText: 'Vị trí theo chiều ngang',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ConfigTextField(
                      label: 'Position Y',
                      value: _positionYValue,
                      onChanged: (value) {
                        setState(() {
                          _positionYValue = value;
                        });
                      },
                      helperText: 'Vị trí theo chiều dọc',
                    ),
                  ),
                ],
              ),

              // Action buttons
              const SizedBox(height: 24),
              Row(
                children: [
                  if (_currentEditingIndex >= 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('Hủy chỉnh sửa'),
                      ),
                    ),
                  if (_currentEditingIndex >= 0) const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addSpineAnimation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentEditingIndex >= 0
                            ? Colors.orange
                            : Colors.blue,
                      ),
                      child:
                          Text(_currentEditingIndex >= 0 ? 'Cập nhật' : 'Thêm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

/// Widget hiển thị một spine animation
class SpineAnimationTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SpineAnimationTile({
    Key? key,
    required this.item,
    this.isSelected = false,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = item['id'] ?? 'Không có ID';
    final String animation = item['animation'] ?? 'Không có animation';
    final String skeleton = item['skeleton'] ?? 'N/A';

    // Build scale string if available
    String scale = '';
    if (item.containsKey('scale')) {
      final x = item['scale']['x'] ?? 0.25;
      final y = item['scale']['y'] ?? 0.25;
      scale = 'Scale: ($x, $y)';
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
      color: isSelected ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: const Icon(Icons.sports_gymnastics, size: 36),
        title: Text('$id ($animation)'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skeleton: ${skeleton.split('/').last}'),
            if (scale.isNotEmpty) Text(scale),
            if (position.isNotEmpty) Text(position),
            if (item.containsKey('skins')) Text('Skin: ${item['skins']}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
