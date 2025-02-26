import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_learning/features/games/fruit_game/managers/audio_manager.dart';

class FruitComponent extends PositionComponent with DragCallbacks {
  final String fruitName;
  final String imagePath;
  final String audioPath;
  bool isDragging = false;
  Vector2 dragDelta = Vector2.zero();
  Vector2 startPosition = Vector2.zero();
  final AudioManager _audioManager = AudioManager();

  FruitComponent({
    required this.fruitName,
    required this.imagePath,
    required this.audioPath,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load fruit image as sprite
    final sprite = await Sprite.load(imagePath);
    add(SpriteComponent(sprite: sprite, size: size));

    // Preload audio file
    await _audioManager.preloadAudio(audioPath);
  }

  @override
  bool onDragStart(DragStartEvent event) {
    playAudio();
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

  void resetPosition() {
    position = startPosition;
    isDragging = false;
  }

  void playAudio() async {
    await _audioManager.playAudio(audioPath);
  }
}
