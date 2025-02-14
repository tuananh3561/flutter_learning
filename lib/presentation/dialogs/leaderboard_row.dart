import 'package:flappy_dash/presentation/app_style.dart';
import 'package:flappy_dash/presentation/dialogs/normal_score.dart';
import 'package:flappy_dash/presentation/dialogs/score_trophy.dart';
import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.isMine,
    required this.onMyProfileTap,
  });

  final int rank;
  final String name;
  final int score;
  final bool isMine;
  final VoidCallback onMyProfileTap;

  @override
  Widget build(BuildContext context) {
    bool showTrophy = rank <= 3;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isMine ? onMyProfileTap : null,
        child: Container(
          color: isMine ? Colors.white10 : Colors.transparent,
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              showTrophy
                  ? ScoreTrophy(size: 38, rank: rank)
                  : NormalScore(size: 38, rank: rank),
              const SizedBox(
                width: 12,
              ),
              Text(
                name,
                style: TextStyle(
                  color: isMine ? Colors.white : AppColors.whiteTextColor2,
                  fontSize: 32,
                ),
              ),
              if (isMine) ...[
                const SizedBox(
                  width: 4,
                ),
                const Align(
                  alignment: Alignment(0, 0.3),
                  child: Text(
                    '(edit)',
                    style: TextStyle(
                      color: AppColors.blueColor,
                    ),
                  ),
                ),
              ],
              Expanded(child: Container()),
              Text(
                score.toString(),
                style: const TextStyle(
                  color: AppColors.blueColor,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
