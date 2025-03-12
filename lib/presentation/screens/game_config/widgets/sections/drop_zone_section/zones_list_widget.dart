import 'package:flutter/material.dart';

/// Widget hiển thị danh sách các drop zone
class ZonesListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> zones;
  final int currentEditingIndex;
  final Function(int) onEditZone;
  final Function(int) onDeleteZone;
  final VoidCallback onAddNew;

  const ZonesListWidget({
    Key? key,
    required this.zones,
    required this.currentEditingIndex,
    required this.onEditZone,
    required this.onDeleteZone,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Danh sách Drop Zones',
                    style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm Zone'),
                  onPressed: onAddNew,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (zones.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'Chưa có drop zone nào. Nhấn "Thêm Zone" để tạo mới.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: zones.length,
                itemBuilder: (context, index) {
                  final zone = zones[index];
                  final isSelected = index == currentEditingIndex;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    color: isSelected ? Colors.blue.shade50 : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: isSelected
                          ? BorderSide(color: Colors.blue.shade300, width: 2)
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      title: Text('Zone ID: ${zone['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Position: (${zone['position']['x']}, ${zone['position']['y']})'),
                          Text(
                              'Size: ${zone['size']['x']} x ${zone['size']['y']}'),
                          if (zone.containsKey('style'))
                            Text(
                                'Border Radius: ${zone['style']['borderRadius']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => onEditZone(index),
                            tooltip: 'Chỉnh sửa',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onDeleteZone(index),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
