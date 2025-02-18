import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/game_state.dart';
import '../bloc/game_bloc.dart';
import 'flip_card_widget.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 3,
          children: state.cards.map((card) {
            return FlipCardWidget(card: card);
          }).toList(),
        );
      },
    );
  }
}
