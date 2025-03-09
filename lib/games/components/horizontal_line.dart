import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends Component {
  final double y;
  final Paint paint;

  HorizontalLine({
    required this.y,
    Color color = Colors.white,
    double strokeWidth = 2.0,
  }) : paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth;

  @override
  void render(Canvas canvas) {
    final game = findGame() as FlameGame;
    canvas.drawLine(
      Offset(0, y),
      Offset(game.size.x, y),
      paint,
    );
  }
}
