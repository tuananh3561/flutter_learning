import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import '../components/audio_button_component.dart';

/// Class untuk mengelola pool của AudioButtonComponent
/// Tái sử dụng các component thay vì tạo mới mỗi lần
class AudioButtonPool {
  /// Kích thước tối đa của pool
  final int _maxPoolSize;

  /// Số lượng component đã được tạo
  int _totalCreated = 0;

  /// Constructor
  AudioButtonPool({int maxPoolSize = 10}) : _maxPoolSize = maxPoolSize;

  /// Lấy một AudioButtonComponent mới
  AudioButtonComponent get({
    required String text,
    required String audioFile,
    required Vector2 position,
    required Vector2 size,
    Function(String)? onDrop,
    Function()? onTap,
  }) {
    // Do các thuộc tính của AudioButtonComponent là final,
    // chúng ta không thể tái sử dụng chúng. Thay vào đó, chúng ta sẽ tạo mới.
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
    if (kDebugMode) {
      print('AudioButtonPool disposed, total created: $_totalCreated');
    }
  }
}
