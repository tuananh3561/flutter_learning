import 'package:flappy_dash/features/games/flappy_dash/dialogs/leaderboard_dialog.dart';
import 'package:flappy_dash/features/games/flappy_dash/dialogs/nickname_dialog.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  static void showLeaderboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LeaderBoardDialog();
      },
    );
  }

  static void showNicknameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NicknameDialog();
      },
    );
  }
}
