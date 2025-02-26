import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/features/games/fruit_game/components/audio_button_component.dart';
import 'package:flutter_learning/features/games/fruit_game/components/fruit_component.dart';
import 'package:flutter_learning/features/games/fruit_game/components/target_area_component.dart';
import 'package:flutter_learning/features/games/fruit_game/components/sky_background_component.dart';
import 'package:flutter_learning/features/games/fruit_game/managers/audio_manager.dart';

import 'package:flutter_learning/features/games/fruit_game/bloc/game_bloc.dart';
import 'package:flutter_learning/features/games/fruit_game/bloc/game_event.dart';

class FruitGame extends FlameGame with DragCallbacks {
  late double gameWidth = 400;
  late double gameHeight = 600;

  bool isGameOver = false;
  int score = 0;
  int currentLevel = 0;

  late FruitComponent currentFruit;
  late TargetAreaComponent targetArea;
  late AudioButtonComponent correctAudioButton;
  late AudioButtonComponent wrongAudioButton;
  late TextComponent scoreText;
  late SkyBackground skyBackground;
  late AudioManager audioManager;

  final List<Map<String, String>> fruitData = [
    {
      'name': 'Apple',
      'image': 'fruits/apple.png',
      'audio': 'fruits/apple.mp3',
    },
    {
      'name': 'Banana',
      'image': 'fruits/mango.png',
      'audio': 'fruits/mango.mp3',
    },
  ];

  late GameBloc gameBloc;

  FruitGame({required this.gameBloc}) {
    audioManager = AudioManager();
  }

  @override
  Future<void> onLoad() async {
    gameWidth = size.x;
    gameHeight = size.y;
    camera.viewport =
        FixedResolutionViewport(resolution: Vector2(gameWidth, gameHeight));

    // Preload all game audio
    await audioManager.preloadGameAudio(fruitData);

    // Add sky background first so it appears behind other components
    skyBackground = SkyBackground(gameWidth: gameWidth, gameHeight: gameHeight);
    add(skyBackground);

    // Listen to game state changes
    gameBloc.stream.listen((state) {
      if (state.score != score) {
        score = state.score;
        scoreText.text = 'Score: ${state.score}';
      }
    });

    // Start the game
    gameBloc.add(const GameStarted());

    await initializeGame();
  }

  Future<void> initializeGame() async {
    // Create target area
    targetArea = TargetAreaComponent(
      position: Vector2(gameWidth / 2 - 100, gameHeight - 150),
      size: Vector2(200, 100),
    );
    add(targetArea);

    // Create audio buttons
    correctAudioButton = AudioButtonComponent(
      audioPath: fruitData[currentLevel]['audio']!,
      isCorrectPronunciation: true,
      position: Vector2(50, gameHeight - 200),
      size: Vector2(50, 50),
    );

    wrongAudioButton = AudioButtonComponent(
      audioPath: fruitData[(currentLevel + 1) % fruitData.length]['audio']!,
      isCorrectPronunciation: false,
      position: Vector2(gameWidth - 100, gameHeight - 200),
      size: Vector2(50, 50),
    );

    add(correctAudioButton);
    add(wrongAudioButton);

    // Create current fruit
    currentFruit = FruitComponent(
      fruitName: fruitData[currentLevel]['name']!,
      imagePath: fruitData[currentLevel]['image']!,
      audioPath: fruitData[currentLevel]['audio']!,
      position: Vector2(gameWidth / 2 - 50, 100),
      size: Vector2(100, 100),
    );
    add(currentFruit);

    // Add score display
    scoreText = TextComponent(
      text: 'Score: $score',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
    scoreText.position = Vector2(20, 20);
    add(scoreText);
  }

  void checkAnswer(String selectedAnswer, String correctAnswer) {
    if (selectedAnswer == correctAnswer) {
      gameBloc.add(ScoreUpdated(score + 10));
      print('Show success animation');
      // TODO: Show success animation
      nextLevel();
    } else {
      print('Show failure animation');
      // TODO: Show failure feedback
    }
  }

  void nextLevel() {
    currentLevel++;
    gameBloc.add(LevelUpdated(currentLevel));
    if (currentLevel >= 2) {
      // Game ends after 2 correct answers
      gameOver();
    } else {
      // TODO: Load next fruit question
    }
  }

  void gameOver() {
    isGameOver = true;
    gameBloc.add(const GameOver());
    // TODO: Show game over screen with monkey animation and rewards
  }

  void restart() {
    isGameOver = false;
    score = 0;
    currentLevel = 0;
    gameBloc.add(const GameReset());
    // TODO: Reset game state
  }

  @override
  void onDragEnd(DragEndEvent event) {
    print('On Drag End');
    gameBloc.add(ScoreUpdated(score + 10));
    if (currentFruit.isDragging) {
      final fruitCenter = currentFruit.position + (currentFruit.size / 2);
      if (targetArea.containsPoint(fruitCenter)) {
        // Check if the current fruit matches the correct audio
        checkAnswer(currentFruit.fruitName, fruitData[currentLevel]['name']!);
      } else {
        // Return fruit to starting position if dropped outside target
        currentFruit.resetPosition();
      }
    }
  }
}
