import 'package:flutter/material.dart';
import 'decoration_item_tile.dart';
import 'decoration_dialog.dart';

/// Widget hiển thị và quản lý các phần tử trang trí
class DecorationSection extends StatefulWidget {
  final Map<String, dynamic> backgroundConfig;
  final Function(Map<String, dynamic>) onBackgroundConfigChanged;

  const DecorationSection({
    Key? key,
    required this.backgroundConfig,
    required this.onBackgroundConfigChanged,
  }) : super(key: key);

  @override
  State<DecorationSection> createState() => _DecorationSectionState();
}

class _DecorationSectionState extends State<DecorationSection> {
  // Hiển thị dialog thêm phần tử mới
  void _showAddDecorationDialog() {
    showDialog(
      context: context,
      builder: (context) => DecorationDialog(
        onSave: _addDecorationItem,
      ),
    );
  }

  // Hiển thị dialog sửa phần tử
  void _showEditDecorationDialog(Map<String, dynamic> item, int index) {
    showDialog(
      context: context,
      builder: (context) => DecorationDialog(
        decorationItem: Map<String, dynamic>.from(item),
        onSave: (editedItem) => _updateDecorationItem(editedItem, index),
      ),
    );
  }

  // Thêm phần tử trang trí mới
  void _addDecorationItem(Map<String, dynamic> newItem) {
    final updatedConfig = Map<String, dynamic>.from(widget.backgroundConfig);

    // Lấy danh sách decoration hoặc tạo mới nếu chưa có
    List<dynamic> decorationList = updatedConfig['decoration'] ?? [];

    // Thêm item mới
    decorationList.add(newItem);

    // Cập nhật cấu hình
    updatedConfig['decoration'] = decorationList;
    widget.onBackgroundConfigChanged(updatedConfig);
  }

  // Cập nhật phần tử trang trí
  void _updateDecorationItem(Map<String, dynamic> editedItem, int index) {
    final updatedConfig = Map<String, dynamic>.from(widget.backgroundConfig);

    // Lấy danh sách decoration
    List<dynamic> decorationList = updatedConfig['decoration'] ?? [];

    // Cập nhật item tại vị trí index
    if (index >= 0 && index < decorationList.length) {
      decorationList[index] = editedItem;

      // Cập nhật cấu hình
      updatedConfig['decoration'] = decorationList;
      widget.onBackgroundConfigChanged(updatedConfig);
    }
  }

  // Xóa phần tử trang trí
  void _removeDecorationItem(int index) {
    final updatedConfig = Map<String, dynamic>.from(widget.backgroundConfig);

    // Lấy danh sách decoration
    List<dynamic> decorationList = updatedConfig['decoration'] ?? [];

    // Xóa item tại vị trí index
    if (index >= 0 && index < decorationList.length) {
      decorationList.removeAt(index);

      // Cập nhật cấu hình
      updatedConfig['decoration'] = decorationList;
      widget.onBackgroundConfigChanged(updatedConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách decorations từ cấu hình
    final List<dynamic> decorations =
        widget.backgroundConfig['decoration'] ?? [];

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
                Text('Trang trí (Decoration)',
                    style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm phần tử'),
                  onPressed: _showAddDecorationDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hiển thị thông báo nếu không có phần tử nào
            if (decorations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chưa có phần tử trang trí nào. Hãy thêm phần tử mới.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              )
            else
              // Danh sách phần tử
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: decorations.length,
                itemBuilder: (context, index) {
                  final item = decorations[index];
                  return DecorationItemTile(
                    item: item,
                    onDelete: () => _removeDecorationItem(index),
                    onEdit: () => _showEditDecorationDialog(item, index),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
