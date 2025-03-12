import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Dialog hiển thị bộ chọn màu sắc
class ColorPickerDialog {
  /// Hiển thị dialog chọn màu sắc
  ///
  /// [context] Context để hiển thị dialog
  /// [initialColor] Màu ban đầu
  /// [onColorChanged] Callback khi màu được chọn
  static Future<void> show(
    BuildContext context,
    Color initialColor,
    Function(Color) onColorChanged,
  ) async {
    Color pickerColor = initialColor;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              showLabel: true,
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Chọn'),
              onPressed: () {
                onColorChanged(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị dialog chọn màu đơn giản với chỉ các màu cơ bản
  /// Phù hợp cho các trường hợp cần chọn nhanh từ một bảng màu đơn giản
  static Future<void> showBlockPicker(
    BuildContext context,
    Color initialColor,
    Function(Color) onColorChanged, {
    String title = 'Chọn màu nhanh',
  }) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
              availableColors: const [
                Colors.red,
                Colors.pink,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.blue,
                Colors.lightBlue,
                Colors.cyan,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
                Colors.brown,
                Colors.grey,
                Colors.blueGrey,
                Colors.black,
                Colors.white,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      onColorChanged(result);
    }
  }

  /// Hiển thị thanh trượt chọn màu, phù hợp cho việc chọn màu đơn sắc hoặc độ sáng/tối
  static Future<void> showSlidePicker(
    BuildContext context,
    Color initialColor,
    Function(Color) onColorChanged, {
    String title = 'Điều chỉnh màu',
  }) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: SlidePicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              enableAlpha: true,
              displayThumbColor: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Chọn'),
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      onColorChanged(result);
    }
  }

  /// Chuyển đổi Color sang chuỗi hex
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Chuyển đổi chuỗi hex sang Color
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
