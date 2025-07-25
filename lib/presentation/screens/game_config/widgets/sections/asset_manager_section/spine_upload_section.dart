import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

/// Widget hiển thị phần upload spine animation
class SpineUploadSection extends StatefulWidget {
  final Function(AssetModel) onUploadSuccess;

  const SpineUploadSection({
    Key? key,
    required this.onUploadSuccess,
  }) : super(key: key);

  @override
  State<SpineUploadSection> createState() => _SpineUploadSectionState();
}

class _SpineUploadSectionState extends State<SpineUploadSection> {
  bool _isUploading = false;
  String? _errorMessage;

  /// Upload Spine animation từ local lên server
  Future<void> _uploadSpineFromLocal() async {
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
        withData: kIsWeb, // Đảm bảo dữ liệu file được tải khi chạy trên web
        dialogTitle:
            'Chọn các files của Spine animation (json, atlas, png, ...)',
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      List<File> files = [];
      List<String> fileNames = [];
      List<Uint8List> webFiles = [];
      Map<String, Uint8List> webFileMap = {};

      // Xử lý files khác nhau tùy theo platform
      if (kIsWeb) {
        // Trên web, chúng ta sẽ lấy bytes và filename
        for (var platformFile in result.files) {
          if (platformFile.bytes != null) {
            webFiles.add(platformFile.bytes!);
            fileNames.add(platformFile.name);
            webFileMap[platformFile.name] = platformFile.bytes!;
          }
        }

        if (webFiles.isEmpty) {
          throw Exception('Không thể đọc dữ liệu file');
        }
      } else {
        // Trên mobile/desktop, chúng ta sử dụng File
        files = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();

        if (files.isEmpty) {
          throw Exception('Không thể đọc đường dẫn file');
        }

        // Lấy danh sách tên file
        fileNames = files.map((file) => path.basename(file.path)).toList();
      }

      // Kiểm tra xem có file .json nào không
      final hasJsonFile = fileNames.any(
        (fileName) => fileName.toLowerCase().endsWith('.json'),
      );

      if (!hasJsonFile) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'Không tìm thấy file .json trong các file được chọn!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vui lòng chọn file .json của Spine animation!')),
        );
        return;
      }

      // Lấy tên thư mục dựa vào file Spine
      String? spineName;

      // Tìm file skeleton.json
      final skeletonIndex = fileNames.indexWhere(
        (fileName) => fileName.toLowerCase() == 'skeleton.json',
      );

      final skeletonFileName = skeletonIndex >= 0
          ? fileNames[skeletonIndex]
          : fileNames.firstWhere(
              (fileName) => fileName.toLowerCase().endsWith('.json'),
              orElse: () => fileNames.first);

      if (skeletonFileName.toLowerCase() == 'skeleton.json') {
        // Nếu là skeleton.json, sử dụng tên thư mục chứa nó hoặc tên mặc định
        spineName = 'spine_animation'; // Tên mặc định cho web

        if (!kIsWeb && files.isNotEmpty) {
          // Trên non-web, chúng ta có thể lấy tên thư mục cha
          final skeletonFile = files.firstWhere(
            (file) => path.basename(file.path).toLowerCase() == 'skeleton.json',
            orElse: () => files.first,
          );
          final directory = path.dirname(skeletonFile.path);
          spineName = path.basename(directory);
        }
      } else {
        // Nếu không phải skeleton.json, dùng tên file không có extension
        spineName = path.basenameWithoutExtension(skeletonFileName);
      }

      // Hiển thị dialog xác nhận với thông tin files sẽ được upload
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận Upload Spine'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Số files được chọn: ${fileNames.length}'),
                Text('Tên animation: $spineName'),
                const SizedBox(height: 8),
                Text('Files sẽ được upload lên server tại thư mục:'),
                const Text('Test/spine/<tên_animation>'),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Tên animation (tùy chỉnh)',
                    hintText: 'Nếu để trống sẽ dùng tên mặc định',
                    helperText:
                        'Nhập tên tùy chỉnh nếu muốn thay đổi tên animation',
                  ),
                  onChanged: (value) {
                    spineName =
                        value.trim().isNotEmpty ? value.trim() : spineName;
                  },
                ),
                const SizedBox(height: 16),
                // Hiển thị danh sách file
                Text('Danh sách file:'),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: fileNames.length,
                    itemBuilder: (context, index) => Text(
                      '${index + 1}. ${fileNames[index]}',
                      style: const TextStyle(fontSize: 12),
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
            TextButton(
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

      // Upload files lên server
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);

      AssetModel? uploadedAsset;

      if (kIsWeb) {
        try {
          uploadedAsset = await assetRepository.uploadSpineAssetWeb(
            webFileMap,
            customName: spineName,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi upload từ web: $e')),
          );

          setState(() {
            _isUploading = false;
            _errorMessage = 'Lỗi khi upload từ web: $e';
          });
          return;
        }
      } else {
        // Upload trên desktop/mobile
        uploadedAsset = await assetRepository.uploadSpineAsset(
          files,
          customName: spineName,
        );
      }

      if (uploadedAsset != null) {
        // Thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Đã upload Spine animation thành công!')),
        );

        widget.onUploadSuccess(uploadedAsset);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể upload Spine animation!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi upload Spine animation: $e';
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi upload Spine animation: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Spine từ local',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn và Upload Spine'),
              onPressed: _isUploading ? null : _uploadSpineFromLocal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
}
