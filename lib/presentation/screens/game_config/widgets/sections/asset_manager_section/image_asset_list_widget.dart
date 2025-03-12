/// ImageAssetListWidget - Widget hiển thị danh sách Image Assets
/// Component này là một phần của AssetManagerSection

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Widget hiển thị danh sách các image assets
class ImageAssetListWidget extends StatefulWidget {
  final List<AssetModel> assets;
  final Function(AssetModel) onDeleteAsset;

  const ImageAssetListWidget({
    Key? key,
    required this.assets,
    required this.onDeleteAsset,
  }) : super(key: key);

  @override
  State<ImageAssetListWidget> createState() => _ImageAssetListWidgetState();
}

class _ImageAssetListWidgetState extends State<ImageAssetListWidget> {
  String _searchQuery = '';
  List<AssetModel> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.assets;
  }

  @override
  void didUpdateWidget(ImageAssetListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets != widget.assets) {
      _filterAssets();
    }
  }

  /// Lọc assets theo từ khóa tìm kiếm
  void _filterAssets() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredAssets = widget.assets;
      });
    } else {
      final query = _searchQuery.toLowerCase();
      setState(() {
        _filteredAssets = widget.assets.where((asset) {
          return asset.name.toLowerCase().contains(query) ||
              asset.id.toLowerCase().contains(query) ||
              asset.path.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề và tổng số
        Row(
          children: [
            Text(
              'Danh sách Hình Ảnh (${widget.assets.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            // Ô tìm kiếm
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterAssets();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Hiển thị danh sách
        if (_filteredAssets.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Không có Hình Ảnh nào',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          SizedBox(
            height: 400, // Chiều cao cố định cho danh sách
            child: ListView.builder(
              itemCount: _filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = _filteredAssets[index];
                return _buildImageAssetCard(asset);
              },
            ),
          ),
      ],
    );
  }

  /// Xây dựng card hiển thị thông tin image asset
  Widget _buildImageAssetCard(AssetModel asset) {
    final bool isSvg = asset.metadata['isSvg'] ?? false;
    final Map<String, dynamic>? dimensions = asset.metadata['dimensions'];

    // File extension để hiển thị
    final String fileExtension =
        isSvg ? 'SVG' : asset.path.split('.').last.toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            Row(
              children: [
                // Icon và tên
                Icon(
                  isSvg ? Icons.insert_chart_outlined : Icons.image,
                  size: 24,
                  color: isSvg ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${asset.id}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Loại file
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isSvg ? Colors.green.shade100 : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    fileExtension,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSvg
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Nút xóa
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteAsset(asset),
                  tooltip: 'Xóa hình ảnh',
                ),
              ],
            ),
            const Divider(),

            // Thông tin chi tiết
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đường dẫn: ${asset.path}'),
                  if (dimensions != null)
                    Text(
                        'Kích thước: ${dimensions['width']} x ${dimensions['height']}'),
                  Text('Loại: ${isSvg ? 'Vector (SVG)' : 'Raster (Bitmap)'}'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Ngày thêm
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Thêm vào: ${_formatDate(asset.dateAdded)}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Format DateTime thành chuỗi hiển thị
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
