import 'package:flutter/material.dart';

/// Game configuration constants
class GameConfig {
  /// Game dimensions
  static const double gameWidth = 360;
  static const double gameHeight = 640;

  /// Component sizes
  static const double fruitItemSize = 180;
  static const double audioButtonSize = 80;
  static const double dropZoneSize = 100;

  /// Game settings
  static const int defaultQuestionsPerRound = 5;
  static const Duration questionTransitionDelay = Duration(milliseconds: 1500);
  static const Duration feedbackAnimationDuration = Duration(milliseconds: 500);

  /// Colors
  static const Color correctColor = Colors.green;
  static const Color incorrectColor = Colors.red;
  static const Color defaultButtonColor = Colors.blue;
  static const Color dropZoneDefaultColor = Color.fromRGBO(200, 200, 200, 0.5);
  static const Color dropZoneHoverColor = Color.fromRGBO(100, 181, 246, 0.5);

  /// Animation settings
  static const double buttonScaleWhenDragged = 1.2;
  static const Duration buttonReturnDuration = Duration(milliseconds: 300);
  static const Curve buttonReturnCurve = Curves.easeOutCubic;

  /// Particle effects
  static const int celebrationParticleCount = 50;
  static const double celebrationParticleSpeed = 200;
  static const double celebrationParticleGravity = 50;
  static const double celebrationParticleSize = 5;

  /// Reward settings
  static const int coinsPerCorrectAnswer = 10;
  static const int baseCoinsReward = 5;

  /// Text styles
  static const TextStyle fruitNameStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Colors.black54,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const TextStyle scoreStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 8,
        color: Colors.black54,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  /// Asset paths
  static const String speakerIconPath = 'speaker_icon.png';
  static const String monkeySpriteSheetPath = 'images/monkey_sprite_sheet.png';
  static const String coinImagePath = 'images/coin.png';

  /// Sound paths
  static const String correctSoundPath = 'sounds/correct.mp3';
  static const String incorrectSoundPath = 'sounds/incorrect.mp3';
  static const String celebrationSoundPath = 'sounds/celebration.mp3';

  /// Folders
  static const String fruitImagesFolder = 'images/fruits/';
  static const String fruitSoundsFolder = 'sounds/fruits/';

  /// Monkey animation settings
  static const int monkeyFrameCount = 8;
  static const double monkeyFrameWidth = 128;
  static const double monkeyFrameHeight = 128;
  static const double monkeyAnimationStepTime = 0.1;

  /// Coin animation settings
  static const double coinSize = 30;
  static const double coinVerticalSpeed = 300;
  static const double coinHorizontalSpeed = 50;
  static const double coinGravity = 30;
  static const double coinStartY = -50;
  static const double coinLifespan = 3;

  /// Do not allow instantiation
  const GameConfig._();
}
