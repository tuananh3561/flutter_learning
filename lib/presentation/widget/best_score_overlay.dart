import 'package:flappy_dash/presentation/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BestScoreOverlay extends StatelessWidget {
  const BestScoreOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/ic_trophy.svg",
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppColors.leaderboardGoldenColor,
                  BlendMode.srcIn,
                ),
              ),
              const Alignment(
                alignment: Alignment(0.0, -0.5),
                child: Text(
                  "1",
                  style: TextStyle(
                    color: AppColors.leaderboardGoldenColorText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.mainColor,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
