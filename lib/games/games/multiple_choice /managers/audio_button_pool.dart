import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../components/audio_button_component.dart';
import 'game_config_manager.dart';

/// Class quản lý pool của AudioButtonComponent
/// Tái sử dụng các component thay vì tạo mới mỗi lần
class AudioButtonPool {
  /// Kích thước tối đa của pool
  final int _maxPoolSize;

  /// Số lượng component đã được tạo
  int _totalCreated = 0;

  /// GameConfigManager - quản lý cấu hình game
  final GameConfigManager _configManager = GameConfigManager();

  /// Vị trí của các button
  List<Vector2>? _buttonPositions;

  /// Constructor
  AudioButtonPool({int maxPoolSize = 10}) : _maxPoolSize = maxPoolSize;

  /// Khởi tạo pool
  Future<void> initialize(Vector2 gameSize, int numberOfButtons) async {
    // Đảm bảo config đã được tải
    if (!_configManager.isLoaded) {
      await _configManager.loadConfig();
    }

    // Lấy vị trí cho các button từ cấu hình
    _buttonPositions =
        _configManager.getButtonPositions(gameSize, numberOfButtons);

    if (kDebugMode) {
      print(
          'AudioButtonPool initialized with ${_buttonPositions?.length ?? 0} button positions');
    }
  }

  /// Lấy một AudioButtonComponent mới tại index cụ thể
  AudioButtonComponent getAtIndex({
    required int index,
    required String text,
    required String audioFile,
    required Vector2 size,
    Function(String)? onDrop,
    Function()? onTap,
  }) {
    // Xác định vị trí dựa trên index và cấu hình
    final position = _buttonPositions != null &&
            index < _buttonPositions!.length
        ? _buttonPositions![index].clone()
        : Vector2(
            720, 100 + index * 120); // Vị trí mặc định nếu không có cấu hình

    return get(
      text: text,
      audioFile: audioFile,
      position: position,
      size: size,
      onDrop: onDrop,
      onTap: onTap,
    );
  }

  /// Lấy một AudioButtonComponent mới
  AudioButtonComponent get({
    required String text,
    required String audioFile,
    required Vector2 position,
    required Vector2 size,
    Function(String)? onDrop,
    Function()? onTap,
  }) {
    // Tạo button với cài đặt mặc định
    // AudioButtonComponent không có tham số tùy chỉnh cho màu sắc và viền,
    // nên chúng ta chỉ có thể sử dụng các tham số có sẵn
    final button = AudioButtonComponent(
      text: text,
      audioFile: audioFile,
      position: position,
      size: size,
      onDrop: onDrop,
      onTap: onTap,
    );

    _totalCreated++;

    if (kDebugMode) {
      print('Created new AudioButtonComponent, total created: $_totalCreated');
    }

    // Nếu đã load cấu hình, khi nào vào game cần cập nhật AudioButtonComponent
    // để có thể tùy chỉnh màu sắc và hiệu ứng theo cấu hình trong game_config.json
    if (_configManager.isLoaded) {
      if (kDebugMode) {
        print(
            'Audio button config loaded successfully, but customization is limited');
      }
    }

    return button;
  }

  /// "Giải phóng" button, trên thực tế đây chỉ là reset state
  void release(AudioButtonComponent button) {
    // Reset button về trạng thái ban đầu
    button.reset();

    if (kDebugMode) {
      print('Reset AudioButtonComponent');
    }
  }

  /// Cleanup khi không cần nữa
  void dispose() {
    _buttonPositions = null;

    if (kDebugMode) {
      print('AudioButtonPool disposed, total created: $_totalCreated');
    }
  }
}
