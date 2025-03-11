import 'package:flutter/foundation.dart';
import 'game_config_manager.dart';

/// Class untuk mengelola daftar kosakata
class VocabularyRepository {
  /// Danh sách từ vựng
  List<Map<String, dynamic>> _vocabularyList = [];

  /// GameConfigManager
  final GameConfigManager _configManager = GameConfigManager();

  /// Khởi tạo repository, tải dữ liệu từ config
  Future<void> initialize() async {
    // Đảm bảo config đã được tải
    if (!_configManager.isLoaded) {
      await _configManager.loadConfig();
    }

    // Lấy từ vựng từ config
    _vocabularyList = _configManager.vocabularyList;

    if (kDebugMode) {
      print(
          'VocabularyRepository initialized with ${_vocabularyList.length} words');
    }
  }

  /// Lấy danh sách từ vựng
  List<Map<String, dynamic>> getVocabularyList() {
    return List.from(_vocabularyList);
  }

  /// Lấy từ vựng theo text
  Map<String, dynamic>? getVocabularyByText(String text) {
    try {
      return _vocabularyList.firstWhere((vocab) => vocab['text'] == text);
    } catch (e) {
      return null;
    }
  }
}
