// File: lib/game/components/audio_button.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../models/fruit.dart';
import 'dashed_rounded_rectangle.dart';

class AudioButton extends PositionComponent with TapCallbacks, DragCallbacks {
  final Fruit fruit;
  final Function() onTap;

  late SpriteComponent speakerIcon;
  late DashedRoundedRectangleComponent background;
  late Vector2 originalPosition;

  Color buttonColor = Colors.white;
  bool isDragging = false;
  Vector2 dragDelta = Vector2.zero();
  Vector2 startPosition = Vector2.zero();

  AudioButton({
    required this.fruit,
    required super.position,
    required super.size,
    required this.onTap,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    originalPosition = position.clone();

    // Create rectangle background
    background = DashedRoundedRectangleComponent(
      size: size,
      borderRadius: 16,
      dashSpace: -1,
      dashStrokeWidth: 2,
      backgroundColor: buttonColor,
    );
    background.anchor = Anchor.center;
    add(background);

    // Create speaker icon
    speakerIcon = SpriteComponent(
      sprite: await Sprite.load('speaker_icon.png'),
      size: Vector2.all(size.x * 0.4),
      paint: Paint()
        ..colorFilter = const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
    );
    speakerIcon.anchor = Anchor.center;
    add(speakerIcon);

    // Set the anchor for the whole component
    anchor = Anchor.center;
  }

  // Set the button color
  void setColor(Color color) {
    buttonColor = color;
    // background.paint = Paint()..color = color;
  }

  // Handle tap
  @override
  bool onTapDown(TapDownEvent event) {
    onTap();
    // Update background with new color
    background.backgroundPaint.color = buttonColor = Colors.blue;
    speakerIcon.paint.colorFilter =
        const ColorFilter.mode(Colors.white, BlendMode.srcIn);
    return false;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    // Update background with new color
    background.backgroundPaint.color = buttonColor = Colors.white;
    speakerIcon.paint.colorFilter =
        const ColorFilter.mode(Colors.blue, BlendMode.srcIn);
    return false;
  }

  // Handle drag start
  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    isDragging = true;
    startPosition = position.clone();
    dragDelta = event.canvasPosition - position;
    // Update background with new color
    background.backgroundPaint.color = buttonColor = Colors.blue;
    speakerIcon.paint.colorFilter =
        const ColorFilter.mode(Colors.white, BlendMode.srcIn);
    return false;
  }

  // Handle drag update
  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (isDragging) {
      position = event.canvasPosition - dragDelta;
    }
    // position += event.canvasPosition;
    return false;
  }

  // Handle drag end
  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    isDragging = false;
    // scale = Vector2.all(1.0); // Return to original scale
    // priority = 0; // Reset priority
    // Update background with new color
    background.backgroundPaint.color = buttonColor = Colors.white;
    speakerIcon.paint.colorFilter =
        const ColorFilter.mode(Colors.blue, BlendMode.srcIn);
    return false;
  }

  // Handle drag cancel
  @override
  bool onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    isDragging = false;
    // returnToOriginalPosition();
    // scale = Vector2.all(1.0);
    // position = startPosition;
    // priority = 0;
    return true;
  }

  // Return to original position with animation
  void returnToOriginalPosition() {
    // Add a move effect to return to the original position
    add(
      MoveToEffect(
        originalPosition,
        EffectController(duration: 0.3, curve: Curves.easeOutCubic),
      ),
    );
  }
}
