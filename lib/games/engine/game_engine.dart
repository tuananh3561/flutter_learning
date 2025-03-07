import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';

/// Base class for all games in the application
abstract class BaseGame extends FlameGame {
  /// Game dimensions
  final Vector2 gameSize;

  /// Constructor
  BaseGame({required this.gameSize});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(resolution: gameSize);
    // camera.viewfinder.zoom = 0.3;
    debugMode = true;
  }

  /// Method to be called when the game starts
  Future<void> onGameStart();

  /// Method to be called when the game ends
  Future<void> onGameEnd();
}

/// Widget that wraps the game
class GameWrapper extends StatelessWidget {
  final BaseGame game;

  const GameWrapper({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
