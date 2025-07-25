import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config_editor_panel.dart';
import 'anim_spine_section/spine_animation_editor_dialog.dart';
import 'anim_spine_section/spine_animation_list_widget.dart';

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

  // Bắt đầu chỉnh sửa spine animation
  Future<void> _editSpineAnimation(int index) async {
    List<dynamic> spineList = _loadedAnimSpineConfig['spine_animations'] ?? [];
    if (index < 0 || index >= spineList.length) return;

    final item = spineList[index];

    // Lấy giá trị scale và position
    String? scaleX, scaleY, positionX, positionY;
    if (item.containsKey('scale')) {
      scaleX = item['scale']['x'].toString();
      scaleY = item['scale']['y'].toString();
    }

    if (item.containsKey('position')) {
      positionX = item['position']['x'].toString();
      positionY = item['position']['y'].toString();
    }

    // Hiển thị dialog chỉnh sửa
    final result = await SpineAnimationEditorDialog.show(
      context,
      editingIndex: index,
      id: item['id'],
      skeletonPath: item['skeleton'],
      atlasPath: item['atlas'],
      selectedAnimation: item['animation'],
      selectedSkin: item['skins'],
      scaleX: scaleX,
      scaleY: scaleY,
      positionX: positionX,
      positionY: positionY,
    );

    // Xử lý kết quả từ dialog
    if (result != null) {
      setState(() {
        spineList[index] = result;
        _loadedAnimSpineConfig['spine_animations'] = spineList;
        _updateAnimSpineConfig();
      });
    }
  }

  // Thêm spine animation mới
  Future<void> _addSpineAnimation() async {
    // Hiển thị dialog thêm mới
    final result = await SpineAnimationEditorDialog.show(
      context,
      editingIndex: -1,
    );

    // Xử lý kết quả từ dialog
    if (result != null) {
      List<dynamic> spineList =
          _loadedAnimSpineConfig['spine_animations'] ?? [];

      setState(() {
        spineList.add(result);
        _loadedAnimSpineConfig['spine_animations'] = spineList;
        _updateAnimSpineConfig();
      });
    }
  }

  // Xóa một spine animation
  void _deleteSpineAnimation(int index) {
    List<dynamic> spineList = _loadedAnimSpineConfig['spine_animations'] ?? [];

    if (index >= 0 && index < spineList.length) {
      setState(() {
        spineList.removeAt(index);
        _loadedAnimSpineConfig['spine_animations'] = spineList;
        _updateAnimSpineConfig();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> spineAnimations =
        _loadedAnimSpineConfig.containsKey('spine_animations')
            ? List<Map<String, dynamic>>.from(
                _loadedAnimSpineConfig['spine_animations'])
            : [];

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

              // Hiển thị danh sách các spine animations
              SpineAnimationListWidget(
                animations: spineAnimations,
                onEditAnimation: _editSpineAnimation,
                onDeleteAnimation: _deleteSpineAnimation,
                onAddNew: _addSpineAnimation,
              ),
            ],
          ),
      ],
    );
  }
}
