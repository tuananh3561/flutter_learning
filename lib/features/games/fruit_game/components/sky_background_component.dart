import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SkyBackground extends Component {
  final Paint skyPaint = Paint()
    ..color = const Color(0xFF87CEEB); // Sky blue color
  final List<CloudComponent> clouds = [];
  final Random random = Random();
  final double gameWidth;
  final double gameHeight;

  SkyBackground({required this.gameWidth, required this.gameHeight});

  @override
  Future<void> onLoad() async {
    // Create initial clouds
    for (int i = 0; i < 5; i++) {
      final cloud = CloudComponent(
        position: Vector2(
          random.nextDouble() * gameWidth,
          50 + random.nextDouble() * (gameHeight / 2),
        ),
        size: Vector2(
            80 + random.nextDouble() * 40, 40 + random.nextDouble() * 20),
        speed: 10 + random.nextDouble() * 10,
      );
      clouds.add(cloud);
      add(cloud);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameWidth, gameHeight),
      skyPaint,
    );
  }
}

class CloudComponent extends PositionComponent {
  final Paint cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
  final double speed;

  CloudComponent({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(size.x * 0.2, size.y * 0.5)
      ..quadraticBezierTo(
          size.x * 0.3, size.y * 0.2, size.x * 0.5, size.y * 0.3)
      ..quadraticBezierTo(
          size.x * 0.7, size.y * 0.1, size.x * 0.8, size.y * 0.4)
      ..quadraticBezierTo(size.x, size.y * 0.5, size.x * 0.9, size.y * 0.7)
      ..quadraticBezierTo(
          size.x * 0.7, size.y * 0.9, size.x * 0.5, size.y * 0.8)
      ..quadraticBezierTo(size.x * 0.3, size.y, size.x * 0.2, size.y * 0.5)
      ..close();

    canvas.drawPath(path, cloudPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;

    // Reset cloud position when it moves off screen
    final parentComponent = parent as SkyBackground;
    if (position.x > parentComponent.gameWidth) {
      position.x = -size.x;
      position.y =
          50 + Random().nextDouble() * (parentComponent.gameHeight / 2);
    }
  }
}
