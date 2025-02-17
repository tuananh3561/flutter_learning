import 'package:flappy_dash/features/games/flappy_dash/app_style.dart';
import 'package:flutter/material.dart';

class NormalScore extends StatelessWidget {
  const NormalScore({
    super.key,
    required this.size,
    required this.rank,
  });

  final double size;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.mainColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: const TextStyle(
            color: AppColors.mainColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
