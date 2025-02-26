import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../levels/base_level.dart';
import '../levels/level_data.dart';
import '../managers/game_manager.dart';
import '../managers/sound_manager.dart';

class GameOverScreen extends Component with TapCallbacks, HasGameRef {
  // Sửa thành TapCallbacks
  final GameManager gameManager;

  GameOverScreen({required this.gameManager});

  @override
  Future<void> onLoad() async {
    final gameOverText = TextComponent(
      text: 'Game Over!',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Colors.red,
          fontFamily: 'YourFont',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(gameRef.size.x / 2, gameRef.size.y / 3),
    );
    add(gameOverText);

    final scoreText = TextComponent(
      text: 'Score: ${gameManager.score}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontFamily: 'YourFont',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(gameRef.size.x / 2, gameRef.size.y / 2),
    );
    add(scoreText);

    final restartButton = TextComponent(
      text: 'Tap to Restart',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.yellow,
          fontFamily: 'YourFont',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 2 / 3),
    );
    add(restartButton);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    gameManager.reset();
    removeFromParent();
    // gameRef.add(BaseLevel(gameManager, gameRef.findByType<SoundManager>()!,
    //     levels[0])); // Sửa lại thành findByType
    return true;
  }
}
