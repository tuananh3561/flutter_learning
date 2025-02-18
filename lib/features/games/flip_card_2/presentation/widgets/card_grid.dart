import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/game_state.dart';
import '../bloc/game_bloc.dart';
import 'center_match_display.dart';
import 'flip_card_widget.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return SizedBox(
          width: 360,
          height: 480,
          child: Stack(
            children: [
              ...state.cards.map((card) => AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    left: card.position.dx,
                    top: card.position.dy,
                    child: FlipCardWidget(card: card),
                  )),
              if (state.matchedCard != null)
                CenterMatchDisplay(card: state.matchedCard!),
            ],
          ),
        );
      },
    );
  }
}
