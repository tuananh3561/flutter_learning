import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/foundation.dart';

import '../../../engine/resource_manager.dart';

/// Controller untuk mengelola animasi máy bay
class AirplaneAnimationController {
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

  /// Tham chiếu đến ResourceManager
  final ResourceManager _resourceManager;

  /// Cache SpineComponent để tái sử dụng
  SpineComponent? _cachedAirplaneComponent;

  /// Constructor
  AirplaneAnimationController(this._resourceManager);

  /// Khởi tạo controller
  Future<void> initialize() async {
    // Preload spine data nếu cần
    if (kDebugMode) {
      print('AirplaneAnimationController initialized');
    }
  }

  /// Lấy SpineComponent máy bay
  Future<SpineComponent> getAirplaneComponent({
    required Vector2 position,
    required Vector2 scale,
  }) async {
    if (_cachedAirplaneComponent != null) {
      // Sử dụng lại component đã tạo
      _cachedAirplaneComponent!.position = position;
      _cachedAirplaneComponent!.scale = scale;
      return _cachedAirplaneComponent!;
    }

    // Tạo mới nếu chưa có
    final component = await _resourceManager.getSpineComponent(
      'airplane',
      skeletonFile: _skeletonFile,
      atlasFile: _atlasFile,
      defaultAnimation: _animations[0],
      loop: false,
    );

    component.position = position;
    component.scale = scale;

    _cachedAirplaneComponent = component;
    return component;
  }

  /// Phát animation intro
  Future<void> playIntroAnimation(SpineComponent component) async {
    try {
      component.animationState.setAnimationByName(0, _animations[0], false);
      _currentIndex = 0;

      // Phát âm thanh nếu cần
      await Future.delayed(const Duration(seconds: 3));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing intro animation: $e');
      }
    }
  }

  /// Phát animation kết thúc
  Future<void> playEndingAnimation(
    SpineComponent? component, {
    Function? onComplete,
  }) async {
    try {
      if (component == null) return;

      // Phát animation máy bay bay đi
      component.animationState.setAnimationByName(0, _animations[3], false);

      // Phát âm thanh tia sét
      _resourceManager
          .playSoundEffect('../../assets/Multiple Choice/SFX tia sét.mp3');

      // Phát âm thanh Max nhảy lên máy bay
      _resourceManager.playSoundEffect(
        '../../assets/Multiple Choice/SFX Max nhảy lên máy bay.mp3',
      );

      // Đợi một chút
      await Future.delayed(const Duration(seconds: 2));

      // Phát âm thanh máy bay bay đi
      _resourceManager.playSoundEffect(
        '../../assets/Multiple Choice/SFX máy bay bay đi.mp3',
      );

      // Phát âm thanh yeah
      _resourceManager
          .playSoundEffect('../../assets/Multiple Choice/SFX yeah.mp3');

      if (onComplete != null) {
        onComplete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing ending animation: $e');
      }
    }
  }

  /// Phát animation tiếp theo theo vòng lặp
  Future<void> playNextAnimation(SpineComponent? component) async {
    try {
      if (component == null) return;

      // Tăng index và đảm bảo nằm trong khoảng hợp lệ
      _currentIndex = (_currentIndex + 1) % _animations.length;

      // Phát animation
      component.animationState
          .setAnimationByName(0, _animations[_currentIndex], false);

      // Phát âm thanh ghép bộ phận
      _resourceManager
          .playSoundEffect('../../assets/Multiple Choice/SFX ghép bộ phận.wav');

      // Đợi animation hoàn thành
      await Future.delayed(const Duration(seconds: 3));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing next animation: $e');
      }
    }
  }

  /// Giải phóng tài nguyên
  void dispose() {
    _cachedAirplaneComponent = null;
    if (kDebugMode) {
      print('AirplaneAnimationController disposed');
    }
  }
}
