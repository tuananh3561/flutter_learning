import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/game_state.dart';
import '../../domain/player.dart';
import '../../domain/game.dart';
import '../state/game_provider.dart';
import '../widgets/game_table_widget.dart';
import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBackground(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final game = gameProvider.game;

            if (game == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  // Game header
                  _buildGameHeader(game, gameProvider),

                  // Game table (takes most of the screen)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GameTableWidget(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackground({required Widget child}) {
    return Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade900,
                    Colors.green.shade700,
                    Colors.green.shade600,
                    Colors.green.shade500,
                  ],
                  stops: [
                    0.0,
                    0.3 + (_backgroundAnimation.value * 0.2),
                    0.6 + (_backgroundAnimation.value * 0.1),
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),

        // Background pattern
        Opacity(
          opacity: 0.1,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pattern.png'),
                repeat: ImageRepeat.repeat,
                scale: 0.5,
              ),
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }

  Widget _buildGameHeader(Game game, GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showExitConfirmationDialog(context, gameProvider),
          ),

          // Game stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'UNO Game',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${game.players.length} Players | ${_getDifficultyText(game.players)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Game controls
          Row(
            children: [
              // Reset button
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () =>
                    _showResetConfirmationDialog(context, gameProvider),
                tooltip: 'Reset Game',
              ),

              // Settings button
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Show settings dialog or navigate to settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Settings are not available during gameplay'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(List<Player> players) {
    // Find the first AI player to determine difficulty
    final aiPlayer = players.firstWhere(
      (p) => p.type != PlayerType.human,
      orElse: () => players.first,
    );

    switch (aiPlayer.type) {
      case PlayerType.aiEasy:
        return 'Easy';
      case PlayerType.aiMedium:
        return 'Medium';
      case PlayerType.aiHard:
        return 'Hard';
      default:
        return '';
    }
  }

  Future<void> _showExitConfirmationDialog(
      BuildContext context, GameProvider gameProvider) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game'),
        content: const Text(
            'Are you sure you want to exit the current game? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (result == true) {
      gameProvider.resetGame();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  Future<void> _showResetConfirmationDialog(
      BuildContext context, GameProvider gameProvider) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Game'),
        content: const Text(
            'Are you sure you want to reset the current game? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Get the current settings
      final game = gameProvider.game!;
      final aiPlayerCount =
          game.players.where((p) => p.type != PlayerType.human).length;
      final aiPlayer = game.players.firstWhere(
        (p) => p.type != PlayerType.human,
        orElse: () => game.players.first,
      );

      AIDifficulty difficulty;
      switch (aiPlayer.type) {
        case PlayerType.aiEasy:
          difficulty = AIDifficulty.easy;
          break;
        case PlayerType.aiMedium:
          difficulty = AIDifficulty.medium;
          break;
        case PlayerType.aiHard:
          difficulty = AIDifficulty.hard;
          break;
        default:
          difficulty = AIDifficulty.medium;
      }

      // Reset and start a new game with the same settings
      gameProvider.resetGame();
      gameProvider.initializeGame(
        aiPlayerCount: aiPlayerCount,
        difficulty: difficulty,
      );
    }
  }
}

// Game over dialog
class GameOverDialog extends StatelessWidget {
  final Game game;
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnToMenu;

  const GameOverDialog({
    Key? key,
    required this.game,
    required this.onPlayAgain,
    required this.onReturnToMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final winner = game.winner;
    final isHumanWinner = winner?.type == PlayerType.human;

    return AlertDialog(
      title: Text(
        isHumanWinner ? 'Congratulations!' : 'Game Over',
        style: TextStyle(
          color: isHumanWinner ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHumanWinner
                ? 'You won the game!'
                : '${winner?.name} won the game.',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),

          // Display game statistics
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Game Statistics:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                _buildStatRow('Game Duration', _formatDuration(game.duration)),
                _buildStatRow('Total Moves', '${game.actionHistory.length}'),
                _buildStatRow('Players', '${game.players.length}'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReturnToMenu,
          child: const Text('Return to Menu'),
        ),
        ElevatedButton(
          onPressed: onPlayAgain,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Play Again'),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }
}
