import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'octopus.dart';
import '../managers/sound_manager.dart';
import 'cat.dart'; // Import Cat

class WaterBalloon extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final Vector2 targetPosition;
  double speed = 200;

  WaterBalloon({required this.targetPosition})
      : super(size: Vector2(16, 16), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('water_balloon.png');
    // position = gameRef.findByType<Cat>()!.position.clone(); // Sửa ở đây
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    Vector2 direction = targetPosition - position;
    direction.normalize();

    position += direction * speed * dt;

    if (position.distanceTo(targetPosition) < 5) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Octopus) {
      other.hit();
      // gameRef.findByType<SoundManager>()?.playHitSound(); // Sửa ở đây
      removeFromParent();
    }
  }
}
