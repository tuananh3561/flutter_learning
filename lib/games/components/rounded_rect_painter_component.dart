import 'package:flutter/material.dart';

/// Painter để vẽ hình chữ nhật bo góc
class RoundedRectPainter extends CustomPainter {
  Color color;
  final double borderRadius;
  final Listenable? listenable;

  RoundedRectPainter({
    required this.color,
    required this.borderRadius,
    Listenable? repaint,
  })  : listenable = repaint,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Nếu listenable là ValueNotifier<Color>, sử dụng giá trị đó cho màu sắc
    if (listenable is ValueNotifier<Color>) {
      color = (listenable as ValueNotifier<Color>).value;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(RoundedRectPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius;
  }
}
