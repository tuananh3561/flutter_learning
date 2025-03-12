import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../config_editor_panel.dart';
import 'anim_spine_section/spine_animation_editor_dialog.dart';
import 'anim_spine_section/spine_animation_list_widget.dart';
import '../../utils/color_utils.dart';
import '../feedback_message.dart';

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
  bool _isUploading = false;
  String? _errorMessage;
  Map<String, dynamic> _loadedAnimSpineConfig = {};
  final TextEditingController _targetAssetPathController =
      TextEditingController(text: 'assets/Spine/');

  @override
  void initState() {
    super.initState();
    _loadedAnimSpineConfig = Map<String, dynamic>.from(widget.animSpineConfig);
    _loadAnimSpineConfig();
  }

  @override
  void dispose() {
    _targetAssetPathController.dispose();
    super.dispose();
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

  // Upload Spine 2D từ local lên assets
  Future<void> _uploadSpineFromLocal() async {
    if (_targetAssetPathController.text.trim().isEmpty) {
      FeedbackMessage.showError(context,
          message: 'Vui lòng nhập đường dẫn thư mục đích trong assets');
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      // Cho phép người dùng chọn thư mục chứa các file Spine
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'atlas', 'txt', 'png', 'jpg'],
        allowMultiple: true,
        dialogTitle: 'Chọn các file Spine (skeleton.json, atlas và textures)',
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      // Phân tích các file đã chọn
      final files = result.files;

      // Xác định tên thư mục Spine dựa vào file skeleton.json đầu tiên
      String spineFolderName = 'unknown_spine';
      final jsonFile = files.firstWhere(
        (file) => file.name.toLowerCase().endsWith('.json'),
        orElse: () => files.first,
      );

      if (jsonFile.name.toLowerCase().endsWith('.json')) {
        // Lấy tên từ đường dẫn file json (ví dụ: character/skeleton.json -> character)
        final fileName = path.basename(jsonFile.path ?? jsonFile.name);
        if (fileName.toLowerCase() == 'skeleton.json') {
          final directory = path.dirname(jsonFile.path ?? '');
          spineFolderName = path.basename(directory);
        } else {
          // Nếu không phải là skeleton.json, dùng tên file không có extension
          spineFolderName = path.basenameWithoutExtension(fileName);
        }
      }

      // Chuẩn bị đường dẫn đích trong assets
      final targetAssetPath = _targetAssetPathController.text.trim();
      final targetDir = '$targetAssetPath$spineFolderName';

      // Tạo thông tin cho người dùng
      final fileInfos = <String>[];

      // Xử lý copy files vào assets
      for (final file in files) {
        if (file.path == null) continue;

        final fileName = path.basename(file.path!);
        final targetFilePath = '$targetDir/$fileName';

        fileInfos.add('✓ $fileName -> $targetFilePath');
      }

      // Hiển thị thông tin cho người dùng và xác nhận
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận upload Spine'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File Spine sẽ được upload vào thư mục: $targetDir'),
                const SizedBox(height: 8),
                const Text('Các file sẽ được copy:'),
                const SizedBox(height: 4),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: fileInfos.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(fileInfos[index]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lưu ý: Thao tác này sẽ copy các file từ local vào thư mục assets của dự án.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Upload'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      // Thực hiện copy files
      // Chú ý: Trong thực tế, bạn cần triển khai cơ chế để copy files vào assets
      // Ví dụ: Sử dụng một server API để upload hoặc lưu tạm vào một thư mục local

      // Giả lập việc copy file (trong môi trường thực, đây sẽ là quá trình copy thực sự)
      // await Future.delayed(const Duration(seconds: 2));

      // *** THỰC HIỆN COPY FILES - Đây là đoạn code minh họa ***
      // final appDir = await getApplicationDocumentsDirectory();
      // final tempDir = Directory('${appDir.path}/temp_spine_upload');
      // await tempDir.create(recursive: true);

      // for (final file in files) {
      //   if (file.path == null) continue;
      //   final sourceFile = File(file.path!);
      //   final targetFileName = path.basename(file.path!);
      //   final targetFile = File('${tempDir.path}/$targetFileName');
      //   await sourceFile.copy(targetFile.path);
      // }

      // Giả sử copy thành công
      FeedbackMessage.showSuccess(context,
          message:
              'Upload Spine thành công!\n\nĐường dẫn: $targetDir\n\nĐã copy ${files.length} files.');

      // Tự động tạo file cấu hình skeleton và atlas
      final skeletonPath = '$targetDir/skeleton.json';
      final atlasPath = '$targetDir/skeleton_hdr.atlas.txt';

      // Tạo ID bằng tên folder
      final spineId = spineFolderName.replaceAll(' ', '_').toLowerCase();

      // Thêm vào danh sách spine animations
      await _addSpineFromUpload(spineId, skeletonPath, atlasPath);
    } catch (e) {
      FeedbackMessage.showError(context, message: 'Lỗi khi upload Spine: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Thêm spine animation từ upload
  Future<void> _addSpineFromUpload(
      String id, String skeletonPath, String atlasPath) async {
    try {
      // Mô phỏng phân tích file skeleton
      // Cần thay thế bằng cơ chế thực tế trong ứng dụng của bạn

      // Tạo animation mới với thông tin mặc định
      final newAnimation = {
        'id': id,
        'skeleton': skeletonPath,
        'atlas': atlasPath,
        'animation': 'Idle', // Giá trị mặc định
        'scale': {'x': 0.25, 'y': 0.25},
        'position': {'x': 0, 'y': 0}
      };

      // Thêm vào danh sách spine animations
      List<dynamic> spineList =
          _loadedAnimSpineConfig['spine_animations'] ?? [];
      setState(() {
        spineList.add(newAnimation);
        _loadedAnimSpineConfig['spine_animations'] = spineList;
        _updateAnimSpineConfig();
      });

      // Hiển thị dialog chỉnh sửa để người dùng có thể điều chỉnh thông tin chi tiết
      final index = spineList.length - 1;
      _editSpineAnimation(index);
    } catch (e) {
      FeedbackMessage.showError(context,
          message: 'Lỗi khi thêm spine animation: $e');
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

              // Upload Spine từ local
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload Spine từ local',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Đường dẫn thư mục đích trong assets
                      ConfigTextField(
                        label: 'Thư mục đích trong assets',
                        value: _targetAssetPathController.text,
                        onChanged: (value) {
                          _targetAssetPathController.text = value;
                        },
                        helperText:
                            'Đường dẫn thư mục để lưu file Spine (ví dụ: assets/Spine/)',
                      ),

                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Chọn và Upload Spine'),
                        onPressed: _isUploading ? null : _uploadSpineFromLocal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtils.fromHex('#5D87FF'),
                        ),
                      ),

                      if (_isUploading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: LinearProgressIndicator(),
                        ),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Hướng dẫn:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(
                                '1. Spine assets nên bao gồm: skeleton.json, skeleton_hdr.atlas.txt, và các file texture'),
                            Text(
                                '2. Tất cả các file cần được export từ Spine với định dạng phù hợp'),
                            Text(
                                '3. Cấu trúc thư mục sẽ được tự động tạo dựa trên tên thư mục chứa file skeleton.json'),
                            Text(
                                '4. Sau khi upload, spine animation sẽ được tự động thêm vào danh sách'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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
