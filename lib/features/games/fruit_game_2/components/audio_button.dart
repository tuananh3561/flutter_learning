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
  late CircleComponent background;
  late Vector2 originalPosition;

  Color buttonColor = Colors.grey;
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

    // Create circular background
    // background = CircleComponent(
    //   radius: size.x / 2,
    //   paint: Paint()..color = buttonColor,
    // );

    final background = DashedRoundedRectangleComponent(
      size: size,
      borderRadius: 16,
      dashSpace: 0,
      backgroundColor: buttonColor,
    );
    background.anchor = Anchor.center;
    add(background);

    // Create speaker icon
    speakerIcon = SpriteComponent(
      sprite: await Sprite.load('speaker_icon.png'),
      size: Vector2.all(size.x * 0.6),
      paint: Paint()..color = Colors.blue,
    );
    speakerIcon.anchor = Anchor.center;
    add(speakerIcon);

    // Set the anchor for the whole component
    anchor = Anchor.center;
  }

  // Set the button color
  void setColor(Color color) {
    buttonColor = color;
    background.paint = Paint()..color = color;
  }

  // Handle tap
  @override
  bool onTapDown(TapDownEvent event) {
    onTap();
    return false;
  }

  // Handle drag start
  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    isDragging = true;
    startPosition = position.clone();
    dragDelta = event.canvasPosition - position;
    // priority = 10; // Bring to front while dragging
    // scale = Vector2.all(1.2); // Scale up while dragging
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
    return false;
  }

  // Handle drag cancel
  @override
  bool onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    isDragging = false;
    returnToOriginalPosition();
    // scale = Vector2.all(1.0);
    position = startPosition;
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
