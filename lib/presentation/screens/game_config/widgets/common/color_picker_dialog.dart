import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Tiện ích đa dụng để chọn màu sắc với dialog
/// Được thiết kế để tái sử dụng trong các section khác nhau của GameConfigEditor
class ColorPickerDialog {
  /// Hiển thị dialog chọn màu và trả về màu đã chọn thông qua callback
  ///
  /// [context] - BuildContext để hiển thị dialog
  /// [initialColor] - Màu ban đầu được chọn
  /// [onColorChanged] - Callback được gọi khi người dùng chọn một màu
  /// [title] - Tiêu đề của dialog, mặc định là 'Chọn màu'
  /// [showOpacitySelector] - Có hiển thị thanh chọn độ trong suốt hay không
  /// [width] - Chiều rộng của color picker (nếu null, sẽ tự điều chỉnh)
  /// [height] - Chiều cao của color picker (nếu null, sẽ tự điều chỉnh)
  static Future<void> show(
    BuildContext context,
    Color initialColor,
    Function(Color) onColorChanged, {
    String title = 'Chọn màu',
    bool showOpacitySelector = false,
    double? width,
    double? height,
  }) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: height,
              child: ColorPicker(
                pickerColor: initialColor,
                onColorChanged: (color) {
                  selectedColor = color;
                },
                pickerAreaHeightPercent: 0.8,
                enableAlpha: showOpacitySelector,
                labelTypes: const [
                  ColorLabelType.rgb,
                  ColorLabelType.hex,
                ],
                displayThumbColor: true,
              ),
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
