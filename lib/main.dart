import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/games/fruit_game/fruit_game.dart';
import 'package:flutter_learning/features/games/fruit_game/bloc/game_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fruit Game',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => GameBloc(),
          child: Builder(
            builder: (context) => GameWidget(
              game: FruitGame(gameBloc: context.read<GameBloc>()),
            ),
          ),
        ));
  }
}
