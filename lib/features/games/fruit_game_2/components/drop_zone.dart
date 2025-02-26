// File: lib/game/components/drop_zone.dart
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'audio_button.dart';
import 'dashed_rounded_rectangle.dart';

typedef OnAcceptCallback = bool Function(Component draggable);

class DropZone extends PositionComponent with CollisionCallbacks {
  final OnAcceptCallback onAccept;
  late RectangleComponent zoneVisual;
  late RectangleHitbox hitbox;

  // Visual states
  final Color defaultColor = Colors.grey.withOpacity(0.5);
  final Color hoverColor = Colors.blue.withOpacity(0.5);
  Color currentColor;

  DropZone({
    required super.position,
    required super.size,
    required this.onAccept,
  }) : currentColor = Colors.grey.withOpacity(0.5);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Create visual representation
    final zoneVisual = DashedRoundedRectangleComponent(
      size: size,
      borderRadius: 16,
      dashSpace: 5,
      backgroundColor: Colors.transparent,
    );

    zoneVisual.anchor = Anchor.center;
    add(zoneVisual);

    // Create hitbox for collision detection
    hitbox = RectangleHitbox(
      size: size,
    );
    hitbox.anchor = Anchor.center;
    add(hitbox);

    // Set the anchor for the whole component
    anchor = Anchor.center;
  }

  // Set the drop zone color
  void setColor(Color color) {
    currentColor = color;
    zoneVisual.paint = Paint()..color = color;
  }

  // Check if the component is an audio button
  bool _isDraggable(Component component) {
    return component is AudioButton;
  }

  // Handle collision start
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (_isDraggable(other)) {
      setColor(hoverColor);
    }
  }

  // Handle collision end
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (_isDraggable(other)) {
      setColor(defaultColor);
    }
  }

  // Validate a drop
  bool validateDrop(AudioButton button) {
    return onAccept(button);
  }
}
