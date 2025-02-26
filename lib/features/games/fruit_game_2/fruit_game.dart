import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import 'models/enums/game_status.dart';
import 'services/game_service.dart';
import 'services/sound_service.dart';
import 'components/fruit_item.dart';
import 'components/audio_button.dart';
import 'components/drop_zone.dart';
import 'components/monkey.dart';
import 'components/sky_background.dart';

class FruitGame extends FlameGame
    with DragCallbacks, TapCallbacks, HasCollisionDetection {
  // Services
  final GameService gameService;
  final SoundService soundService;

  // Random number generator
  final Random random = Random();

  // Game components
  late FruitItem fruitItem;
  late DropZone dropZone;
  late AudioButton correctAudioButton;
  late AudioButton incorrectAudioButton;
  late TextComponent fruitNameComponent;
  late SkyBackground skyBackground;

  late Monkey monkeyComponent;

  // Constants for positioning
  static const double fruitItemSize = 180;
  static const double audioButtonSize = 180;
  static const double dropZoneSize = 180;

  late double gameWidth = 400;
  late double gameHeight = 600;

  // Constructor
  FruitGame({
    required this.gameService,
    required this.soundService,
  });

  // Initialize the game
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameWidth = size.x;
    gameHeight = size.y;

    // Set up camera
    camera.viewport =
        FixedResolutionViewport(resolution: Vector2(gameWidth, gameWidth));

    // Start the game
    gameService.startGame();

    // Set up the UI components
    await _setupGameComponents();

    // Listen for game state changes
    gameService.addListener(_onGameStateChanged);
  }

  // Set up all game components based on the current question
  Future<void> _setupGameComponents() async {
    // Clear existing components if any
    removeAll(children);

    final currentQuestion = gameService.currentQuestion;
    if (currentQuestion == null) return;

    // Get the displayed fruit
    final displayedFruit = currentQuestion.displayedFruit;

    // Add sky background first so it appears behind other components
    skyBackground = SkyBackground(gameWidth: size.x, gameHeight: size.y);
    add(skyBackground);

    // Create the fruit item component
    fruitItem = FruitItem(
      fruit: displayedFruit,
      position: Vector2(size.x / 2 - 180, size.y * 0.25),
      size: Vector2.all(fruitItemSize),
      onTap: () {
        // soundService.playFruitSound(displayedFruit);
      },
    );
    add(fruitItem);

    // Create the drop zone component
    dropZone = DropZone(
      position: Vector2(size.x / 2 + 180, size.y * 0.25 + 100),
      size: Vector2.all(dropZoneSize),
      onAccept: _validateDrop,
    );
    add(dropZone);

    // Create the fruit name component (initially hidden)
    fruitNameComponent = TextComponent(
      text: displayedFruit.englishName,
      position: Vector2(size.x / 2, size.y * 0.45),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0),
        ),
      ),
    )..anchor = Anchor.center;
    add(fruitNameComponent);

    // Get shuffled options for the audio buttons
    final options = gameService.getShuffledOptions();

    // Create audio buttons
    correctAudioButton = AudioButton(
      fruit: options[0],
      position: Vector2(size.x * 0.3, size.y * 0.65),
      size: Vector2.all(audioButtonSize),
      onTap: () {
        // soundService.playFruitSound(options[0]);
      },
    );
    add(correctAudioButton);

    incorrectAudioButton = AudioButton(
      fruit: options[1],
      position: Vector2(size.x * 0.7, size.y * 0.65),
      size: Vector2.all(audioButtonSize),
      onTap: () {
        // soundService.playFruitSound(options[1]);
      },
    );
    add(incorrectAudioButton);
  }

  // Handle drop validation
  bool _validateDrop(Component draggable) {
    if (draggable is! AudioButton) return false;

    final selectedFruit = draggable.fruit;
    final isCorrect = gameService.validateAnswer(selectedFruit);

    // Play feedback sound
    soundService.playFeedbackSound(isCorrect);

    if (isCorrect) {
      // Show correct feedback
      _showCorrectFeedback(draggable);
    } else {
      // Show incorrect feedback
      _showIncorrectFeedback(draggable);
    }

    return isCorrect;
  }

  // Show feedback for correct answer
  void _showCorrectFeedback(AudioButton button) {
    // Change button color to green
    button.setColor(Colors.green);

    // Show fruit name
    fruitNameComponent.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    // Show celebration particles
    _showCelebrationParticles();

    // Move to next question after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      gameService.moveToNextQuestion();
    });
  }

  // Show feedback for incorrect answer
  void _showIncorrectFeedback(AudioButton button) {
    // Change button color to red
    button.setColor(Colors.red);

    // Move the button back to its original position
    button.returnToOriginalPosition();

    // Shake effect
    button.add(
      SequenceEffect([
        MoveByEffect(
          Vector2(10, 0),
          EffectController(duration: 0.05),
        ),
        MoveByEffect(
          Vector2(-20, 0),
          EffectController(duration: 0.1),
        ),
        MoveByEffect(
          Vector2(10, 0),
          EffectController(duration: 0.05),
        ),
      ]),
    );

    // Reset button color after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      button.setColor(Colors.blue);
    });
  }

  // Show celebration particles
  void _showCelebrationParticles() {
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 50,
        lifespan: 1,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 50),
          speed: Vector2(random.nextDouble() * 200 - 100,
              -random.nextDouble() * 200 - 100),
          position: Vector2(size.x / 2, size.y * 0.45),
          child: CircleParticle(
            radius: 5,
            paint: Paint()
              ..color = Color.fromARGB(
                255,
                random.nextInt(255),
                random.nextInt(255),
                random.nextInt(255),
              ),
          ),
        ),
      ),
    );
    add(particleComponent);
  }

  // Handle game state changes
  void _onGameStateChanged() {
    switch (gameService.state.status) {
      case GameStatus.playing:
        if (gameService.state.currentQuestionIndex > 0) {
          // We've moved to a new question, update the UI
          _setupGameComponents();
        }
        break;
      case GameStatus.completed:
        _showGameCompleteScreen();
        break;
      default:
        break;
    }
  }

  // Show game complete screen
  void _showGameCompleteScreen() {
    // Clear existing components
    removeAll(children);

    // Play celebration sound
    soundService.playCelebrationSound();

    // Add monkey reward animation
    monkeyComponent = Monkey(
      position: Vector2(size.x / 2, size.y * 0.4),
      size: Vector2(200, 250),
    );
    add(monkeyComponent);

    // Add score text
    final scoreComponent = TextComponent(
      text: 'Score: ${gameService.score}/${gameService.state.totalQuestions}',
      position: Vector2(size.x / 2, size.y * 0.7),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )..anchor = Anchor.center;
    add(scoreComponent);

    // Add reward coins animation
    _showRewardCoins();
  }

  // Show reward coins animation
  Future<void> _showRewardCoins() async {
    final sprite = await Sprite.load('images/coin.png');
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: gameService.score * 10, // More coins for higher score
        lifespan: 3,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 30),
          speed: Vector2(
              random.nextDouble() * 100 - 50, -random.nextDouble() * 300 - 200),
          position: Vector2(size.x / 2, -50),
          child: SpriteParticle(
            size: Vector2.all(30),
            sprite: sprite,
          ),
        ),
      ),
    );
    add(particleComponent);
  }

  // Clean up resources
  @override
  void onRemove() {
    gameService.removeListener(_onGameStateChanged);
    super.onRemove();
  }
}
