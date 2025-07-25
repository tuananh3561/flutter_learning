/// SpineAssetListWidget - Widget hiển thị danh sách Spine Animations
/// Component này là một phần của AssetManagerSection

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'spine_upload_section.dart';
import 'spine_asset_card.dart';

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
        Row(
          children: [
            Text(
              'Danh sách Spine Animations (${widget.assets.length})',
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
        SpineUploadSection(
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
                'Không có Spine Animation nào',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: _filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = _filteredAssets[index];
                return SpineAssetCard(
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
