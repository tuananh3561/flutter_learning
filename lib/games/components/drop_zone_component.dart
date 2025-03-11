import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'rounded_rect_painter_component.dart';
import 'rounded_rect_border_painter_component.dart';

/// Component đại diện cho vùng drop
class DropZoneComponent extends PositionComponent {
  /// ID của zone
  final int id;

  /// Callback khi có nút được thả vào zone
  final Function(int zoneId)? onDropped;

  /// Constructor
  DropZoneComponent({
    required this.id,
    required Vector2 position,
    required Vector2 size,
    this.onDropped,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Thêm hình nền cho zone với viền bo tròn
    final roundedRectPainter = RoundedRectPainter(
      color: Colors.grey.withOpacity(0.15),
      borderRadius: 15.0,
    );

    add(CustomPainterComponent(
      painter: roundedRectPainter,
      position: Vector2.zero(),
      size: size,
    ));

    // Thêm border với viền bo tròn và nét đứt
    final borderPainter = RoundedRectBorderPainter(
      color: Colors.black.withOpacity(0.3),
      borderRadius: 15.0,
      strokeWidth: 2,
      dashWidth: 6.0,
      dashSpace: 4.0,
      isDashed: true,
    );

    add(CustomPainterComponent(
      painter: borderPainter,
      position: Vector2.zero(),
      size: size,
    ));
  }
}
