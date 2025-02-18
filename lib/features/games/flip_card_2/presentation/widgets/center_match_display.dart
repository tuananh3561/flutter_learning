import 'package:flutter/material.dart';

import '../../domain/entities/card_entity.dart';

class CenterMatchDisplay extends StatelessWidget {
  final CardEntity card;

  const CenterMatchDisplay({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: 1.5,
        child: Image.asset(
          card.imagePath,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
