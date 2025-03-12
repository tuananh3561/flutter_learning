import 'package:flutter/material.dart';

/// Widget hiển thị danh sách các spine animation
class SpineAnimationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> animations;
  final Function(int) onEditAnimation;
  final Function(int) onDeleteAnimation;
  final VoidCallback onAddNew;

  const SpineAnimationListWidget({
    Key? key,
    required this.animations,
    required this.onEditAnimation,
    required this.onDeleteAnimation,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Danh sách Spine Animations',
                    style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm mới'),
                  onPressed: onAddNew,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (animations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Chưa có spine animation nào. Nhấn "Thêm mới" để tạo một animation.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: animations.length,
                itemBuilder: (context, index) {
                  final item = animations[index];
                  return _SpineAnimationTile(
                    item: item,
                    onEdit: () => onEditAnimation(index),
                    onDelete: () => onDeleteAnimation(index),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị một spine animation trong danh sách
class _SpineAnimationTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SpineAnimationTile({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = item['id'] ?? 'Không có ID';
    final String animation = item['animation'] ?? 'Không có animation';
    final String skeleton = item['skeleton'] ?? 'N/A';

    // Build scale string if available
    String scale = '';
    if (item.containsKey('scale')) {
      final x = item['scale']['x'] ?? 0.25;
      final y = item['scale']['y'] ?? 0.25;
      scale = 'Scale: ($x, $y)';
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
        leading: const Icon(Icons.sports_gymnastics, size: 36),
        title: Text('$id ($animation)'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skeleton: ${skeleton.split('/').last}'),
            if (scale.isNotEmpty) Text(scale),
            if (position.isNotEmpty) Text(position),
            if (item.containsKey('skins')) Text('Skin: ${item['skins']}'),
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
