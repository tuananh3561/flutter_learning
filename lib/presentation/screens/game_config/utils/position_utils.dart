import 'package:flutter/material.dart';

/// Tiện ích xử lý vị trí và kích thước cho GameConfigEditor
class PositionUtils {
  /// Chuyển đổi giá trị chuỗi thành double
  ///
  /// Có khả năng xử lý biểu thức với gameSize
  /// Ví dụ: "gameSize.y / 2" -> một phần của gameSize.y
  static dynamic parsePositionValue(String value,
      {Size? gameSize, double defaultValue = 0.0}) {
    if (value.isEmpty) {
      return defaultValue;
    }

    // Xử lý biểu thức với gameSize
    if (value.contains('gameSize') && gameSize != null) {
      // Thay thế gameSize.x và gameSize.y bằng giá trị thực tế
      String evaluableString = value
          .replaceAll('gameSize.x', gameSize.width.toString())
          .replaceAll('gameSize.y', gameSize.height.toString());

      // Nếu là biểu thức phức tạp, trả về nguyên chuỗi để xử lý ở runtime
      if (evaluableString.contains('+') ||
          evaluableString.contains('-') ||
          evaluableString.contains('*') ||
          evaluableString.contains('/')) {
        return value;
      }

      // Nếu đã thay thế xong, thử chuyển đổi thành số
      try {
        return double.parse(evaluableString);
      } catch (e) {
        // Nếu không thể parse, giữ nguyên chuỗi
        return value;
      }
    }

    // Xử lý giá trị số thông thường
    try {
      // Nếu có dấu chấm, chuyển đổi thành double
      if (value.contains('.')) {
        return double.parse(value);
      }
      // Nếu không có dấu chấm, chuyển đổi thành int
      else {
        return int.parse(value);
      }
    } catch (e) {
      // Nếu không thể parse, trả về giá trị mặc định
      return defaultValue;
    }
  }

  /// Tạo map vị trí từ giá trị x, y
  static Map<String, dynamic> createPositionMap(dynamic x, dynamic y) {
    return {
      'x': x,
      'y': y,
    };
  }

  /// Tạo map kích thước từ giá trị width, height
  static Map<String, dynamic> createSizeMap(dynamic width, dynamic height) {
    return {
      'x': width,
      'y': height,
    };
  }

  /// Format map vị trí hoặc kích thước thành chuỗi dễ đọc
  static String formatPositionOrSize(Map<String, dynamic>? map) {
    if (map == null) return '(0, 0)';

    return '(${map['x']}, ${map['y']})';
  }

  /// Kiểm tra giá trị chuỗi có phải là biểu thức vị trí hợp lệ
  static bool isValidPositionExpression(String value) {
    // Kiểm tra empty hoặc null
    if (value.isEmpty) return false;

    // Nếu chứa gameSize, coi là hợp lệ
    if (value.contains('gameSize')) return true;

    // Kiểm tra nếu là số
    return double.tryParse(value) != null;
  }
}
