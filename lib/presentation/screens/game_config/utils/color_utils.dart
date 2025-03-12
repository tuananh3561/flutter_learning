import 'package:flutter/material.dart';

/// Tiện ích xử lý màu sắc cho GameConfigEditor
class ColorUtils {
  /// Chuyển đổi từ chuỗi hex sang đối tượng Color
  ///
  /// Hỗ trợ các định dạng:
  /// - #RRGGBB
  /// - #AARRGGBB
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();

    // Xóa dấu # nếu có
    hexString = hexString.replaceFirst('#', '');

    // Thêm alpha nếu cần
    if (hexString.length == 6) {
      buffer.write('ff');
      buffer.write(hexString);
      return Color(int.parse(buffer.toString(), radix: 16));
    } else if (hexString.length == 8) {
      return Color(int.parse(hexString, radix: 16));
    } else if (hexString.length == 3) {
      // Hỗ trợ định dạng rút gọn #RGB
      String r = hexString[0];
      String g = hexString[1];
      String b = hexString[2];
      buffer.write('ff');
      buffer.write('$r$r$g$g$b$b');
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    // Màu mặc định nếu không hợp lệ
    return Colors.black;
  }

  /// Chuyển đổi từ Color sang chuỗi hex
  ///
  /// [withAlpha] - Nếu true, bao gồm cả alpha trong chuỗi hex
  /// [withHashSign] - Nếu true, thêm dấu # vào đầu chuỗi
  /// [uppercase] - Nếu true, chuyển đổi chuỗi thành chữ hoa
  static String toHex(
    Color color, {
    bool withAlpha = true,
    bool withHashSign = true,
    bool uppercase = false,
  }) {
    String hexString;

    if (withAlpha) {
      hexString = color.value.toRadixString(16).padLeft(8, '0');
    } else {
      hexString = color.value.toRadixString(16).padLeft(8, '0').substring(2);
    }

    if (uppercase) {
      hexString = hexString.toUpperCase();
    }

    return withHashSign ? '#$hexString' : hexString;
  }

  /// Tạo một màu với độ trong suốt được chỉ định
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Làm tối một màu với hệ số được chỉ định
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Làm sáng một màu với hệ số được chỉ định
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
