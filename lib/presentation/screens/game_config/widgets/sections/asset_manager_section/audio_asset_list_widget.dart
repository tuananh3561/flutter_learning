/// AudioAssetListWidget - Widget hiển thị danh sách Audio Assets
/// Component này là một phần của AssetManagerSection

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Widget hiển thị danh sách các audio assets
class AudioAssetListWidget extends StatefulWidget {
  final List<AssetModel> assets;
  final Function(AssetModel) onDeleteAsset;

  const AudioAssetListWidget({
    Key? key,
    required this.assets,
    required this.onDeleteAsset,
  }) : super(key: key);

  @override
  State<AudioAssetListWidget> createState() => _AudioAssetListWidgetState();
}

class _AudioAssetListWidgetState extends State<AudioAssetListWidget> {
  String _searchQuery = '';
  List<AssetModel> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.assets;
  }

  @override
  void didUpdateWidget(AudioAssetListWidget oldWidget) {
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
              'Danh sách Audio (${widget.assets.length})',
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
                'Không có Audio nào',
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
                return _buildAudioAssetCard(asset);
              },
            ),
          ),
      ],
    );
  }

  /// Xây dựng card hiển thị thông tin audio asset
  Widget _buildAudioAssetCard(AssetModel asset) {
    final bool isMusic = asset.metadata['isMusic'] ?? false;
    final double volume = asset.metadata['volume'] ?? 1.0;

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
                  isMusic ? Icons.music_note : Icons.volume_up,
                  size: 24,
                  color: isMusic ? Colors.purple : Colors.blue,
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

                // Loại audio (Music hoặc SFX)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isMusic ? Colors.purple.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isMusic ? 'Music' : 'SFX',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMusic
                          ? Colors.purple.shade800
                          : Colors.blue.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Nút xóa
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteAsset(asset),
                  tooltip: 'Xóa audio',
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
                  Text('Volume: ${(volume * 100).toStringAsFixed(0)}%'),
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
