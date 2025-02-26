import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';

class Octopus extends SpriteAnimationComponent with HasGameRef {
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _hitAnimation;

  Octopus() : super(size: Vector2(80, 80), position: Vector2(250, 200)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Load idle animation
    final idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('octopus/idle.png'),
      srcSize: Vector2(48, 48),
    );
    _idleAnimation =
        idleSpriteSheet.createAnimation(row: 0, stepTime: 0.3, to: 4);

    // Load hit animation
    final hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('octopus/hit.png'),
      srcSize: Vector2(48, 48),
    );
    _hitAnimation = hitSpriteSheet.createAnimation(
        row: 0, stepTime: 0.1, to: 4, loop: false);

    animation = _idleAnimation; // Bắt đầu với idle

    add(
      MoveEffect.by(
        Vector2(0, -20),
        EffectController(
          duration: 1.5,
          reverseDuration: 1.5,
          infinite: true,
        ),
      ),
    );
  }

  void hit() {
    // animation = _hitAnimation;
    // _hitAnimation.onComplete = () {
    //   removeFromParent();
    // };
  }
}
