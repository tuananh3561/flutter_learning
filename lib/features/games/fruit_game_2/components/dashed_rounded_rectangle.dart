import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DashedRoundedRectangleComponent extends PositionComponent {
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double dashStrokeWidth;
  final Paint borderPaint;
  final Paint backgroundPaint;

  DashedRoundedRectangleComponent({
    required Vector2 size,
    this.borderRadius = 12.0,
    this.dashWidth = 10,
    this.dashSpace = 0,
    this.dashStrokeWidth = 2,
    Color borderColor = Colors.blue,
    Color backgroundColor = Colors.white,
  })  : borderPaint = Paint()
          ..color = borderColor
          ..strokeWidth = dashStrokeWidth
          ..style = PaintingStyle.stroke,
        backgroundPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill,
        super(size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final RRect rRect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(borderRadius),
    );

    // Vẽ nền trắng trước
    canvas.drawRRect(rRect, backgroundPaint);

    // Tạo viền nét đứt nếu dashSpace > 0, ngược lại vẽ viền nét liền
    if (dashSpace > 0) {
      final Path path = Path()..addRRect(rRect);
      final Path dashedPath = Path();
      double distance = 0;
      for (PathMetric pathMetric in path.computeMetrics()) {
        while (distance < pathMetric.length) {
          dashedPath.addPath(
            pathMetric.extractPath(distance, distance + dashWidth),
            Offset.zero,
          );
          distance += dashWidth + dashSpace;
        }
      }

      // Vẽ viền nét đứt
      canvas.drawPath(dashedPath, borderPaint);
    } else if (dashSpace < 0) {
      // Vẽ viền nét liền
      canvas.drawRRect(rRect, borderPaint);
    }
  }
}
