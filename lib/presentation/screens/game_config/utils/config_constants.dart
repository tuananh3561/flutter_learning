import 'package:flutter/material.dart';

/// Các hằng số chung được sử dụng trong GameConfigEditor
class ConfigConstants {
  // Kích thước mặc định
  static const double defaultWidth = 1024.0;
  static const double defaultHeight = 576.0;

  // Các giá trị mặc định cho các section
  static const Map<String, dynamic> defaultBoxQuestion = {
    'position': {'x': 460.0, 'y': 'gameSize.y / 3'},
    'size': {'x': 220.0, 'y': 360.0},
    'backgroundColor': '#FFFFFF',
    'borderRadius': 15.0,
  };

  static const Map<String, dynamic> defaultTargetImage = {
    'type': 'image',
    'path': '',
    'position': {'x': 500.0, 'y': 'gameSize.y / 2'},
    'size': {'x': 150.0, 'y': 150.0},
    'borderColor': '#80808080',
    'priority': 80,
    'showTextOnCorrect': true,
    'textStyle': {
      'color': '#00C853',
      'fontSize': 24,
      'fontWeight': 'bold',
    },
  };

  static const Map<String, dynamic> defaultDropZone = {
    'enabled': true,
    'zones': [],
  };

  static const Map<String, dynamic> defaultDropZoneItem = {
    'position': {'x': 520.0, 'y': 'gameSize.y / 2 + 25.0'},
    'size': {'x': 100.0, 'y': 100.0},
    'style': {
      'backgroundColor': '#50E3F2FD',
      'borderColor': '#2196F3',
      'borderRadius': 15.0,
      'borderDashed': true
    }
  };

  static const Map<String, dynamic> defaultAnswerButtons = {
    'audioButtons': {
      'layout': {
        'useIndividualPositions': true,
        'startPosition': {'x': 500.0, 'y': 100.0},
        'spacing': 100.0,
        'buttonSize': {'x': 60.0, 'y': 60.0},
        'buttonPositions': [],
      },
      'style': {
        'backgroundColor': '#FFFFFF',
        'borderColor': '#2196F3',
        'correctColor': '#4CAF50',
        'incorrectColor': '#F44336',
      }
    }
  };

  // Các giá trị cho padding và margin
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const EdgeInsets contentPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sectionPadding = EdgeInsets.only(bottom: 16.0);

  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;

  // Durations for animations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Game asset paths
  static const String defaultAssetsPath = 'assets/';
  static const String spineAssetsPath = 'assets/Feed the Shark/';

  // Form strings
  static const String requiredFieldMessage = 'Trường này không được để trống';
  static const String invalidNumberMessage = 'Giá trị phải là số';
  static const String updatePreviewButtonText = 'Cập nhật Preview';
  static const String saveButtonText = 'Lưu';

  // Màu sắc chung
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orangeAccent;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.amber;
  static const Color disabledColor = Colors.grey;

  // Box Shadow
  static const List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];
}
