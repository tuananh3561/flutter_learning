import 'package:flutter/material.dart';

/// Widget hiển thị một phần tử trang trí
class DecorationItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DecorationItemTile({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = item['type'] ?? 'unknown';
    final String id = item['id'] ?? 'Không có ID';

    IconData typeIcon;
    String typeDescription;
    String details = '';

    // Set icon and description based on type
    switch (type) {
      case 'image':
        typeIcon = Icons.image;
        typeDescription = 'Hình ảnh';
        details = 'Path: ${item['image'] ?? 'N/A'}';
        break;
      case 'animation':
        typeIcon = Icons.animation;
        typeDescription = 'Animation';
        details = 'Animation: ${item['animation'] ?? 'N/A'}';
        break;
      case 'spine':
        typeIcon = Icons.sports_gymnastics;
        typeDescription = 'Spine';
        details = 'Animation: ${item['animation'] ?? 'N/A'}';
        break;
      default:
        typeIcon = Icons.question_mark;
        typeDescription = 'Không xác định';
    }

    // Build position string if available
    String position = '';
    if (item.containsKey('position')) {
      final x = item['position']['x'] ?? 0;
      final y = item['position']['y'] ?? 0;
      position = 'Position: ($x, $y)';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(typeIcon, size: 36),
        title: Text('$id ($typeDescription)'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details),
            if (position.isNotEmpty) Text(position),
            if (item.containsKey('scale')) Text('Scale: ${item['scale']}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Chỉnh sửa',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Xóa',
            ),
          ],
        ),
      ),
    );
  }
}
