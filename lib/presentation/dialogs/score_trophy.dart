import 'package:flappy_dash/presentation/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScoreTrophy extends StatelessWidget {
  const ScoreTrophy({
    super.key,
    required this.size,
    required this.rank,
  });

  final double size;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_trophy.svg',
            height: size,
            colorFilter: ColorFilter.mode(
              switch (rank) {
                1 => AppColors.leaderboardGoldenColor,
                2 => AppColors.leaderboardSilverColor,
                3 => AppColors.leaderboardBronzeColor,
                _ => throw StateError("Invalid rank: $rank"),
              },
              BlendMode.srcIn,
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.8),
            child: Text(
              rank.toString(),
              style: TextStyle(
                color: switch (rank) {
                  1 => AppColors.leaderboardGoldenColorText,
                  2 => AppColors.leaderboardSilverColorText,
                  3 => AppColors.leaderboardBronzeColorText,
                  _ => throw StateError("Invalid rank: $rank"),
                },
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
