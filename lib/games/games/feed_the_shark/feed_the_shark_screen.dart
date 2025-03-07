import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../presentation/screens/games/feed_the_shark_screen.dart';
import 'feed_the_shark_widget.dart';

/// Screen for the Feed the Shark game
class FeedTheSharkGameScreen extends StatefulWidget {
  /// Constructor
  const FeedTheSharkGameScreen({Key? key}) : super(key: key);

  @override
  State<FeedTheSharkGameScreen> createState() => _FeedTheSharkGameScreenState();
}

class _FeedTheSharkGameScreenState extends State<FeedTheSharkGameScreen> {
  /// Flag to determine whether to show the warning or actual game
  bool _showWarning = true;

  @override
  Widget build(BuildContext context) {
    if (_showWarning) {
      // Show warning screen with a button to proceed to the game
      return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Stack(
          children: [
            // Warning screen
            const FeedTheSharkScreen(),

            // Button to proceed to the game anyway
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showWarning = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Chơi thử phiên bản demo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show the actual game
      return FeedTheSharkWidget(
        requiredCorrectAnswers: 5,
        onGameComplete: () {
          // Show game completion dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Chúc mừng!'),
              content: const Text('Bạn đã hoàn thành trò chơi Feed the Shark!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  child: const Text('Kết thúc'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Restart the game
                    setState(() {
                      _showWarning = false;
                    });
                  },
                  child: const Text('Chơi lại'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
