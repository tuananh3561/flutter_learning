import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_provider.dart';
import '../../domain/enums/game_state.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _aiPlayerCount = 3;
  AIDifficulty _difficulty = AIDifficulty.medium;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade900,
              Colors.indigo.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Text(
                      'UNO Game',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 5,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Game mode selection
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Single Player Mode',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Number of AI players
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'AI Players:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              DropdownButton<int>(
                                value: _aiPlayerCount,
                                onChanged: (value) {
                                  setState(() {
                                    _aiPlayerCount = value!;
                                  });
                                },
                                items: [1, 2, 3, 4, 5, 6, 7]
                                    .map((count) => DropdownMenuItem<int>(
                                          value: count,
                                          child: Text('$count'),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),

                          // AI difficulty
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Difficulty:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              DropdownButton<AIDifficulty>(
                                value: _difficulty,
                                onChanged: (value) {
                                  setState(() {
                                    _difficulty = value!;
                                  });
                                },
                                items: AIDifficulty.values
                                    .map((difficulty) =>
                                        DropdownMenuItem<AIDifficulty>(
                                          value: difficulty,
                                          child: Text(
                                              _getDifficultyName(difficulty)),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Start button
                          ElevatedButton(
                            onPressed: () => _startSinglePlayerGame(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Start Game',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Coming soon - Multiplayer
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Multiplayer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: null, // Disabled
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              disabledBackgroundColor: Colors.grey.shade400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Join Game',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Settings button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings, color: Colors.white),
                      label: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startSinglePlayerGame(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Initialize the game
    gameProvider
        .initializeGame(
      aiPlayerCount: _aiPlayerCount,
      difficulty: _difficulty,
    )
        .then((_) {
      // Navigate to the game screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ),
      );
    });
  }

  String _getDifficultyName(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.easy:
        return 'Easy';
      case AIDifficulty.medium:
        return 'Medium';
      case AIDifficulty.hard:
        return 'Hard';
    }
  }
}
