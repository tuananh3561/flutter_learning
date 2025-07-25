import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'image_preview_dialog.dart';

/// Widget hiển thị thông tin của một image asset dưới dạng card
class ImageAssetCard extends StatelessWidget {
  final AssetModel asset;
  final Function(AssetModel) onDelete;

  const ImageAssetCard({
    Key? key,
    required this.asset,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => ImagePreviewDialog.show(context, asset),
              child: CachedNetworkImage(
                imageUrl: asset.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                asset.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => onDelete(asset),
              tooltip: 'Xóa hình ảnh',
              iconSize: 18,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => ImagePreviewDialog.show(context, asset),
                    child: const Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
