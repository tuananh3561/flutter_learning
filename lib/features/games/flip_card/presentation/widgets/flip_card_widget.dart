import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/card_entity.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';

class FlipCardWidget extends StatelessWidget {
  final CardEntity card;

  const FlipCardWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GameBloc>().add(CardSelected(card));
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              final angle = animation.value * 3.14;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: child,
              );
            },
            child: child,
          );
        },
        child: card.isFlipped
            ? Image.asset(card.imagePath)
            : Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
      ),
    );
  }
}
