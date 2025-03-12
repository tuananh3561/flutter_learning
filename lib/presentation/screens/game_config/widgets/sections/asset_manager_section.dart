/// AssetManagerSection - UI component quản lý các asset (Spine, Audio, Image)
/// Component này tách từ AnimSpineSection, mở rộng để quản lý nhiều loại asset

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';

import '../config_editor_panel.dart';
import '../feedback_message.dart';
import '../../utils/color_utils.dart';
import 'asset_manager_section/spine_asset_list_widget.dart';
import 'asset_manager_section/audio_asset_list_widget.dart';
import 'asset_manager_section/image_asset_list_widget.dart';

/// Widget để quản lý assets (Spine, Audio, Image)
class AssetManagerSection extends StatefulWidget {
  const AssetManagerSection({
    Key? key,
  }) : super(key: key);

  @override
  State<AssetManagerSection> createState() => _AssetManagerSectionState();
}

class _AssetManagerSectionState extends State<AssetManagerSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  List<AssetModel> _spineAssets = [];
  List<AssetModel> _audioAssets = [];
  List<AssetModel> _imageAssets = [];

  final TextEditingController _spineTargetPathController =
      TextEditingController(text: 'assets/Spine/');
  final TextEditingController _audioTargetPathController =
      TextEditingController(text: 'assets/Audio/');
  final TextEditingController _imageTargetPathController =
      TextEditingController(text: 'assets/Images/');

  // Các controllers cho các dialog
  final TextEditingController _audioNameController = TextEditingController();
  final TextEditingController _imageNameController = TextEditingController();
  bool _isAudioMusic = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAssets();
  }

  @override
  void dispose() {
    _spineTargetPathController.dispose();
    _audioTargetPathController.dispose();
    _imageTargetPathController.dispose();
    _audioNameController.dispose();
    _imageNameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Load assets from repository
  Future<void> _loadAssets() async {
    final assetRepository =
        Provider.of<AssetRepository>(context, listen: false);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load assets by type
      final spineAssets =
          await assetRepository.getAssetsByType(AssetType.spine);
      final audioAssets =
          await assetRepository.getAssetsByType(AssetType.audio);
      final imageAssets =
          await assetRepository.getAssetsByType(AssetType.image);

      setState(() {
        _spineAssets = spineAssets;
        _audioAssets = audioAssets;
        _imageAssets = imageAssets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách assets: $e';
        _isLoading = false;
      });
    }
  }

  /// Scan tất cả assets từ thư mục assets
  Future<void> _scanAllAssets() async {
    final assetRepository =
        Provider.of<AssetRepository>(context, listen: false);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await assetRepository.scanAllAssets();
      await _loadAssets(); // Tải lại danh sách sau khi quét

      FeedbackMessage.showSuccess(
        context,
        message: 'Đã quét và cập nhật danh sách assets thành công!',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi quét assets: $e';
        _isLoading = false;
      });

      FeedbackMessage.showError(
        context,
        message: 'Lỗi khi quét assets: $e',
      );
    }
  }

  /// Upload Spine animation từ local
  Future<void> _uploadSpineFromLocal() async {
    if (_spineTargetPathController.text.trim().isEmpty) {
      FeedbackMessage.showError(
        context,
        message: 'Vui lòng nhập đường dẫn thư mục đích trong assets',
      );
      return;
    }

    setState(() {
      _isLoading = true;
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
          _isLoading = false;
        });
        return;
      }

      // Convert PlatformFile to File
      final files = result.files.map((file) => File(file.path!)).toList();

      // Xác định tên thư mục Spine dựa vào file skeleton.json
      String spineFolderName = 'unknown_spine';
      final jsonFile = result.files.firstWhere(
        (file) => file.name.toLowerCase().endsWith('.json'),
        orElse: () => result.files.first,
      );

      if (jsonFile.name.toLowerCase() == 'skeleton.json') {
        // Lấy tên từ đường dẫn file json (ví dụ: character/skeleton.json -> character)
        final directory = path.dirname(jsonFile.path ?? '');
        spineFolderName = path.basename(directory);
      } else {
        // Nếu không phải là skeleton.json, dùng tên file không có extension
        spineFolderName = path.basenameWithoutExtension(jsonFile.name);
      }

      // Chuẩn bị đường dẫn đích trong assets
      final targetDir = _spineTargetPathController.text.trim();

      // Hiển thị dialog xác nhận với thông tin files sẽ được upload
      final fileInfos = <String>[];
      for (final file in result.files) {
        final fileName = path.basename(file.path ?? file.name);
        fileInfos.add('✓ $fileName');
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
                Text(
                    'File Spine sẽ được upload vào thư mục: $targetDir$spineFolderName'),
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
          _isLoading = false;
        });
        return;
      }

      // Upload Spine asset
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final spineAsset = await assetRepository.uploadSpineAsset(
        files.toList(),
        targetDir,
      );

      if (spineAsset != null) {
        // Tải lại danh sách sau khi upload thành công
        await _loadAssets();

        FeedbackMessage.showSuccess(
          context,
          message:
              'Upload Spine thành công!\n\nĐường dẫn: $targetDir$spineFolderName',
        );
      } else {
        FeedbackMessage.showError(
          context,
          message: 'Không thể upload Spine asset. Vui lòng thử lại.',
        );
      }
    } catch (e) {
      FeedbackMessage.showError(
        context,
        message: 'Lỗi khi upload Spine: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Upload audio file từ local
  Future<void> _uploadAudioFromLocal() async {
    if (_audioTargetPathController.text.trim().isEmpty) {
      FeedbackMessage.showError(
        context,
        message: 'Vui lòng nhập đường dẫn thư mục đích trong assets',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cho phép người dùng chọn file audio
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        dialogTitle: 'Chọn file audio để upload',
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Convert PlatformFile to File
      final file = File(result.files.first.path!);
      final fileName = path.basename(file.path);

      // Chuẩn bị tên hiển thị
      final displayName = path.basenameWithoutExtension(fileName);

      // Reset các trạng thái controller
      _audioNameController.text = displayName;
      _isAudioMusic = false;

      // Chuẩn bị đường dẫn đích trong assets
      final targetDir = _audioTargetPathController.text.trim();

      // Hiển thị dialog xác nhận với thông tin files sẽ được upload
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Cấu hình và Upload Audio'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('File sẽ được upload: $fileName'),
                  const SizedBox(height: 8),
                  Text('Đường dẫn đích: $targetDir'),
                  const SizedBox(height: 16),

                  // Tên hiển thị
                  TextField(
                    controller: _audioNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên hiển thị',
                      hintText: 'Nhập tên hiển thị cho audio',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Loại audio
                  CheckboxListTile(
                    title: const Text('Nhạc nền (Background Music)'),
                    subtitle: const Text(
                        'Nếu không chọn, file sẽ được xem là hiệu ứng âm thanh (SFX)'),
                    value: _isAudioMusic,
                    onChanged: (value) {
                      setState(() {
                        _isAudioMusic = value ?? false;
                      });
                    },
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
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Upload Audio asset
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final audioAsset = await assetRepository.uploadAudioAsset(
        file,
        targetDir,
        customName: _audioNameController.text,
        isMusic: _isAudioMusic,
      );

      if (audioAsset != null) {
        // Tải lại danh sách sau khi upload thành công
        await _loadAssets();

        FeedbackMessage.showSuccess(
          context,
          message: 'Upload Audio thành công!\n\nĐường dẫn: $targetDir',
        );
      } else {
        FeedbackMessage.showError(
          context,
          message: 'Không thể upload Audio asset. Vui lòng thử lại.',
        );
      }
    } catch (e) {
      FeedbackMessage.showError(
        context,
        message: 'Lỗi khi upload Audio: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Upload image file từ local
  Future<void> _uploadImageFromLocal() async {
    if (_imageTargetPathController.text.trim().isEmpty) {
      FeedbackMessage.showError(
        context,
        message: 'Vui lòng nhập đường dẫn thư mục đích trong assets',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cho phép người dùng chọn file hình ảnh
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        dialogTitle: 'Chọn file hình ảnh để upload',
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Convert PlatformFile to File
      final file = File(result.files.first.path!);
      final fileName = path.basename(file.path);

      // Chuẩn bị tên hiển thị
      final displayName = path.basenameWithoutExtension(fileName);

      // Reset controller
      _imageNameController.text = displayName;

      // Chuẩn bị đường dẫn đích trong assets
      final targetDir = _imageTargetPathController.text.trim();

      // Hiển thị dialog xác nhận với thông tin files sẽ được upload
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cấu hình và Upload Image'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File sẽ được upload: $fileName'),
                const SizedBox(height: 8),
                Text('Đường dẫn đích: $targetDir'),
                const SizedBox(height: 16),

                // Tên hiển thị
                TextField(
                  controller: _imageNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên hiển thị',
                    hintText: 'Nhập tên hiển thị cho hình ảnh',
                    border: OutlineInputBorder(),
                  ),
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
          _isLoading = false;
        });
        return;
      }

      // Upload Image asset
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final imageAsset = await assetRepository.uploadImageAsset(
        file,
        targetDir,
        customName: _imageNameController.text,
      );

      if (imageAsset != null) {
        // Tải lại danh sách sau khi upload thành công
        await _loadAssets();

        FeedbackMessage.showSuccess(
          context,
          message: 'Upload Image thành công!\n\nĐường dẫn: $targetDir',
        );
      } else {
        FeedbackMessage.showError(
          context,
          message: 'Không thể upload Image asset. Vui lòng thử lại.',
        );
      }
    } catch (e) {
      FeedbackMessage.showError(
        context,
        message: 'Lỗi khi upload Image: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Delete một asset
  Future<void> _deleteAsset(AssetModel asset) async {
    // Hiển thị dialog xác nhận xóa
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa asset "${asset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Xóa asset
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      await assetRepository.deleteAsset(asset.id);

      // Tải lại danh sách sau khi xóa
      await _loadAssets();

      FeedbackMessage.showSuccess(
        context,
        message: 'Đã xóa asset "${asset.name}" thành công.',
      );
    } catch (e) {
      FeedbackMessage.showError(
        context,
        message: 'Lỗi khi xóa asset: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quản Lý Asset',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),

        // Mô tả
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Quản lý tất cả assets trong ứng dụng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Bạn có thể quản lý, upload và xem tất cả các loại assets:'),
              Text('• Spine Animations: Các animation dùng cho game'),
              Text('• Audio: Nhạc nền và hiệu ứng âm thanh'),
              Text('• Images: Hình ảnh và UI elements'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Buttons
        Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Tải Lại'),
              onPressed: _isLoading ? null : _loadAssets,
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Quét Assets'),
              onPressed: _isLoading ? null : _scanAllAssets,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
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
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Tab navigation
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Spine Animations'),
                  Tab(text: 'Audio'),
                  Tab(text: 'Images'),
                ],
              ),

              // Tab content
              SizedBox(
                height: 600, // Chiều cao cố định cho tab content
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab Spine
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildSpineUploadSection(),
                          const SizedBox(height: 16),
                          SpineAssetListWidget(
                            assets: _spineAssets,
                            onDeleteAsset: _deleteAsset,
                          ),
                        ],
                      ),
                    ),

                    // Tab Audio
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildAudioUploadSection(),
                          const SizedBox(height: 16),
                          AudioAssetListWidget(
                            assets: _audioAssets,
                            onDeleteAsset: _deleteAsset,
                          ),
                        ],
                      ),
                    ),

                    // Tab Images
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildImageUploadSection(),
                          const SizedBox(height: 16),
                          ImageAssetListWidget(
                            assets: _imageAssets,
                            onDeleteAsset: _deleteAsset,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// Build phần upload Spine
  Widget _buildSpineUploadSection() {
    return Card(
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
              value: _spineTargetPathController.text,
              onChanged: (value) {
                _spineTargetPathController.text = value;
              },
              helperText:
                  'Đường dẫn thư mục để lưu file Spine (ví dụ: assets/Spine/)',
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn và Upload Spine'),
              onPressed: _isLoading ? null : _uploadSpineFromLocal,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.fromHex('#5D87FF'),
              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build phần upload Audio
  Widget _buildAudioUploadSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Audio từ local',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // Đường dẫn thư mục đích trong assets
            ConfigTextField(
              label: 'Thư mục đích trong assets',
              value: _audioTargetPathController.text,
              onChanged: (value) {
                _audioTargetPathController.text = value;
              },
              helperText:
                  'Đường dẫn thư mục để lưu file Audio (ví dụ: assets/Audio/)',
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn và Upload Audio'),
              onPressed: _isLoading ? null : _uploadAudioFromLocal,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.fromHex('#5D87FF'),
              ),
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
                  Text('1. Định dạng audio hỗ trợ: .mp3, .wav, .ogg'),
                  Text(
                      '2. Audio sẽ được phân loại thành nhạc nền hoặc hiệu ứng âm thanh'),
                  Text(
                      '3. Hiệu ứng âm thanh (SFX) sẽ tự động được thêm tiền tố "SFX_"'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build phần upload Image
  Widget _buildImageUploadSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Image từ local',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // Đường dẫn thư mục đích trong assets
            ConfigTextField(
              label: 'Thư mục đích trong assets',
              value: _imageTargetPathController.text,
              onChanged: (value) {
                _imageTargetPathController.text = value;
              },
              helperText:
                  'Đường dẫn thư mục để lưu file Image (ví dụ: assets/Images/)',
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn và Upload Image'),
              onPressed: _isLoading ? null : _uploadImageFromLocal,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.fromHex('#5D87FF'),
              ),
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
                      '1. Định dạng hình ảnh hỗ trợ: .png, .jpg, .jpeg, .svg, .webp'),
                  Text('2. SVG được ưu tiên sử dụng cho UI elements'),
                  Text('3. Hình ảnh sẽ được tối ưu kích thước tự động'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
