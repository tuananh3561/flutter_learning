import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/foundation.dart';

import '../../../engine/resource_manager.dart';
import 'game_config_manager.dart';

/// Quản lý animation của máy bay
class AirplaneAnimationController {
  /// ResourceManager - quản lý tài nguyên
  final ResourceManager _resourceManager;

  /// GameConfigManager - quản lý cấu hình game
  final GameConfigManager _configManager = GameConfigManager();

  /// Cấu hình animation
  Map<String, dynamic>? _animationConfig;

  /// Danh sách các tên animation máy bay
  final List<String> _animations = [
    '1.0 - Lap canh to [Phone]',
    '2.0 - Lap canh nho va duoi [Phone]',
    '3.0 - Lap canh quat [Phone]',
    '4.0 - Max len may bay [Phone]',
  ];

  /// Đường dẫn tới file skeleton máy bay
  final String _skeletonFile =
      'assets/Multiple Choice/May bay/Multiple choice_v2.json';

  /// Đường dẫn tới file atlas máy bay
  final String _atlasFile =
      'assets/Multiple Choice/May bay/Multiple choice_v2_hdr.atlas.txt';

  /// Index animation hiện tại
  int _currentIndex = 0;

  /// Cache SpineComponent để tái sử dụng
  SpineComponent? _cachedAirplaneComponent;

  /// Constructor
  AirplaneAnimationController(this._resourceManager);

  /// Khởi tạo controller
  Future<void> initialize() async {
    // Đảm bảo config đã được tải
    if (!_configManager.isLoaded) {
      await _configManager.loadConfig();
    }

    // Lấy cấu hình máy bay
    _animationConfig = _configManager.airplaneConfig;

    if (kDebugMode) {
      print('AirplaneAnimationController initialized with config');
    }
  }

  /// Lấy component máy bay
  Future<SpineComponent> getAirplaneComponent({
    required Vector2 position,
    required Vector2 scale,
  }) async {
    if (_animationConfig == null) {
      throw Exception(
          'Animation configuration not loaded. Call initialize() first.');
    }

    final skeletonFile = _animationConfig!['skeletonFile'];
    final atlasFile = _animationConfig!['atlasFile'];
    final defaultAnimation = _animationConfig!['defaultAnimation'];

    return _resourceManager.getSpineComponent(
      'airplane',
      skeletonFile: skeletonFile,
      atlasFile: atlasFile,
      position: position,
      scale: scale,
      defaultAnimation: defaultAnimation,
      loop: false,
    );
  }

  /// Phát animation intro
  Future<void> playIntroAnimation(SpineComponent component) async {
    if (_animationConfig == null) return;

    try {
      final introAnim = _animationConfig!['roundAnimationMapping']['intro'];
      if (introAnim != null) {
        component.animationState.setAnimationByName(0, introAnim, false);
        await _playSoundEffect(introAnim);
        await _waitForAnimation(introAnim);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing intro animation: $e');
      }
    }
  }

  /// Phát animation cho lượt chơi tiếp theo
  Future<void> playNextAnimation(SpineComponent? component) async {
    if (component == null || _animationConfig == null) return;

    try {
      final currentRound = await _getCurrentRound();
      final animKey = 'round$currentRound';

      final animation = _animationConfig!['roundAnimationMapping'][animKey];
      if (animation != null) {
        component.animationState.setAnimationByName(0, animation, false);
        await _playSoundEffect(animation);
        await _waitForAnimation(animation);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing animation for round: $e');
      }
    }
  }

  /// Phát animation kết thúc
  Future<void> playEndingAnimation(
    SpineComponent? component, {
    Function? onComplete,
  }) async {
    if (component == null || _animationConfig == null) return;

    try {
      // Sử dụng animation kết thúc từ cấu hình
      final endingAnim = _animationConfig!['roundAnimationMapping']['ending'];
      if (endingAnim != null) {
        component.animationState.setAnimationByName(0, endingAnim, false);
        await _waitForAnimation(endingAnim);

        // Phát sequence âm thanh kết thúc
        final endingSequence = _animationConfig!['endingAnimation']['sequence'];
        if (endingSequence != null) {
          for (final item in endingSequence) {
            // Phát hiệu ứng âm thanh
            if (item['soundEffect'] != null) {
              _resourceManager.playSoundEffect(item['soundEffect']);
            }

            // Đợi theo delay
            if (item['delay'] != null) {
              await Future.delayed(
                  Duration(milliseconds: (item['delay'] * 1000).toInt()));
            }

            // Thay đổi animation nếu có
            if (item['animation'] != null && component.isMounted) {
              component.animationState
                  .setAnimationByName(0, item['animation'], false);
              await _waitForAnimation(item['animation']);
            }
          }
        }
      }

      if (onComplete != null) {
        onComplete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing ending animation: $e');
      }

      if (onComplete != null) {
        onComplete();
      }
    }
  }

  /// Lấy round hiện tại (giả lập)
  Future<int> _getCurrentRound() async {
    // Trong thực tế, đây sẽ được lấy từ game state
    // Hiện tại chỉ trả về số ngẫu nhiên 1-5 để test
    return Future.value(1);
  }

  /// Đợi animation kết thúc
  Future<void> _waitForAnimation(String animationName) async {
    // Tìm thông tin animation từ cấu hình
    final animationConfig = _findAnimationConfig(animationName);

    if (animationConfig != null && animationConfig['duration'] != null) {
      // Đợi theo thời lượng cấu hình
      await Future.delayed(Duration(seconds: animationConfig['duration']));
    } else {
      // Mặc định đợi 3 giây
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  /// Tìm thông tin animation từ cấu hình
  Map<String, dynamic>? _findAnimationConfig(String animationName) {
    if (_animationConfig == null) return null;

    try {
      final animations = _animationConfig!['animations'];
      if (animations == null) return null;

      for (final anim in animations) {
        if (anim['name'] == animationName) {
          return anim;
        }
      }
    } catch (e) {
      // Ignore
    }

    return null;
  }

  /// Phát hiệu ứng âm thanh cho animation
  Future<void> _playSoundEffect(String animationName) async {
    try {
      final animationConfig = _findAnimationConfig(animationName);
      if (animationConfig != null && animationConfig['soundEffect'] != null) {
        await _resourceManager.playSoundEffect(animationConfig['soundEffect']);
      }
    } catch (e) {
      // Ignore
    }
  }

  /// Giải phóng tài nguyên
  void dispose() {
    // Không có tài nguyên cần giải phóng
  }
}
