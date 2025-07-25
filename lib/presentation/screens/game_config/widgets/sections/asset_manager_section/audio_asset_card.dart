import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Widget hiển thị thông tin của một audio asset dưới dạng card
class AudioAssetCard extends StatelessWidget {
  final AssetModel asset;
  final bool isPlaying;
  final double currentPosition;
  final double duration;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final Function(AssetModel) onDelete;

  const AudioAssetCard({
    Key? key,
    required this.asset,
    required this.isPlaying,
    required this.currentPosition,
    required this.duration,
    required this.onPlay,
    required this.onStop,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(asset.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset.path, style: const TextStyle(fontSize: 12)),
            if (isPlaying)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: currentPosition / duration,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              onPressed: isPlaying ? onStop : onPlay,
              tooltip: isPlaying ? 'Dừng phát' : 'Phát audio',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(asset),
              tooltip: 'Xóa audio',
            ),
          ],
        ),
      ),
    );
  }
}
