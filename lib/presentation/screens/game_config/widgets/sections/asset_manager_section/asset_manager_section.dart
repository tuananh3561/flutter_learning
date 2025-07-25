/// Asset Manager Section - Quản lý tài nguyên (hình ảnh, âm thanh, spine)
/// Component này là một phần của ConfigEditorPanel

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';
import 'spine_asset_list_widget.dart';
import 'audio_asset_list_widget.dart';
import 'image_asset_list_widget.dart';

/// Phần quản lý assets (hình ảnh, âm thanh, spine)
class AssetManagerSection extends StatefulWidget {
  const AssetManagerSection({Key? key}) : super(key: key);

  @override
  State<AssetManagerSection> createState() => _AssetManagerSectionState();
}

class _AssetManagerSectionState extends State<AssetManagerSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AssetModel> _spineAssets = [];
  List<AssetModel> _audioAssets = [];
  List<AssetModel> _imageAssets = [];
  bool _isLoading = false;
  String? _errorMessage;

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

  /// Load tất cả assets từ repository
  Future<void> _loadAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);

      // Scan assets từ server trước để đảm bảo có dữ liệu mới nhất
      await assetRepository.scanAllAssets();

      // Sau đó load từng loại asset
      final spineAssets =
          await assetRepository.getAssetsByType(AssetType.spine);
      final audioAssets =
          await assetRepository.getAssetsByType(AssetType.audio);
      final imageAssets =
          await assetRepository.getAssetsByType(AssetType.image);

      if (mounted) {
        setState(() {
          _spineAssets = spineAssets;
          _audioAssets = audioAssets;
          _imageAssets = imageAssets;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading assets: $e';
        _isLoading = false;
      });
    }
  }

  /// Xóa asset đã chọn
  Future<void> _deleteAsset(AssetModel asset) async {
    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa "${asset.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() => _isLoading = true);
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final success = await assetRepository.deleteAsset(asset.id);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa ${asset.name}'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          // Xóa asset khỏi danh sách tương ứng
          switch (asset.type) {
            case AssetType.spine:
              _spineAssets.removeWhere((a) => a.id == asset.id);
              break;
            case AssetType.audio:
              _audioAssets.removeWhere((a) => a.id == asset.id);
              break;
            case AssetType.image:
              _imageAssets.removeWhere((a) => a.id == asset.id);
              break;
            default:
              break;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể xóa asset'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa asset: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              'Quản lý tài nguyên',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            // Refresh button
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadAssets,
              tooltip: 'Làm mới danh sách',
            ),
          ],
        ),

        // Error message
        if (_errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _errorMessage = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

        // Loading indicator
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(),
          ),

        const SizedBox(height: 16),

        // Tab controller
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.animation),
              text: 'Spine Animations',
            ),
            Tab(
              icon: Icon(Icons.music_note),
              text: 'Audio',
            ),
            Tab(
              icon: Icon(Icons.image),
              text: 'Hình ảnh',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Tab content
        SizedBox(
          height: 600, // Chiều cao cố định cho nội dung tab
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Spine Animations
              SpineAssetListWidget(
                assets: _spineAssets,
                onDeleteAsset: _deleteAsset,
              ),

              // Tab 2: Audio
              AudioAssetListWidget(
                assets: _audioAssets,
                onDeleteAsset: _deleteAsset,
              ),

              // Tab 3: Hình ảnh
              ImageAssetListWidget(
                assets: _imageAssets,
                onDeleteAsset: _deleteAsset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
