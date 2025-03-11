import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Class quản lý cấu hình game từ file game_config.json
class GameConfigManager {
  /// Singleton instance
  static final GameConfigManager _instance = GameConfigManager._internal();

  /// Factory constructor
  factory GameConfigManager() {
    return _instance;
  }

  /// Private constructor
  GameConfigManager._internal();

  /// Đường dẫn đến file cấu hình
  final String _configPath = 'assets/Multiple Choice/game_config.json';

  /// Dữ liệu cấu hình đã được parse
  Map<String, dynamic>? _configData;

  /// Map lưu trữ các giá trị Vector2 đã được tính toán (cache)
  final Map<String, Vector2> _vectorCache = {};

  /// Map lưu trữ các giá trị Color đã được tính toán (cache)
  final Map<String, Color> _colorCache = {};

  /// Map lưu trữ các danh sách vị trí button đã được tính toán (cache)
  final Map<String, List<Vector2>> _buttonPositionsCache = {};

  /// Kích thước màn hình game hiện tại
  Vector2? _gameSize;

  /// Kiểm tra đã tải xong chưa
  bool get isLoaded => _configData != null;

  /// Cấu hình mặc định
  final Map<String, dynamic> _defaultConfig = {
    "gameInfo": {
      "name": "Multiple Choice",
      "description": "Trò chơi nối từ vựng với hình ảnh thông qua âm thanh",
      "version": "1.0.0"
    },
    "gameSettings": {
      "requiredRounds": 5,
      "numberOfChoices": 3,
      "typeGame": "Drop",
      "backgroundConfigPath": "assets/Multiple Choice/background_config.json",
      "timeLimit": 0,
      "scorePerCorrectAnswer": 10
    },
    "airplaneComponent": {
      "skeletonFile": "assets/Multiple Choice/May bay/Multiple choice_v2.json",
      "atlasFile":
          "assets/Multiple Choice/May bay/Multiple choice_v2_hdr.atlas.txt",
      "defaultAnimation": "1.0 - Lap canh to [Phone]",
      "position": {"x": "gameSize.x / 2 + 30", "y": "gameSize.y / 2 - 10"},
      "scale": {"x": 0.18, "y": 0.18},
      "animations": [
        {
          "name": "1.0 - Lap canh to [Phone]",
          "duration": 3,
          "loop": false,
          "soundEffect": "../../assets/Multiple Choice/SFX_ghep_bo_phan.wav"
        },
        {
          "name": "2.0 - Lap canh nho va duoi [Phone]",
          "duration": 3,
          "loop": false,
          "soundEffect": "../../assets/Multiple Choice/SFX_ghep_bo_phan.wav"
        },
        {
          "name": "3.0 - Lap canh quat [Phone]",
          "duration": 3,
          "loop": false,
          "soundEffect": "../../assets/Multiple Choice/SFX_ghep_bo_phan.wav"
        },
        {
          "name": "4.0 - Max len may bay [Phone]",
          "duration": 3,
          "loop": false,
          "soundEffect": "../../assets/Multiple Choice/SFX_ghep_bo_phan.wav"
        }
      ],
      "roundAnimationMapping": {
        "intro": "1.0 - Lap canh to [Phone]",
        "round1": "1.0 - Lap canh to [Phone]",
        "round2": "2.0 - Lap canh nho va duoi [Phone]",
        "round3": "3.0 - Lap canh quat [Phone]",
        "round4": "4.0 - Max len may bay [Phone]",
        "round5": "1.0 - Lap canh to [Phone]",
        "ending": "4.0 - Max len may bay [Phone]"
      },
      "endingAnimation": {
        "sequence": [
          {
            "animation": "4.0 - Max len may bay [Phone]",
            "soundEffect": "../../assets/Multiple Choice/SFX tia sét.mp3",
            "delay": 0
          },
          {
            "soundEffect":
                "../../assets/Multiple Choice/SFX Max nhảy lên máy bay.mp3",
            "delay": 0.5
          },
          {
            "soundEffect":
                "../../assets/Multiple Choice/SFX máy bay bay đi.mp3",
            "delay": 2
          },
          {
            "soundEffect": "../../assets/Multiple Choice/SFX yeah.mp3",
            "delay": 0.5
          }
        ]
      }
    },
    "questionConfig": {
      "boxQuestion": {
        "position": {"x": 460.0, "y": "gameSize.y / 2 - 180.0"},
        "size": {"x": 220.0, "y": 360.0},
        "backgroundColor": "#FFFFFF",
        "borderRadius": 15.0
      },
      "targetImage": {
        "type": "image",
        "path": "../../assets/images/word/{text}.png",
        "position": {"x": 500.0, "y": "gameSize.y / 2 - 150.0"},
        "size": {"x": 150.0, "y": 150.0},
        "borderColor": "#CCCCCC80",
        "priority": 80,
        "showTextOnCorrect": true,
        "textStyle": {"color": "#4CAF50", "fontSize": 24, "fontWeight": "bold"}
      }
    },
    "answerConfig": {
      "audioButtons": {
        "layout": {
          "useIndividualPositions": false,
          "startPosition": {"x": 720.0, "y": "gameSize.y / 2 - 120.0"},
          "buttonSize": {"x": 100.0, "y": 100.0},
          "spacing": 20.0,
          "buttonPositions": [
            {"x": 720.0, "y": "gameSize.y / 2 - 120.0"},
            {"x": 720.0, "y": "gameSize.y / 2"},
            {"x": 720.0, "y": "gameSize.y / 2 + 120.0"}
          ]
        },
        "style": {
          "backgroundColor": "#FFFFFF",
          "borderColor": "#2196F3",
          "borderWidth": 2.0,
          "borderRadius": 15.0,
          "correctColor": "#4CAF50",
          "incorrectColor": "#F44336"
        },
        "iconSettings": {
          "path": "../../assets/Multiple Choice/audio_icon.png",
          "size": {"x": 40.0, "y": 40.0},
          "position": "center",
          "animateOnHover": true
        },
        "soundEffects": {
          "click": "../../assets/Multiple Choice/SFX click.wav",
          "correct": "../../assets/Multiple Choice/SFX đúng.mp3",
          "wrong": "../../assets/Multiple Choice/SFX sai.wav"
        }
      }
    },
    "dropZoneConfig": {
      "enabled": true,
      "zones": [
        {
          "id": 1,
          "position": {"x": 520.0, "y": "gameSize.y / 2 + 25.0"},
          "size": {"x": 100.0, "y": 100.0},
          "style": {
            "backgroundColor": "#E3F2FD50",
            "borderColor": "#2196F3",
            "borderRadius": 15.0,
            "borderDashed": true
          }
        }
      ]
    },
    "soundConfig": {
      "backgroundMusic": "../../assets/Multiple Choice/background_music.mp3",
      "effectSounds": {
        "click": "../../assets/Multiple Choice/SFX click.wav",
        "correct": "../../assets/Multiple Choice/SFX đúng.mp3",
        "wrong": "../../assets/Multiple Choice/SFX sai.wav",
        "match": "../../assets/Multiple Choice/SFX_ghep_bo_phan.wav",
        "lightning": "../../assets/Multiple Choice/SFX tia sét.mp3",
        "planeLeave": "../../assets/Multiple Choice/SFX máy bay bay đi.mp3",
        "yeah": "../../assets/Multiple Choice/SFX yeah.mp3",
        "maxJump": "../../assets/Multiple Choice/SFX Max nhảy lên máy bay.mp3"
      },
      "wordSounds": "../../assets/audio/word/{text}.mp3"
    },
    "vocabulary": {
      "source": "internal",
      "data": [
        {
          "text": "bird",
          "audio": "../../assets/audio/word/bird.mp3",
          "image": "../../assets/images/word/bird.png"
        },
        {
          "text": "cat",
          "audio": "../../assets/audio/word/cat.mp3",
          "image": "../../assets/images/word/cat.png"
        },
        {
          "text": "dog",
          "audio": "../../assets/audio/word/dog.mp3",
          "image": "../../assets/images/word/dog.png"
        },
        {
          "text": "duck",
          "audio": "../../assets/audio/word/duck.mp3",
          "image": "../../assets/images/word/duck.png"
        },
        {
          "text": "pig",
          "audio": "../../assets/audio/word/pig.mp3",
          "image": "../../assets/images/word/pig.png"
        },
        {
          "text": "cow",
          "audio": "../../assets/audio/word/cow.mp3",
          "image": "../../assets/images/word/cow.png"
        },
        {
          "text": "sheep",
          "audio": "../../assets/audio/word/sheep.mp3",
          "image": "../../assets/images/word/sheep.png"
        },
        {
          "text": "horse",
          "audio": "../../assets/audio/word/horse.mp3",
          "image": "../../assets/images/word/horse.png"
        },
        {
          "text": "frog",
          "audio": "../../assets/audio/word/frog.mp3",
          "image": "../../assets/images/word/frog.png"
        }
      ]
    }
  };

  /// Tải file cấu hình
  Future<void> loadConfig({Vector2? gameSize}) async {
    try {
      if (gameSize != null) {
        _gameSize = gameSize;
      }

      final String jsonString = await rootBundle.loadString(_configPath);
      _configData = json.decode(jsonString);

      if (kDebugMode) {
        print('Game config loaded successfully from file');
      }
    } catch (e) {
      // Sử dụng cấu hình mặc định nếu không load được từ file
      _configData = _defaultConfig;

      if (kDebugMode) {
        print('Error loading game config: $e');
        print('Using default config instead');
      }
    }
  }

  /// Lấy và merge cấu hình từ file và mặc định
  Map<String, dynamic> _getConfig(String key) {
    _configData ??= _defaultConfig;
    try {
      var result = _configData![key];
      if (result == null) {
        if (kDebugMode) {
          print('Config key "$key" not found, using default');
        }
        return _defaultConfig[key];
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting config for "$key": $e');
        print('Falling back to default config');
      }
      return _defaultConfig[key];
    }
  }

  /// Lấy thông tin cơ bản về game
  Map<String, dynamic> get gameInfo {
    return _getConfig('gameInfo');
  }

  /// Lấy cài đặt game
  Map<String, dynamic> get gameSettings {
    return _getConfig('gameSettings');
  }

  /// Lấy cấu hình máy bay
  Map<String, dynamic> get airplaneConfig {
    return _getConfig('airplaneComponent');
  }

  /// Lấy cấu hình câu hỏi
  Map<String, dynamic> get questionConfig {
    return _getConfig('questionConfig');
  }

  /// Lấy cấu hình đáp án
  Map<String, dynamic> get answerConfig {
    return _getConfig('answerConfig');
  }

  /// Lấy cấu hình khu vực thả
  Map<String, dynamic> get dropZoneConfig {
    return _getConfig('dropZoneConfig');
  }

  /// Lấy cấu hình âm thanh
  Map<String, dynamic> get soundConfig {
    return _getConfig('soundConfig');
  }

  /// Lấy cấu hình UI
  Map<String, dynamic> get uiConfig {
    return _getConfig('ui');
  }

  /// Lấy danh sách từ vựng
  List<Map<String, dynamic>> get vocabularyList {
    try {
      final vocabData = _getConfig('vocabulary');
      if (vocabData['source'] == 'internal' && vocabData['data'] != null) {
        return List<Map<String, dynamic>>.from(vocabData['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting vocabulary list: $e');
        print('Falling back to default vocabulary');
      }
    }

    // Fallback to default vocabulary
    final defaultVocab = _defaultConfig['vocabulary'];
    return List<Map<String, dynamic>>.from(defaultVocab['data']);
  }

  /// Đọc Vector2 từ JSON với caching để tối ưu hiệu suất
  Vector2 readVector2(Map<String, dynamic> json, Vector2 gameSize) {
    try {
      // Tạo cache key từ dữ liệu json và gameSize
      final String jsonString = json.toString();
      final String cacheKey = '$jsonString-${gameSize.x}-${gameSize.y}';

      // Kiểm tra cache
      if (_vectorCache.containsKey(cacheKey)) {
        return _vectorCache[cacheKey]!.clone();
      }

      // Nếu chưa có trong cache, tính toán và lưu cache
      final x = parseValue(json['x'].toString(), gameSize: gameSize);
      final y = parseValue(json['y'].toString(), gameSize: gameSize);
      final result = Vector2(x.toDouble(), y.toDouble());

      // Cache kết quả
      _vectorCache[cacheKey] = result.clone();

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error reading Vector2: $e');
        print('Falling back to center position');
      }
      // Fallback to center position
      return Vector2(gameSize.x / 2, gameSize.y / 2);
    }
  }

  /// Đọc Color từ JSON với caching để tối ưu hiệu suất
  Color readColor(String? hexColor) {
    try {
      if (hexColor == null || hexColor.isEmpty) {
        return Colors.white;
      }

      // Kiểm tra cache
      if (_colorCache.containsKey(hexColor)) {
        return _colorCache[hexColor]!;
      }

      // Nếu chưa có trong cache, tính toán và lưu cache
      // Remove # if present
      final processedHexColor = hexColor.replaceAll('#', '');

      // Parse base color
      int value = int.parse(processedHexColor.substring(0, 6), radix: 16);

      // Parse alpha if present
      double opacity = 1.0;
      if (processedHexColor.length == 8) {
        opacity =
            int.parse(processedHexColor.substring(6, 8), radix: 16) / 255.0;
      }

      // Create color with opacity
      final result = Color(value).withOpacity(opacity);

      // Cache kết quả
      _colorCache[hexColor] = result;

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error reading color: $e');
        print('Falling back to white color');
      }
      // Fallback to white color
      return Colors.white;
    }
  }

  /// Lấy vị trí cho từng button dựa vào cấu hình và cache
  List<Vector2> getButtonPositions(Vector2 gameSize, int numberOfButtons) {
    // Cập nhật gameSize
    _gameSize = gameSize;

    // Tạo cache key
    final String cacheKey = '${gameSize.x}-${gameSize.y}-$numberOfButtons';

    // Kiểm tra cache
    if (_buttonPositionsCache.containsKey(cacheKey)) {
      return _buttonPositionsCache[cacheKey]!.map((v) => v.clone()).toList();
    }

    // Nếu chưa có trong cache, tính toán và lưu cache
    try {
      final answerConfig = _getConfig('answerConfig');
      final layout = answerConfig['audioButtons']['layout'];
      final useIndividualPositions = layout['useIndividualPositions'] ?? false;
      final buttonSize = readVector2(layout['buttonSize'], gameSize);

      List<Vector2> positions = [];

      if (useIndividualPositions && layout['buttonPositions'] != null) {
        // Sử dụng vị trí riêng biệt cho từng button
        final buttonPositions =
            List<Map<String, dynamic>>.from(layout['buttonPositions']);

        // Đảm bảo số lượng vị trí phù hợp với số lượng button cần tạo
        for (int i = 0; i < numberOfButtons; i++) {
          if (i < buttonPositions.length) {
            final pos = buttonPositions[i];
            positions.add(readVector2(pos, gameSize));
          } else {
            // Nếu không đủ vị trí được cấu hình, tính toán vị trí tự động
            final lastPos = positions.last;
            positions.add(Vector2(
              lastPos.x,
              lastPos.y +
                  buttonSize.y +
                  parseValue(layout['spacing'].toString(), gameSize: gameSize)
                      .toDouble(),
            ));
          }
        }
      } else {
        // Sử dụng vị trí bắt đầu và khoảng cách
        final startPos = readVector2(layout['startPosition'], gameSize);
        final spacing =
            parseValue(layout['spacing'].toString(), gameSize: gameSize)
                .toDouble();

        for (int i = 0; i < numberOfButtons; i++) {
          positions.add(Vector2(
            startPos.x,
            startPos.y + i * (buttonSize.y + spacing),
          ));
        }
      }

      // Cache kết quả
      _buttonPositionsCache[cacheKey] =
          positions.map((v) => v.clone()).toList();

      return positions;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting button positions: $e');
        print('Falling back to default positions');
      }

      // Vị trí mặc định nếu có lỗi
      final positions = <Vector2>[];
      for (int i = 0; i < numberOfButtons; i++) {
        positions.add(Vector2(
          720.0,
          (gameSize.y / 2 - 120.0) + i * 120.0,
        ));
      }

      // Cache kết quả mặc định
      _buttonPositionsCache[cacheKey] =
          positions.map((v) => v.clone()).toList();

      return positions;
    }
  }

  /// Parse giá trị từ chuỗi thành số hoặc giữ nguyên chuỗi
  dynamic parseValue(String? value, {required Vector2 gameSize}) {
    if (value == null) return null;

    // Nếu là chuỗi biểu thức toán học với gameSize
    if (value.contains('gameSize')) {
      // Thay thế gameSize.x và gameSize.y bằng giá trị thực
      final expr = value
          .replaceAll('gameSize.x', gameSize.x.toString())
          .replaceAll('gameSize.y', gameSize.y.toString());
      try {
        // Đơn giản hóa: chỉ hỗ trợ cộng, trừ, nhân, chia và dấu ngoặc
        // Trong thực tế, cần sử dụng thư viện parse biểu thức phức tạp hơn
        return _evaluateExpression(expr);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing expression "$expr": $e');
        }
        return value; // Trả về nguyên chuỗi nếu không parse được
      }
    }

    // Thử parse thành số
    try {
      return double.parse(value);
    } catch (e) {
      return value; // Giữ nguyên chuỗi nếu không phải số
    }
  }

  /// Đánh giá biểu thức đơn giản
  double _evaluateExpression(String expr) {
    expr = expr.trim();

    try {
      // Thử parse trực tiếp nếu là số
      try {
        return double.parse(expr);
      } catch (_) {
        // Không phải số đơn giản, tiếp tục xử lý
      }

      // Trường hợp cụ thể: chia một số một nửa và trừ 180
      if (expr.contains('/') &&
          expr.contains('-') &&
          expr.contains('2 - 180')) {
        final parts = expr.split('/');
        if (parts.length == 2) {
          final leftNumber = double.parse(parts[0].trim());
          final rightParts = parts[1].split('-');
          if (rightParts.length == 2 && rightParts[0].trim() == '2') {
            return leftNumber / 2 - double.parse(rightParts[1].trim());
          }
        }
      }

      // Bước 1: Xử lý phép cộng và trừ (ưu tiên thấp)
      for (int i = expr.length - 1; i >= 0; i--) {
        // Chỉ xử lý toán tử không nằm trong ngoặc và không phải là số mũ (E)
        if (expr[i] == '+' && (i == 0 || expr[i - 1] != 'E')) {
          // Tách biểu thức thành 2 phần: trái và phải của toán tử
          String leftPart = expr.substring(0, i).trim();
          String rightPart = expr.substring(i + 1).trim();

          // Đệ quy tính toán giá trị của mỗi phần và cộng chúng lại
          return _evaluateExpression(leftPart) + _evaluateExpression(rightPart);
        } else if (expr[i] == '-' &&
            i > 0 &&
            expr[i - 1] != 'E' &&
            !isOperator(expr[i - 1])) {
          // Tách biểu thức thành 2 phần
          String leftPart = expr.substring(0, i).trim();
          String rightPart = expr.substring(i + 1).trim();

          // Đệ quy tính toán mỗi phần và trừ chúng
          return _evaluateExpression(leftPart) - _evaluateExpression(rightPart);
        }
      }

      // Bước 2: Xử lý phép nhân và chia (ưu tiên cao)
      for (int i = expr.length - 1; i >= 0; i--) {
        if (expr[i] == '*') {
          String leftPart = expr.substring(0, i).trim();
          String rightPart = expr.substring(i + 1).trim();
          return _evaluateExpression(leftPart) * _evaluateExpression(rightPart);
        } else if (expr[i] == '/') {
          String leftPart = expr.substring(0, i).trim();
          String rightPart = expr.substring(i + 1).trim();
          double rightValue = _evaluateExpression(rightPart);
          if (rightValue == 0) {
            throw Exception('Divide by zero');
          }
          return _evaluateExpression(leftPart) / rightValue;
        }
      }

      // Nếu không có phép toán nào được xử lý, thử parse lại
      return double.parse(expr);
    } catch (e) {
      if (kDebugMode) {
        print('Error evaluating expression "$expr": $e');
      }
      // Giá trị mặc định để tránh crash
      return 0;
    }
  }

  /// Kiểm tra xem ký tự có phải là toán tử không
  bool isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/';
  }

  /// Xóa tất cả cache
  void clearCache() {
    _vectorCache.clear();
    _colorCache.clear();
    _buttonPositionsCache.clear();
    if (kDebugMode) {
      print('Cache cleared');
    }
  }

  /// Dispose
  void dispose() {
    clearCache();
    _configData = null;
    _gameSize = null;
    if (kDebugMode) {
      print('GameConfigManager disposed');
    }
  }

  /// Lấy Vector2 đã tính toán trước hoặc tính mới nếu cần
  Vector2 getVector2(String category, String key, Map<String, dynamic> json,
      Vector2 gameSize) {
    // Tạo cache key từ category, key và gameSize
    final String cacheKey = '$category.$key-${gameSize.x}-${gameSize.y}';

    // Kiểm tra cache
    if (_vectorCache.containsKey(cacheKey)) {
      return _vectorCache[cacheKey]!.clone();
    }

    // Nếu không có trong cache, tính toán và lưu cache
    final result = readVector2(json, gameSize);

    // Cache kết quả
    _vectorCache[cacheKey] = result.clone();

    return result;
  }

  /// Lấy Color đã tính toán trước hoặc tính mới nếu cần
  Color getColor(String category, String key, String? hexColor) {
    // Tạo cache key từ category và key
    final String cacheKey = '$category.$key';

    // Kiểm tra cache
    if (_colorCache.containsKey(cacheKey)) {
      return _colorCache[cacheKey]!;
    }

    // Nếu không có trong cache, tính toán và lưu cache
    final result = readColor(hexColor);

    // Cache kết quả
    _colorCache[cacheKey] = result;

    return result;
  }
}
