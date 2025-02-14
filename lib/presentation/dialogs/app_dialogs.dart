import 'package:flappy_dash/presentation/dialogs/leaderboard_dialog.dart';
import 'package:flappy_dash/presentation/dialogs/nickname_dialog.dart';
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
