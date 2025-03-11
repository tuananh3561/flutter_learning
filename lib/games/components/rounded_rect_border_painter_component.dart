import 'package:flutter/material.dart';

/// Painter để vẽ viền của hình chữ nhật bo góc
class RoundedRectBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;

  /// Độ dài của mỗi đoạn nét đứt
  final double dashWidth;

  /// Khoảng cách giữa các đoạn nét đứt
  final double dashSpace;

  /// Xác định có vẽ nét đứt hay không
  final bool isDashed;

  RoundedRectBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.isDashed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    if (!isDashed) {
      // Vẽ viền liền nếu không yêu cầu nét đứt
      canvas.drawRRect(rRect, paint);
      return;
    }

    // Tạo đường dẫn cho viền bo góc
    final path = Path()..addRRect(rRect);

    // Vẽ đường viền nét đứt
    final dashPath = Path();
    final pathMetrics = path.computeMetrics().toList();

    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        if (draw) {
          final extractPath =
              pathMetric.extractPath(distance, distance + length);
          dashPath.addPath(extractPath, Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(RoundedRectBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashWidth != oldDelegate.dashWidth ||
        dashSpace != oldDelegate.dashSpace ||
        isDashed != oldDelegate.isDashed;
  }
}
