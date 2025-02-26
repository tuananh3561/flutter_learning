import 'package:flutter/material.dart';
import 'package:flutter_learning/features/games/fruit_game/fruit_game.dart';
import 'package:flutter_learning/features/games/snake_game/flame_snake_game.dart';
import 'package:flutter_learning/features/games/uno_game/uno_game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/games/fruit_game/bloc/game_bloc.dart';
import 'package:flame/game.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Selection'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildGameCard(
                context,
                'UNO Game',
                'A classic card game with a modern twist',
                Icons.style,
                Colors.red,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UnoApp()),
                ),
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context,
                'Snake Game',
                'The classic snake game reimagined',
                Icons.sports_esports,
                Colors.green,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GameWidget(game: FlameSnakeGame())),
                ),
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context,
                'Fruit Game',
                'A fun and educational fruit matching game',
                Icons.apple,
                Colors.orange,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => GameBloc(),
                      child: Builder(
                        builder: (context) => GameWidget(
                          game: FruitGame(gameBloc: context.read<GameBloc>()),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
