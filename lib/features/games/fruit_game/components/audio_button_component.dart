import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/features/games/fruit_game/managers/audio_manager.dart';

class AudioButtonComponent extends PositionComponent
    with TapCallbacks, DragCallbacks {
  final String audioPath;
  final bool isCorrectPronunciation;
  bool isSelected = false;
  late SpriteComponent buttonSprite;
  late TextComponent labelComponent;
  bool isDragging = false;
  Vector2 dragDelta = Vector2.zero();
  Vector2 startPosition = Vector2.zero();

  final AudioManager _audioManager = AudioManager();

  AudioButtonComponent({
    required this.audioPath,
    required this.isCorrectPronunciation,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Add speaker icon sprite
    final sprite = await Sprite.load('speaker_icon.png');
    buttonSprite = SpriteComponent(
      sprite: sprite,
      size: size,
    );
    add(buttonSprite);

    // Add text label if needed
    labelComponent = TextComponent(
      text: 'Listen',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    labelComponent.position = Vector2(0, size.y + 5);
    add(labelComponent);

    // Preload audio file
    await _audioManager.preloadAudio(audioPath);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    playAudio();
    return true;
  }

  @override
  bool onDragStart(DragStartEvent event) {
    isDragging = true;
    startPosition = position.clone();
    dragDelta = event.canvasPosition - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (isDragging) {
      position = event.canvasPosition - dragDelta;
    }
    return false;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    isDragging = false;
    // Check if dropped in correct area will be handled by game
    return false;
  }

  @override
  bool onDragCancel(DragCancelEvent event) {
    isDragging = false;
    position = startPosition;
    return false;
  }

  void playAudio() async {
    await _audioManager.playAudio(audioPath);
  }

  void select() {
    isSelected = true;
    buttonSprite.paint.color =
        isCorrectPronunciation ? Colors.green : Colors.red;
  }

  void reset() {
    isSelected = false;
    buttonSprite.paint.color = Colors.white;
  }
}
