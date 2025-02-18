import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/game_state.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../widgets/card_grid.dart';

class FlipCardScreen extends StatelessWidget {
  const FlipCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()..add(GameInitialized()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flip Card Game'),
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state.status == GameStatus.completed) {
              return const Center(
                child: Text('Congratulations! Game Completed!'),
              );
            }

            return const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CardGrid(),
              ),
            );
          },
        ),
      ),
    );
  }
}
