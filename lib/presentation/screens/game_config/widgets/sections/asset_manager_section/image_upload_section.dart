import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

/// Widget hiển thị phần upload hình ảnh
class ImageUploadSection extends StatefulWidget {
  final Function(AssetModel) onUploadSuccess;

  const ImageUploadSection({
    Key? key,
    required this.onUploadSuccess,
  }) : super(key: key);

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  bool _isUploading = false;
  String? _errorMessage;

  Future<void> _uploadImageFromLocal() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      final file = result.files.first;
      final fileName = file.name;

      final isImageFile = fileName.toLowerCase().endsWith('.jpg') ||
          fileName.toLowerCase().endsWith('.jpeg') ||
          fileName.toLowerCase().endsWith('.png') ||
          fileName.toLowerCase().endsWith('.webp') ||
          fileName.toLowerCase().endsWith('.gif');

      if (!isImageFile) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'File không đúng định dạng hình ảnh!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Vui lòng chọn file hình ảnh (jpg, jpeg, png, webp, gif)!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final imageName = path.basenameWithoutExtension(fileName);
      String customName = imageName;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận Upload Hình ảnh'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File: $fileName'),
                const SizedBox(height: 8),
                Text('File sẽ được upload lên server tại thư mục:'),
                const Text('Test/images'),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Tên hình ảnh (tùy chỉnh)',
                    hintText: 'Nếu để trống sẽ dùng tên file gốc',
                    helperText:
                        'Nhập tên tùy chỉnh nếu muốn thay đổi tên hình ảnh',
                  ),
                  controller: TextEditingController(text: imageName),
                  onChanged: (value) {
                    customName =
                        value.trim().isNotEmpty ? value.trim() : imageName;
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

      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      AssetModel? uploadedAsset;

      if (kIsWeb) {
        if (file.bytes != null) {
          uploadedAsset = await assetRepository.uploadImageAssetWeb(
            file.bytes!,
            fileName,
            customName: customName,
          );
        } else {
          throw Exception('Không thể đọc dữ liệu file');
        }
      } else {
        if (file.path != null) {
          uploadedAsset = await assetRepository.uploadImageAsset(
            File(file.path!),
            customName: customName,
          );
        } else {
          throw Exception('Không thể đọc đường dẫn file');
        }
      }

      if (uploadedAsset != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã upload hình ảnh thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onUploadSuccess(uploadedAsset);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể upload hình ảnh!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi upload hình ảnh: $e';
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi upload hình ảnh: $e'),
          backgroundColor: Colors.red,
        ),
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
            Text('Upload Hình ảnh từ local',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn và Upload Hình ảnh'),
              onPressed: _isUploading ? null : _uploadImageFromLocal,
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
                  Text('Lưu ý:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                      '1. Các định dạng hình ảnh được hỗ trợ: jpg, jpeg, png, webp, gif'),
                  Text('2. Kích thước file không được vượt quá 5MB'),
                  Text(
                      '3. Nên sử dụng hình ảnh có kích thước vừa phải để tối ưu hiệu suất'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
