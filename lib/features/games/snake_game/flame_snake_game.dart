import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlameSnakeGame extends FlameGame
    with KeyboardEvents, TapCallbacks, DragCallbacks {
  static const tileSize = 20.0;
  static const gridSize = 20;
  late SnakeHead snake;
  late Food food;
  Direction direction = Direction.right;
  bool isGameOver = false;
  int score = 0;

  @override
  Future<void> onLoad() async {
    snake = SnakeHead();
    food = Food();
    add(snake);
    add(food);
    generateFood();
  }

  void generateFood() {
    final random = math.Random();
    double x, y;
    do {
      x = (random.nextInt(gridSize) * tileSize);
      y = (random.nextInt(gridSize) * tileSize);
    } while (snake.segments
        .any((segment) => segment.position.x == x && segment.position.y == y));
    food.position = Vector2(x, y);
  }

  // @override
  // bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   print(event.logicalKey.keyLabel);
  //   if (event is RawKeyDownEvent) {
  //     switch (event.logicalKey.keyLabel) {
  //       case 'Arrow Up':
  //         if (direction != Direction.down) direction = Direction.up;
  //         break;
  //       case 'Arrow Down':
  //         if (direction != Direction.up) direction = Direction.down;
  //         break;
  //       case 'Arrow Left':
  //         if (direction != Direction.right) direction = Direction.left;
  //         break;
  //       case 'Arrow Right':
  //         if (direction != Direction.left) direction = Direction.right;
  //         break;
  //     }
  //   }
  //   return super.onKeyEvent(event, keysPressed);
  // }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        if (direction != Direction.down) direction = Direction.up;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        if (direction != Direction.up) direction = Direction.down;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        if (direction != Direction.right) direction = Direction.left;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        if (direction != Direction.left) direction = Direction.right;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.delta.y < 0 && direction != Direction.down) {
      direction = Direction.up;
    } else if (event.delta.y > 0 && direction != Direction.up) {
      direction = Direction.down;
    } else if (event.delta.x < 0 && direction != Direction.right) {
      direction = Direction.left;
    } else if (event.delta.x > 0 && direction != Direction.left) {
      direction = Direction.right;
    }
  }

  void gameOver() {
    isGameOver = true;
    pauseEngine();
  }

  void restart() {
    isGameOver = false;
    score = 0;
    snake.reset();
    generateFood();
    resumeEngine();
  }
}

class SnakeHead extends PositionComponent with HasGameRef<FlameSnakeGame> {
  List<SnakeSegment> segments = [];
  double moveTimer = 0;
  static const moveInterval = 0.2; // 200ms

  SnakeHead() : super(size: Vector2.all(FlameSnakeGame.tileSize)) {
    position = Vector2(
      FlameSnakeGame.gridSize / 2 * FlameSnakeGame.tileSize,
      FlameSnakeGame.gridSize / 2 * FlameSnakeGame.tileSize,
    );
    segments.add(SnakeSegment(position: position.clone()));
  }

  @override
  void update(double dt) {
    if (gameRef.isGameOver) return;

    moveTimer += dt;
    if (moveTimer >= moveInterval) {
      moveTimer = 0;
      move();
    }
  }

  void move() {
    final Vector2 oldPos = position.clone();

    switch (gameRef.direction) {
      case Direction.up:
        position.y = (position.y -
                FlameSnakeGame.tileSize +
                (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize)) %
            (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize);
        break;
      case Direction.down:
        position.y = (position.y + FlameSnakeGame.tileSize) %
            (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize);
        break;
      case Direction.left:
        position.x = (position.x -
                FlameSnakeGame.tileSize +
                (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize)) %
            (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize);
        break;
      case Direction.right:
        position.x = (position.x + FlameSnakeGame.tileSize) %
            (FlameSnakeGame.gridSize * FlameSnakeGame.tileSize);
        break;
    }

    // Check self-collision
    if (segments.skip(1).any((segment) =>
        segment.position.x == position.x && segment.position.y == position.y)) {
      gameRef.gameOver();
      return;
    }

    // Check food collision
    if (position.x == gameRef.food.position.x &&
        position.y == gameRef.food.position.y) {
      gameRef.score++;
      segments.add(SnakeSegment(position: segments.last.position.clone()));
      gameRef.generateFood();
    }

    // Update segments
    Vector2 newPos = oldPos.clone();
    for (var segment in segments) {
      final Vector2 temp = segment.position.clone();
      segment.position.setFrom(newPos);
      newPos = temp;
    }
  }

  void reset() {
    position = Vector2(
      FlameSnakeGame.gridSize / 2 * FlameSnakeGame.tileSize,
      FlameSnakeGame.gridSize / 2 * FlameSnakeGame.tileSize,
    );
    segments.clear();
    segments.add(SnakeSegment(position: position.clone()));
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.green;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, FlameSnakeGame.tileSize, FlameSnakeGame.tileSize),
      paint,
    );
  }
}

class SnakeSegment extends PositionComponent {
  SnakeSegment({required Vector2 position})
      : super(position: position, size: Vector2.all(FlameSnakeGame.tileSize));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.green;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, FlameSnakeGame.tileSize, FlameSnakeGame.tileSize),
      paint,
    );
  }
}

class Food extends PositionComponent {
  Food() : super(size: Vector2.all(FlameSnakeGame.tileSize));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, FlameSnakeGame.tileSize, FlameSnakeGame.tileSize),
      paint,
    );
  }
}

enum Direction { up, down, left, right }
