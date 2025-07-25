import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Widget hiển thị thông tin của một spine asset dưới dạng card
class SpineAssetCard extends StatelessWidget {
  final AssetModel asset;
  final Function(AssetModel) onDelete;

  const SpineAssetCard({
    Key? key,
    required this.asset,
    required this.onDelete,
  }) : super(key: key);

  /// Format DateTime thành chuỗi hiển thị
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => onDelete(asset),
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
}
