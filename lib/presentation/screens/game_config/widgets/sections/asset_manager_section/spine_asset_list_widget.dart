/// SpineAssetListWidget - Widget hiển thị danh sách Spine Animations
/// Component này là một phần của AssetManagerSection

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Widget hiển thị danh sách các spine animations
class SpineAssetListWidget extends StatefulWidget {
  final List<AssetModel> assets;
  final Function(AssetModel) onDeleteAsset;

  const SpineAssetListWidget({
    Key? key,
    required this.assets,
    required this.onDeleteAsset,
  }) : super(key: key);

  @override
  State<SpineAssetListWidget> createState() => _SpineAssetListWidgetState();
}

class _SpineAssetListWidgetState extends State<SpineAssetListWidget> {
  String _searchQuery = '';
  List<AssetModel> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.assets;
  }

  @override
  void didUpdateWidget(SpineAssetListWidget oldWidget) {
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
              'Danh sách Spine Animations (${widget.assets.length})',
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
                'Không có Spine Animation nào',
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
                return _buildSpineAssetCard(asset);
              },
            ),
          ),
      ],
    );
  }

  /// Xây dựng card hiển thị thông tin spine asset
  Widget _buildSpineAssetCard(AssetModel asset) {
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
                const Icon(Icons.animation, size: 24),
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

                // Nút xóa
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteAsset(asset),
                  tooltip: 'Xóa animation',
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
                  Text('Skeleton: ${asset.metadata['skeleton']}'),
                  Text('Atlas: ${asset.metadata['atlas']}'),
                  Text('Animation: ${asset.metadata['animation']}'),
                  const SizedBox(height: 4),
                  Text(
                    'Scale: X=${asset.metadata['scale']['x']}, Y=${asset.metadata['scale']['y']}',
                  ),
                  if (asset.metadata.containsKey('position'))
                    Text(
                      'Position: X=${asset.metadata['position']['x']}, Y=${asset.metadata['position']['y']}',
                    ),
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
