import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import 'fruit_game.dart';
import 'models/fruit.dart';
import 'services/game_service.dart';
import 'services/sound_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Drag & Drop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService _gameService;
  late SoundService _soundService;
  late FruitGame _game;

  // Sample fruit data - In a real app, this would come from assets or a database
  final List<Fruit> _fruitData = [
    const Fruit(
      id: 'apple',
      englishName: 'Apple',
      imagePath: 'fruits/apple.png',
      soundPath: 'audio/fruits/apple.mp3',
    ),
    const Fruit(
      id: 'banana',
      englishName: 'Banana',
      imagePath: 'fruits/banana.png',
      soundPath: 'audio/fruits/banana.mp3',
    ),
    const Fruit(
      id: 'orange',
      englishName: 'Orange',
      imagePath: 'fruits/orange.png',
      soundPath: 'audio/fruits/orange.mp3',
    ),
    const Fruit(
      id: 'strawberry',
      englishName: 'Strawberry',
      imagePath: 'fruits/strawberry.png',
      soundPath: 'audio/fruits/strawberry.mp3',
    ),
    const Fruit(
      id: 'grape',
      englishName: 'Grape',
      imagePath: 'fruits/grape.png',
      soundPath: 'audio/fruits/grape.mp3',
    ),
    const Fruit(
      id: 'watermelon',
      englishName: 'Watermelon',
      imagePath: 'fruits/watermelon.png',
      soundPath: 'audio/fruits/watermelon.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize services
    _gameService = GameService(
      availableFruits: _fruitData,
      questionsPerRound: 5, // Configure number of questions per round
    );

    _soundService = SoundService();

    // Preload sounds
    _soundService.preloadSounds(_fruitData);

    // Initialize the game
    _game = FruitGame(
      gameService: _gameService,
      soundService: _soundService,
    );
  }

  @override
  void dispose() {
    _gameService.dispose();
    _soundService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _gameService),
          ChangeNotifierProvider.value(value: _soundService),
        ],
        child: SafeArea(
          child: Column(
            children: [
              // Game header
              _buildGameHeader(),

              // Game container
              Expanded(
                child: GameWidget(game: _game),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.blue.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress indicator
              Text(
                'Question: ${gameService.state.currentQuestionIndex + 1}/${gameService.state.totalQuestions}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Sound toggle
              Consumer<SoundService>(
                builder: (context, soundService, child) {
                  return IconButton(
                    icon: Icon(
                      soundService.isSoundEnabled
                          ? Icons.volume_up
                          : Icons.volume_off,
                    ),
                    onPressed: () => soundService.toggleSound(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Game over overlay widget
class GameOverOverlay extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Great Job!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score/$totalQuestions',
              style: const TextStyle(
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
