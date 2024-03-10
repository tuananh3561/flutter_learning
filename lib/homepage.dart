import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/ball.dart';
import 'package:flutter_learning/brick.dart';
import 'package:flutter_learning/coverscreen.dart';
import 'package:flutter_learning/gameoverscreen.dart';
import 'package:flutter_learning/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;
  double ballXincremennts = 0.02;
  double ballYincremennts = 0.01;

  // player variables
  double playerX = -0.2;
  double playerWidth = 0.4; // out of 2

  // brick variables
  static double firstbrickX = -0.5;
  static double firstbrickY = -0.9;
  static double brickWidth = 0.4; // out of 2
  static double brickHeight = 0.05; // out of 2
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 2;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  bool brickBroken = false;

  List Bricks = [
    // [x, y, broken = true/false]
    [firstbrickX + 0 * (brickWidth + brickGap), firstbrickY, false],
    [firstbrickX + 1 * (brickWidth + brickGap), firstbrickY, false],
    [firstbrickX + 2 * (brickWidth + brickGap), firstbrickY, false],
  ];

  // get settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      //update direction
      updateDirection();

      // move ball
      moveBall();

      // check if game is over
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check if ball hits brick
      checkForBrokenBrick();
    });
  }

  void checkForBrokenBrick() {
    for (int i = 0; i < Bricks.length; i++) {
      if (ballX >= Bricks[i][0] &&
          ballX <= Bricks[i][0] + brickWidth &&
          ballY <= Bricks[i][1] + brickHeight &&
          Bricks[i][2] == false) {
        setState(() {
          Bricks[i][2] = true;

          double leftSideDist = (Bricks[i][0] - ballX).abs();
          double rightSideDist = (Bricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (Bricks[i][1] - ballY).abs();
          double bottomSideDist = (Bricks[i][1] + brickHeight - ballY).abs();
          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case "left":
              ballXDirection = direction.LEFT;
              break;
            case "right":
              ballXDirection = direction.RIGHT;
              break;
            case "top":
              ballYDirection = direction.UP;
              break;
            case "bottom":
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
    // checks for when ball hits bottom of brick
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return "left";
    } else if ((currentMin - b).abs() < 0.01) {
      return "right";
    } else if ((currentMin - c).abs() < 0.01) {
      return "top";
    } else if ((currentMin - d).abs() < 0.01) {
      return "bottom";
    }

    return "";
  }

  // is player dead?
  bool isPlayerDead() {
    // player dies if ball reaches the bottom of the screen
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveBall() {
    setState(() {
      // move horizontally
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXincremennts;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXincremennts;
      }

      // move vertically
      if (ballYDirection == direction.DOWN) {
        ballY += ballYincremennts;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincremennts;
      }
    });
  }

  void updateDirection() {
    setState(() {
      // ball goes up when it hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      // baall goes down when it hits the top of screen
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
      // ball goes left when it hits the left of screen
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
      // ball goes right when it hits the right of screen
      else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX - (playerWidth / 2) < -1)) {
        playerX -= 0.2;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                // tap to play
                Coverscreen(
                  hasGameStarted: hasGameStarted,
                ),
                // tap game over
                GameOverScreen(
                  isGameOver: isGameOver,
                ),
                // ball
                Ball(
                  ballX: ballX,
                  ballY: ballY,
                ),
                // player
                Player(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
                // bricks
                Brick(
                  brickX: Bricks[0][0],
                  brickY: Bricks[0][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: Bricks[0][2],
                ),
                Brick(
                  brickX: Bricks[1][0],
                  brickY: Bricks[1][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: Bricks[1][2],
                ),
                Brick(
                  brickX: Bricks[2][0],
                  brickY: Bricks[2][1],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: Bricks[2][2],
                ),

                // where is palyerX exactly?
                Container(
                  alignment: Alignment(playerX, 0.9),
                  child: Container(
                    height: 15,
                    width: 4,
                    color: Colors.red,
                  ),
                ),
                Container(
                  alignment: Alignment(playerX + playerWidth, 0.9),
                  child: Container(
                    height: 15,
                    width: 4,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
