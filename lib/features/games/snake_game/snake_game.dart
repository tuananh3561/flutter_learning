import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static List<Color> colors = [
    Colors.green,
    Colors.red,
  ];

  final int squareSize = 20;
  final int gridSize = 20;
  List<Offset> snake = [];
  Offset food = Offset.zero;
  Timer? timer;
  Direction direction = Direction.right;
  bool isPlaying = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    snake = [
      Offset(gridSize / 2, gridSize / 2),
    ];
    generateFood();
    direction = Direction.right;
    score = 0;
  }

  void generateFood() {
    Random random = Random();
    double x, y;
    do {
      x = random.nextInt(gridSize).toDouble();
      y = random.nextInt(gridSize).toDouble();
    } while (snake.contains(Offset(x, y)));
    food = Offset(x, y);
  }

  void startGame() {
    isPlaying = true;
    timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
      updateSnake();
    });
  }

  void updateSnake() {
    setState(() {
      Offset head = snake.first;
      Offset newHead;

      switch (direction) {
        case Direction.up:
          newHead = Offset(head.dx, (head.dy - 1 + gridSize) % gridSize);
          break;
        case Direction.down:
          newHead = Offset(head.dx, (head.dy + 1) % gridSize);
          break;
        case Direction.left:
          newHead = Offset((head.dx - 1 + gridSize) % gridSize, head.dy);
          break;
        case Direction.right:
          newHead = Offset((head.dx + 1) % gridSize, head.dy);
          break;
      }

      if (snake.contains(newHead)) {
        gameOver();
        return;
      }

      snake.insert(0, newHead);

      if (newHead == food) {
        score++;
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void gameOver() {
    isPlaying = false;
    timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                initGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Score: $score',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Center(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (event) {
                if (event is RawKeyDownEvent) {
                  switch (event.logicalKey.keyLabel) {
                    case 'Arrow Up':
                      if (direction != Direction.down) {
                        direction = Direction.up;
                      }
                      break;
                    case 'Arrow Down':
                      if (direction != Direction.up) {
                        direction = Direction.down;
                      }
                      break;
                    case 'Arrow Left':
                      if (direction != Direction.right) {
                        direction = Direction.left;
                      }
                      break;
                    case 'Arrow Right':
                      if (direction != Direction.left) {
                        direction = Direction.right;
                      }
                      break;
                  }
                }
              },
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != Direction.up && details.delta.dy > 0) {
                    direction = Direction.down;
                  } else if (direction != Direction.down &&
                      details.delta.dy < 0) {
                    direction = Direction.up;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != Direction.left && details.delta.dx > 0) {
                    direction = Direction.right;
                  } else if (direction != Direction.right &&
                      details.delta.dx < 0) {
                    direction = Direction.left;
                  }
                },
                child: Container(
                  width: squareSize * gridSize.toDouble(),
                  height: squareSize * gridSize.toDouble(),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: CustomPaint(
                    painter: SnakeGamePainter(
                      snake: snake,
                      food: food,
                      squareSize: squareSize,
                      gridSize: gridSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (!isPlaying)
            ElevatedButton(
              onPressed: startGame,
              child: const Text('Start Game'),
            ),
        ],
      ),
    );
  }
}

class SnakeGamePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final int squareSize;
  final int gridSize;

  SnakeGamePainter({
    required this.snake,
    required this.food,
    required this.squareSize,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint snakePaint = Paint()..color = Colors.green;
    final Paint foodPaint = Paint()..color = Colors.red;

    for (var segment in snake) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.dx * squareSize,
          segment.dy * squareSize,
          squareSize.toDouble(),
          squareSize.toDouble(),
        ),
        snakePaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(
        food.dx * squareSize,
        food.dy * squareSize,
        squareSize.toDouble(),
        squareSize.toDouble(),
      ),
      foodPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum Direction { up, down, left, right }
