import 'package:flappy_dash/features/games/commons/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audio_service.dart';
import '../../domain/entities/game_state.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../widgets/card_grid.dart';

class FlipCardScreen extends StatelessWidget {
  const FlipCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getIt.get<AudioService>().initialize();

    return BlocProvider(
      create: (context) => GameBloc(
        audioService: getIt.get<AudioService>(),
      )..add(GameInitialized()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Flip Card Game'),
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state.phase == GamePhase.completed) {
              return const Center(
                child: Text(
                  'Congratulations!\nGame Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              );
            }

            return const SafeArea(
              child: Center(
                child: CardGrid(),
              ),
            );
          },
        ),
      ),
    );
  }
}
