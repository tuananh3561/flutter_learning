import 'package:flappy_dash/features/games/flappy_dash/app_style.dart';
import 'package:flappy_dash/features/games/flappy_dash/dialogs/app_dialogs.dart';
import 'package:flappy_dash/features/games/flappy_dash/dialogs/leaderboard_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LeaderBoardDialog extends StatelessWidget {
  const LeaderBoardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const closeIconSize = 38.0;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        width: 400,
        decoration: BoxDecoration(
          color: AppColors.dialogBgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          border: Border.all(
            color: Colors.black,
            width: 6,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.1,
              blurRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: closeIconSize,
                ),
                const Text(
                  "Leaderboard",
                  style: TextStyle(
                    color: AppColors.whiteTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset(
                    "assets/icons/ic_close.svg",
                    width: closeIconSize,
                    height: closeIconSize,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 400,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 18),
                itemBuilder: (context, index) {
                  return LeaderboardRow(
                    rank: index + 1,
                    name: 'Player $index',
                    score: (10 - index) * 100,
                    isMine: index == 3,
                    onMyProfileTap: () {
                      AppDialogs.showNicknameDialog(context);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    color: Colors.white10,
                    height: 1,
                  );
                },
                itemCount: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
