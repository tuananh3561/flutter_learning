import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'feed_the_shark_game.dart';

/// Widget that wraps the Feed the Shark game
class FeedTheSharkWidget extends StatefulWidget {
  /// Number of correct answers needed to win
  final int requiredCorrectAnswers;

  /// Callback when game is completed
  final VoidCallback? onGameComplete;

  /// Constructor
  const FeedTheSharkWidget({
    Key? key,
    this.requiredCorrectAnswers = 5,
    this.onGameComplete,
  }) : super(key: key);

  @override
  State<FeedTheSharkWidget> createState() => _FeedTheSharkWidgetState();
}

class _FeedTheSharkWidgetState extends State<FeedTheSharkWidget> {
  double screenWidth = 0;
  double screenHeight = 0;

  /// The game instance
  late FeedTheSharkGame _game;

  /// Whether the game is loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation for the game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Get the screen size after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        screenWidth = mediaQuery.size.width;
        screenHeight = mediaQuery.size.height;
      });
      // Initialize the game with the screen size
      _initGame(screenWidth, screenHeight);
    });
  }

  @override
  void dispose() {
    // Reset orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  /// Initialize the game
  void _initGame(double screenWidth, double screenHeight) {
    // Default to landscape orientation game size
    final gameSize = Vector2(screenWidth, screenHeight);

    _game = FeedTheSharkGame(
      gameSize: gameSize,
      requiredCorrectAnswers: widget.requiredCorrectAnswers,
      onGameComplete: widget.onGameComplete,
    );

    // Once game is loaded, mark loading as complete
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: GameWidget(
        game: _game,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, error) => Center(
          child: Text(
            'Có lỗi xảy ra: $error',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        // Overlay builder for UI elements on top of the game
        overlayBuilderMap: {
          'pause_button': (_, game) => Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white),
                  onPressed: () {
                    // Pause game logic would go here
                  },
                ),
              ),
        },
      ),
    );
  }
}
