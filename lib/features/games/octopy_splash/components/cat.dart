import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'octopus.dart';
import 'water_balloon.dart';
import '../levels/base_level.dart';

class Cat extends SpriteAnimationComponent with HasGameRef {
  late BaseLevel currentLevel;

  Cat({required this.currentLevel})
      : super(size: Vector2(50, 50), position: Vector2(100, 300)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('cat/idle.png'),
      srcSize: Vector2(32, 32),
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.2,
      to: 4,
    );
  }

  void throwBall() {
    // Lấy *tất cả* Octopus, sau đó lấy phần tử đầu tiên (nếu có)
    final octopus =
        currentLevel.children.query<Octopus>().firstOrNull; // Sửa ở đây
    if (octopus != null) {
      final balloon = WaterBalloon(targetPosition: octopus.position);
      currentLevel.add(balloon);
      currentLevel.soundManager.playThrowSound();
    }
  }
}
