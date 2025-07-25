/// ImageAssetListWidget - Widget hiển thị danh sách Image Assets
/// Component này là một phần của AssetManagerSection

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'image_upload_section.dart';
import 'image_asset_card.dart';

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
        Row(
          children: [
            Text(
              'Danh sách Hình ảnh (${widget.assets.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
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
        ImageUploadSection(
          onUploadSuccess: (asset) {
            setState(() {
              widget.assets.add(asset);
              _filterAssets();
            });
          },
        ),
        const SizedBox(height: 16),
        if (_filteredAssets.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Không có Hình ảnh nào',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          SizedBox(
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemCount: _filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = _filteredAssets[index];
                return ImageAssetCard(
                  asset: asset,
                  onDelete: widget.onDeleteAsset,
                );
              },
            ),
          ),
      ],
    );
  }
}
