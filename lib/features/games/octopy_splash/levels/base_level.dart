import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../components/octopus.dart';
import '../components/word_display.dart';
import '../components/cat.dart';
import '../managers/game_manager.dart';
import '../managers/sound_manager.dart';
import 'level_data.dart';
import '../screens/game_over_screen.dart';

class BaseLevel extends Component with HasGameRef {
  final GameManager gameManager;
  final SoundManager soundManager;
  final LevelData levelData;

  late Cat cat;
  late Octopus octopus;
  late WordDisplay wordDisplay;

  BaseLevel(this.gameManager, this.soundManager, this.levelData);

  @override
  Future<void> onLoad() async {
    octopus = Octopus();
    add(octopus);

    cat = Cat(currentLevel: this); //Truyền current level.
    add(cat);

    wordDisplay = WordDisplay(
      words: levelData.words,
      onWordSelected: (selectedWord) {
        _handleWordSelection(selectedWord);
      },
      position: Vector2(100, 100),
      size: Vector2(200, 150),
    );
    add(wordDisplay);
    //Load và phát âm thanh hướng dẫn ban đầu
    await soundManager.loadWordSound(levelData.targetWord);
    soundManager.playWordSound(levelData.targetWord);
  }

  void _handleWordSelection(String selectedWord) {
    if (selectedWord == levelData.targetWord) {
      cat.throwBall();
      soundManager.playCorrectSound();
      gameManager.onCorrectWordSelected();
      wordDisplay.removeFromParent(); //ẩn
    } else {
      soundManager.playIncorrectSound();
      gameManager.onIncorrectWordSelected();
      _showIncorrectMessage();
    }
  }

  void _showIncorrectMessage() {
    final incorrectText = TextComponent(
      text: 'Try again!',
      textRenderer:
          TextPaint(style: const TextStyle(fontSize: 30, color: Colors.red)),
      position: Vector2(gameRef.size.x / 2, gameRef.size.y / 2),
      anchor: Anchor.center,
    );
    add(incorrectText);
    Future.delayed(const Duration(seconds: 1), () {
      incorrectText.removeFromParent();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.gameOver && !gameRef.children.contains(GameOverScreen)) {
      gameRef.add(GameOverScreen(gameManager: gameManager));
      removeFromParent(); // Remove the current level
    }
  }
}
