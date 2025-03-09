import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';

import '../../components/fish_component.dart';
import '../../engine/resource_manager.dart';

/// Quản lý pool các đối tượng cá (FishComponent)
class FishPool {
  /// Singleton instance
  static final FishPool _instance = FishPool._internal();

  /// Factory constructor
  factory FishPool() {
    return _instance;
  }

  /// Private constructor
  FishPool._internal();

  /// Random generator
  final Random _random = Random();

  /// Resource Manager
  final ResourceManager _resourceManager = ResourceManager();

  /// Danh sách từ vựng
  final List<Map<String, dynamic>> _wordPool = [];

  /// Maximum number of active fish
  final int maxActiveFish = 12;

  /// Khởi tạo pool
  void initialize(List<Map<String, dynamic>> wordPool) {
    _wordPool.clear();
    _wordPool.addAll(wordPool);
  }

  /// Tạo một cá mới với cấu hình được chỉ định
  Future<FishComponent> createFish({
    required String text,
    required String audioFile,
    required int direction,
    required int lane,
    required double speed,
    required bool isCorrectAnswer,
    required Function(FishComponent) onTap,
    required Vector2 position,
  }) async {
    // Chọn loại cá dựa trên độ dài của text
    final fishSize = text.length > 8
        ? 'to'
        : _random.nextBool()
            ? 'nho'
            : 'to';
    final fishType = _random.nextInt(3) + 1;
    final spineKey = 'ca ${fishSize} $fishType';

    // Lấy SpineComponent từ ResourceManager
    final spineComponent = await _resourceManager.getSpineComponent(
      spineKey,
      skeletonFile: 'assets/Feed the Shark/$spineKey/skeleton.json',
      atlasFile: 'assets/Feed the Shark/$spineKey/skeleton_hdr.atlas.txt',
      defaultAnimation: 'Idie',
      loop: true,
      scale: Vector2(0.25, 0.25),
    );

    // Lật ngang nếu đi từ phải sang trái
    if (direction < 0 && !spineComponent.isFlippedHorizontally) {
      spineComponent.flipHorizontally();
    }

    // Tạo fish mới
    return FishComponent(
      text: text,
      audioFile: audioFile,
      direction: direction,
      lane: lane,
      speed: speed,
      isCorrectAnswer: isCorrectAnswer,
      onTap: onTap,
      position: position,
      size: spineComponent.size * 0.25,
      spineComponent: spineComponent,
    );
  }

  /// Tạo một cá ngẫu nhiên
  Future<FishComponent> createRandomFish({
    required int lane,
    required Vector2 gameSize,
    required String targetWord,
    required bool canBeCorrect,
    required Function(FishComponent) onTap,
  }) async {
    // Tính toán vị trí lane
    final laneY = (lane + 0.5) * (gameSize.y / 5);

    // Chọn ngẫu nhiên hướng di chuyển
    final direction = _random.nextBool() ? 1 : -1;

    // Vị trí bắt đầu dựa vào hướng di chuyển
    final startX = direction < 0 ? gameSize.x + 50.0 : -150.0;

    // Chọn ngẫu nhiên một từ vựng
    final wordData = _wordPool[_random.nextInt(_wordPool.length)];

    // Xác định xem cá này có phải là đáp án đúng không
    final isCorrect = canBeCorrect && wordData['text'] == targetWord;

    // Tạo fish mới
    return createFish(
      text: wordData['text'],
      audioFile: wordData['audio'],
      direction: direction,
      lane: lane,
      speed: 50 + _random.nextDouble() * 50, // 50-100
      isCorrectAnswer: isCorrect,
      onTap: onTap,
      position: Vector2(startX, laneY),
    );
  }

  /// Giải phóng spine component khi fish bị xóa
  void releaseSpineComponent(String key, SpineComponent spineComponent) {
    _resourceManager.releaseSpineComponent(key, spineComponent);
  }

  /// Giải phóng tất cả tài nguyên
  void clear() {
    // Không cần xóa cache vì ResourceManager sẽ quản lý
  }

  /// Preload spine components cho tất cả loại cá
  Future<void> preloadSpineComponents() async {
    // Không cần preload ở đây vì ResourceManager sẽ làm điều này
    // Tất cả việc preload sẽ được thực hiện trong ResourceManager
  }
}
