/// ImageAssetSelectorDialog - Widget để chọn hình ảnh từ Asset Manager
/// Widget có thể tái sử dụng trong toàn ứng dụng

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Widget dialog để chọn hình ảnh từ danh sách assets
class ImageAssetSelectorDialog extends StatefulWidget {
  final AssetModel? initialSelectedAsset;
  final bool showUploadButton;

  const ImageAssetSelectorDialog({
    Key? key,
    this.initialSelectedAsset,
    this.showUploadButton = true,
  }) : super(key: key);

  @override
  State<ImageAssetSelectorDialog> createState() =>
      _ImageAssetSelectorDialogState();
}

class _ImageAssetSelectorDialogState extends State<ImageAssetSelectorDialog> {
  List<AssetModel> _imageAssets = [];
  bool _isLoading = true;
  String _searchQuery = '';
  List<AssetModel> _filteredAssets = [];
  AssetModel? _selectedAsset;

  @override
  void initState() {
    super.initState();
    _selectedAsset = widget.initialSelectedAsset;
    _loadImageAssets();
  }

  /// Tải danh sách hình ảnh từ repository
  Future<void> _loadImageAssets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final imageAssets =
          await assetRepository.getAssetsByType(AssetType.image);

      if (mounted) {
        setState(() {
          _imageAssets = imageAssets;
          _filteredAssets = imageAssets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải danh sách hình ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Lọc assets theo từ khóa tìm kiếm
  void _filterAssets(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredAssets = _imageAssets;
      });
    } else {
      final lowercaseQuery = query.toLowerCase();
      setState(() {
        _filteredAssets = _imageAssets.where((asset) {
          return asset.name.toLowerCase().contains(lowercaseQuery) ||
              asset.id.toLowerCase().contains(lowercaseQuery) ||
              (asset.path.toLowerCase().contains(lowercaseQuery));
        }).toList();
      });
    }
  }

  /// Upload hình ảnh mới
  Future<void> _uploadNewImage() async {
    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);

      // Hiển thị dialog để lấy tên cho hình ảnh
      final String? customName = await showDialog<String>(
        context: context,
        builder: (context) {
          final TextEditingController nameController = TextEditingController();
          return AlertDialog(
            title: const Text('Tên hình ảnh'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nhập tên cho hình ảnh này:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên...',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập tên!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, nameController.text);
                },
                child: const Text('Xác nhận'),
              ),
            ],
          );
        },
      );

      if (customName == null || customName.isEmpty) {
        return;
      }

      // Mở file picker để chọn hình ảnh
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      // Hiển thị indicator khi đang upload
      _showUploadingDialog();

      try {
        AssetModel? uploadedAsset;

        // Sử dụng phương thức phù hợp tùy thuộc vào nền tảng
        if (kIsWeb) {
          if (result.files.first.bytes != null) {
            // Upload trên web
            uploadedAsset = await assetRepository.uploadImageAssetWeb(
              result.files.first.bytes!,
              result.files.first.name,
              customName: customName,
            );
          }
        } else {
          if (result.files.first.path != null) {
            // Upload trên mobile/desktop
            final file = File(result.files.first.path!);
            uploadedAsset = await assetRepository.uploadImageAsset(
              file,
              customName: customName,
            );
          }
        }

        // Đóng dialog upload
        Navigator.of(context, rootNavigator: true).pop();

        if (uploadedAsset != null) {
          setState(() {
            // Thêm vào danh sách và cập nhật filtered assets
            _imageAssets.add(uploadedAsset!);
            _filterAssets(_searchQuery);
            _selectedAsset = uploadedAsset;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Tải lên hình ảnh "${uploadedAsset.name}" thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải lên hình ảnh. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Đóng dialog upload nếu có lỗi
        Navigator.of(context, rootNavigator: true).pop();
        rethrow;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên hình ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hiển thị dialog khi đang tải lên
  Future<void> _showUploadingDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải lên hình ảnh...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn Hình Ảnh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Upload button
            if (widget.showUploadButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload hình mới'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _uploadNewImage();
                    },
                  ),
                ],
              ),

            const Divider(),
            const SizedBox(height: 8),

            // Search field
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm hình ảnh...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterAssets(value);
                });
              },
            ),

            const SizedBox(height: 16),

            // Danh sách image assets
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredAssets.isEmpty
                      ? const Center(
                          child: Text(
                            'Không có hình ảnh nào. Hãy upload trong Asset Manager.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: _filteredAssets.length,
                          itemBuilder: (context, index) {
                            final asset = _filteredAssets[index];
                            final isSelected = _selectedAsset?.id == asset.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAsset = asset;
                                });
                              },
                              onDoubleTap: () {
                                Navigator.of(context).pop(asset);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    width: isSelected ? 3 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(7),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: asset.url ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      color: isSelected
                                          ? Colors.blue.shade50
                                          : null,
                                      child: Text(
                                        asset.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedAsset == null
                      ? null
                      : () {
                          final asset = _selectedAsset;
                          if (asset != null) {
                            Navigator.of(context).pop(asset);
                          }
                        },
                  child: const Text('Chọn'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
