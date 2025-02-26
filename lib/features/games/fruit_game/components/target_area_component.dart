import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TargetAreaComponent extends PositionComponent {
  bool isActive = true;
  late RectangleComponent background;
  late TextComponent labelComponent;

  TargetAreaComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Add background rectangle
    background = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
    add(background);

    // Add label
    labelComponent = TextComponent(
      text: 'Drop Here',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    labelComponent.position = Vector2(
      size.x / 2 - labelComponent.size.x / 2,
      size.y / 2 - labelComponent.size.y / 2,
    );
    add(labelComponent);
  }

  bool containsPoint(Vector2 point) {
    return point.x >= position.x &&
        point.x <= position.x + size.x &&
        point.y >= position.y &&
        point.y <= position.y + size.y;
  }

  void showSuccess() {
    background.paint.color = Colors.green.withOpacity(0.3);
    background.paint.style = PaintingStyle.fill;
  }

  void showError() {
    background.paint.color = Colors.red.withOpacity(0.3);
    background.paint.style = PaintingStyle.fill;
  }

  void reset() {
    background.paint.color = Colors.white.withOpacity(0.3);
    background.paint.style = PaintingStyle.stroke;
  }
}
