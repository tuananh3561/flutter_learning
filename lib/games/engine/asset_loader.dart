import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/audio_service.dart';

/// Kiểu tài nguyên game
enum AssetType {
  /// Hình ảnh
  image,

  /// Âm thanh nền
  backgroundAudio,

  /// Hiệu ứng âm thanh
  soundEffect,

  /// Âm thanh từ vựng
  wordAudio,

  /// Spine animation
  spine,
}

/// Thông tin về tài nguyên game
class GameAsset {
  /// Đường dẫn tới tài nguyên
  final String path;

  /// Kiểu tài nguyên
  final AssetType type;

  /// Constructor
  GameAsset({required this.path, required this.type});
}

/// Quản lý trạng thái tải tài nguyên
class AssetLoadingStatus extends ChangeNotifier {
  /// Tổng số tài nguyên cần tải
  int _totalAssets = 0;

  /// Số tài nguyên đã tải xong
  int _loadedAssets = 0;

  /// Có lỗi không
  bool _hasError = false;

  /// Thông báo lỗi
  String _errorMessage = '';

  /// Đã tải xong chưa
  bool _isComplete = false;

  /// Lấy tổng số tài nguyên
  int get totalAssets => _totalAssets;

  /// Lấy số tài nguyên đã tải
  int get loadedAssets => _loadedAssets;

  /// Lấy phần trăm tiến độ
  double get progress => _totalAssets > 0 ? _loadedAssets / _totalAssets : 0.0;

  /// Kiểm tra có lỗi không
  bool get hasError => _hasError;

  /// Lấy thông báo lỗi
  String get errorMessage => _errorMessage;

  /// Kiểm tra đã tải xong chưa
  bool get isComplete => _isComplete;

  /// Thiết lập tổng số tài nguyên
  void setTotalAssets(int count) {
    _totalAssets = count;
    notifyListeners();
  }

  /// Tăng số tài nguyên đã tải
  void incrementLoaded() {
    _loadedAssets++;
    notifyListeners();
  }

  /// Đặt lỗi
  void setError(String message) {
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  /// Đánh dấu đã tải xong
  void setComplete() {
    _isComplete = true;
    notifyListeners();
  }

  /// Reset trạng thái
  void reset() {
    _totalAssets = 0;
    _loadedAssets = 0;
    _hasError = false;
    _errorMessage = '';
    _isComplete = false;
    notifyListeners();
  }
}

/// Handles loading of game assets
class GameAssetLoader {
  /// Audio service instance
  static final AudioService _audioService = AudioService();

  /// Đối tượng theo dõi trạng thái tải
  static final AssetLoadingStatus loadingStatus = AssetLoadingStatus();

  /// Danh sách tài nguyên Spine đã tải
  static final Map<String, SpineComponent> _cachedSpineComponents = {};

  /// Load a single image
  static Future<void> loadImage(String path) async {
    try {
      await Flame.images.load(path);
      loadingStatus.incrementLoaded();
    } catch (e) {
      print('Error loading image $path: $e');
      loadingStatus.setError('Không thể tải hình ảnh: $path');
      rethrow;
    }
  }

  /// Load a list of images
  static Future<void> loadImages(List<String> paths) async {
    for (final path in paths) {
      await loadImage(path);
    }
  }

  /// Load a spine component
  static Future<SpineComponent> loadSpineComponent(
    String key, {
    required String skeletonFile,
    required String atlasFile,
    Vector2? position,
    Vector2? scale,
  }) async {
    try {
      // Check if already cached
      if (_cachedSpineComponents.containsKey(key)) {
        loadingStatus.incrementLoaded();
        return _cachedSpineComponents[key]!;
      }

      // Load new component
      final component = await SpineComponent.fromAssets(
        skeletonFile: skeletonFile,
        atlasFile: atlasFile,
        position: position ?? Vector2.zero(),
        anchor: Anchor.center,
      );

      if (scale != null) {
        component.scale = scale;
      }

      // Cache the component
      _cachedSpineComponents[key] = component;
      loadingStatus.incrementLoaded();

      return component;
    } catch (e) {
      print('Error loading spine component $key: $e');
      loadingStatus.setError('Không thể tải Spine animation: $key');
      rethrow;
    }
  }

  /// Get a cached spine component
  static SpineComponent? getCachedSpineComponent(String key) {
    return _cachedSpineComponents[key];
  }

  /// Load assets by type
  static Future<void> loadAssets(List<GameAsset> assets) async {
    try {
      // Reset loading status
      loadingStatus.reset();
      loadingStatus.setTotalAssets(assets.length);

      // Tách các tài nguyên theo loại
      final List<String> images = [];
      final List<String> backgroundTracks = [];
      final List<String> soundEffects = [];
      final List<String> wordSounds = [];

      // Phân loại tài nguyên
      for (final asset in assets) {
        switch (asset.type) {
          case AssetType.image:
            images.add(asset.path);
            break;
          case AssetType.backgroundAudio:
            backgroundTracks.add(asset.path);
            break;
          case AssetType.soundEffect:
            soundEffects.add(asset.path);
            break;
          case AssetType.wordAudio:
            wordSounds.add(asset.path);
            break;
          case AssetType.spine:
            // Spine components được tải bằng phương thức riêng
            break;
        }
      }

      // Tải các hình ảnh
      for (final path in images) {
        await loadImage(path);
      }

      // Tải các âm thanh
      await _audioService.preloadGameAudio(
        backgroundTracks: backgroundTracks,
        soundEffects: soundEffects,
        wordSounds: wordSounds,
      );

      // Tăng số lượng tài nguyên đã tải
      for (int i = 0;
          i < backgroundTracks.length + soundEffects.length + wordSounds.length;
          i++) {
        loadingStatus.incrementLoaded();
      }

      // Đánh dấu đã tải xong
      loadingStatus.setComplete();
    } catch (e) {
      print('Error loading assets: $e');
      loadingStatus.setError('Không thể tải tài nguyên: $e');
      rethrow;
    }
  }

  /// Preload all Feed the Shark game assets
  static Future<void> preloadFeedTheSharkAssets() async {
    final assets = [
      // Images
      GameAsset(
          path: '../../assets/Feed the Shark/background.png',
          type: AssetType.image),

      // Background Music
      GameAsset(
          path: '../../assets/Feed the Shark/Nhạc BG.mp3',
          type: AssetType.backgroundAudio),

      // Sound Effects
      GameAsset(
          path: '../../assets/Feed the Shark/SFX cá mập.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX Click.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX đúng.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX guiding.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX hết lượt 1.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX sai.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX Unclick.mp3',
          type: AssetType.soundEffect),
      GameAsset(
          path: '../../assets/Feed the Shark/SFX Win.mp3',
          type: AssetType.soundEffect),

      // Word Audio
      GameAsset(
          path: '../../assets/audio/word/dog.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/cat.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/fish.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/bird.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/duck.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/pig.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/cow.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/sheep.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/horse.mp3', type: AssetType.wordAudio),
      GameAsset(
          path: '../../assets/audio/word/frog.mp3', type: AssetType.wordAudio),
    ];

    // Load assets
    await loadAssets(assets);

    // Load Spine components
    await loadSpineComponent('shark',
        skeletonFile: 'assets/Feed the Shark/shark/skeleton.json',
        atlasFile: 'assets/Feed the Shark/shark/skeleton_hdr.atlas.txt');

    // Load fish spine components
    for (int i = 1; i <= 3; i++) {
      await loadSpineComponent('ca_nho_$i',
          skeletonFile: 'assets/Feed the Shark/ca nho $i/skeleton.json',
          atlasFile: 'assets/Feed the Shark/ca nho $i/skeleton_hdr.atlas.txt');

      await loadSpineComponent('ca_to_$i',
          skeletonFile: 'assets/Feed the Shark/ca to $i/skeleton.json',
          atlasFile: 'assets/Feed the Shark/ca to $i/skeleton_hdr.atlas.txt');
    }
  }

  /// Giải phóng tài nguyên
  static Future<void> dispose() async {
    try {
      // Giải phóng âm thanh
      await _audioService.dispose();

      // Giải phóng spine components
      _cachedSpineComponents.clear();

      // Reset trạng thái tải
      loadingStatus.reset();
    } catch (e) {
      print('Error disposing GameAssetLoader: $e');
    }
  }
}
