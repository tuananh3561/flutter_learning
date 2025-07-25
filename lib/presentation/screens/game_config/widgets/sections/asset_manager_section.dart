import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';

import '../feedback_message.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAssets();
  }

  @override
  void dispose() {
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          // _buildSpineUploadSection(),
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
                          // _buildAudioUploadSection(),
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
                          // _buildImageUploadSection(),
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
}
