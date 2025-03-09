import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/audio_service.dart';
import 'asset_loader.dart';
import 'spine_factory.dart';

/// Trạng thái tải tài nguyên
enum ResourceLoadingState {
  /// Chưa bắt đầu tải
  notStarted,

  /// Đang tải
  loading,

  /// Tải xong
  completed,

  /// Có lỗi khi tải
  error,
}

/// Quản lý tải và truy cập tất cả tài nguyên cho game
class ResourceManager {
  /// Singleton instance
  static final ResourceManager _instance = ResourceManager._internal();

  /// Factory constructor
  factory ResourceManager() {
    return _instance;
  }

  /// Private constructor
  ResourceManager._internal();

  /// Audio service
  final AudioService _audioService = AudioService();

  /// Spine factory
  final SpineComponentFactory _spineFactory = SpineComponentFactory();

  /// Trạng thái đang tải
  ResourceLoadingState _loadingState = ResourceLoadingState.notStarted;

  /// Phần trăm đã tải
  double _loadingProgress = 0.0;

  /// Thông báo lỗi
  String _errorMessage = '';

  /// Danh sách người nhận thông báo khi tải xong
  final List<VoidCallback> _onCompleteCallbacks = [];

  /// Danh sách các spine components đã được preload
  final Map<String, bool> _preloadedSpineComponents = {};

  /// Trạng thái đang tải
  ResourceLoadingState get loadingState => _loadingState;

  /// Phần trăm đã tải
  double get loadingProgress => _loadingProgress;

  /// Thông báo lỗi
  String get errorMessage => _errorMessage;

  /// Kiểm tra đã tải xong chưa
  bool get isLoaded => _loadingState == ResourceLoadingState.completed;

  /// Đăng ký callback khi tải xong
  void addOnCompleteCallback(VoidCallback callback) {
    _onCompleteCallbacks.add(callback);

    // Gọi ngay nếu đã tải xong
    if (isLoaded) {
      callback();
    }
  }

  /// Phát âm thanh nền
  Future<void> playBackgroundMusic(String fileName) async {
    await _audioService.playBackgroundMusic(fileName);
  }

  /// Phát hiệu ứng âm thanh
  Future<void> playSoundEffect(String fileName) async {
    await _audioService.playSoundEffect(fileName);
  }

  /// Phát âm thanh từ vựng
  Future<void> playWordSound(String fileName) async {
    await _audioService.playWordSound(fileName);
  }

  /// Dừng âm thanh nền
  Future<void> stopBackgroundMusic() async {
    await _audioService.stopBackgroundMusic();
  }

  /// Tạm dừng âm thanh nền
  Future<void> pauseBackgroundMusic() async {
    await _audioService.pauseBackgroundMusic();
  }

  /// Tiếp tục phát âm thanh nền
  Future<void> resumeBackgroundMusic() async {
    await _audioService.resumeBackgroundMusic();
  }

  /// Lấy Spine component từ cache
  Future<SpineComponent> getSpineComponent(
    String key, {
    required String skeletonFile,
    required String atlasFile,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    Anchor? anchor,
    String? defaultAnimation,
    bool loop = true,
  }) async {
    return _spineFactory.getComponent(
      key,
      skeletonFile: skeletonFile,
      atlasFile: atlasFile,
      position: position,
      size: size,
      scale: scale,
      anchor: anchor,
      defaultAnimation: defaultAnimation,
      loop: loop,
    );
  }

  /// Trả lại Spine component vào cache
  void releaseSpineComponent(String key, SpineComponent component) {
    _spineFactory.releaseComponent(key, component);
  }

  /// Tải tài nguyên cho một game cụ thể
  Future<void> loadResources(String gameName) async {
    // Reset trạng thái
    _loadingState = ResourceLoadingState.loading;
    _loadingProgress = 0.0;
    _errorMessage = '';

    try {
      // Xác định game để tải tài nguyên phù hợp
      switch (gameName.toLowerCase()) {
        case 'feedtheshark':
          await _loadFeedTheSharkResources();
          break;
        // Thêm các game khác ở đây
        default:
          throw Exception('Unknown game: $gameName');
      }

      // Đánh dấu đã tải xong
      _loadingState = ResourceLoadingState.completed;
      _loadingProgress = 1.0;

      // Gọi các callbacks
      for (final callback in _onCompleteCallbacks) {
        callback();
      }
    } catch (e) {
      _loadingState = ResourceLoadingState.error;
      _errorMessage = e.toString();
      print('Error loading resources: $e');
    }
  }

  /// Tải tài nguyên cho game Feed the Shark
  Future<void> _loadFeedTheSharkResources() async {
    try {
      // Sử dụng GameAssetLoader để tải assets
      final assetLoadingStatus = GameAssetLoader.loadingStatus;

      // Thiết lập listener để cập nhật tiến độ
      assetLoadingStatus.addListener(() {
        if (assetLoadingStatus.totalAssets > 0) {
          _loadingProgress = assetLoadingStatus.progress;
        }

        if (assetLoadingStatus.hasError) {
          _errorMessage = assetLoadingStatus.errorMessage;
          _loadingState = ResourceLoadingState.error;
        }
      });

      // Tải tài nguyên
      await GameAssetLoader.preloadFeedTheSharkAssets();

      // Preload các Spine components cho cá
      await _preloadFishSpineComponents();

      // Preload spine component cho cá mập
      await _preloadSharkSpineComponent();

      // Đảm bảo tiến độ là 100%
      _loadingProgress = 1.0;
    } catch (e) {
      _loadingState = ResourceLoadingState.error;
      _errorMessage = e.toString();
      print('Error loading Feed the Shark resources: $e');
      rethrow;
    }
  }

  /// Preload các Spine components cho cá
  Future<void> _preloadFishSpineComponents() async {
    try {
      // Chuẩn bị các thông tin về file
      final spineFiles = <String, Map<String, String>>{};

      // Không preload lại nếu đã tải
      if (_preloadedSpineComponents['fish'] == true) {
        return;
      }

      // Cá nhỏ
      for (int i = 1; i <= 3; i++) {
        final key = 'ca nho $i';
        spineFiles[key] = {
          'skeleton': 'assets/Feed the Shark/$key/skeleton.json',
          'atlas': 'assets/Feed the Shark/$key/skeleton_hdr.atlas.txt',
        };
      }

      // Cá to
      for (int i = 1; i <= 3; i++) {
        final key = 'ca to $i';
        spineFiles[key] = {
          'skeleton': 'assets/Feed the Shark/$key/skeleton.json',
          'atlas': 'assets/Feed the Shark/$key/skeleton_hdr.atlas.txt',
        };
      }

      // Preload components
      await _spineFactory.preloadComponents(spineFiles, countPerType: 2);

      // Đánh dấu đã preload
      _preloadedSpineComponents['fish'] = true;
    } catch (e) {
      print('Error preloading fish spine components: $e');
      // Không ném ngoại lệ ra ngoài để tiếp tục preload các thành phần khác
    }
  }

  /// Preload spine component cho cá mập
  Future<void> _preloadSharkSpineComponent() async {
    try {
      // Không preload lại nếu đã tải
      if (_preloadedSpineComponents['shark'] == true) {
        return;
      }

      // Preload shark component
      final key = 'shark';
      await _spineFactory.getComponent(
        key,
        skeletonFile: 'assets/Feed the Shark/shark/skeleton.json',
        atlasFile: 'assets/Feed the Shark/shark/skeleton_hdr.atlas.txt',
        defaultAnimation: 'Idie',
        loop: true,
      );

      // Đánh dấu đã preload
      _preloadedSpineComponents['shark'] = true;
    } catch (e) {
      print('Error preloading shark spine component: $e');
      // Không ném ngoại lệ ra ngoài để tiếp tục preload các thành phần khác
    }
  }

  /// Giải phóng tài nguyên
  Future<void> dispose() async {
    await _audioService.dispose();
    _spineFactory.clearAllCaches();

    _loadingState = ResourceLoadingState.notStarted;
    _loadingProgress = 0.0;
    _errorMessage = '';
    _onCompleteCallbacks.clear();
    _preloadedSpineComponents.clear();
  }

  /// Bỏ đăng ký callback
  void removeOnCompleteCallback(VoidCallback callback) {
    _onCompleteCallbacks.remove(callback);
  }
}
