// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:flutter_learning/core/constants/theme_constants.dart';
import 'package:flutter_learning/presentation/common/dialog/notice_dialog.dart';

void showLogoutDialog(BuildContext context) {
  showCustomNoticeDialog(
    context: context,
    titleText: "Đăng xuất",
    titleColor: AppTheme.errorColor,
    messageText: "Bạn có chắc chắn muốn đăng xuất không?",
    imageAsset: 'assets/images/max_drink.png',
    primaryActionText: "",
    onPrimaryAction: () {},
    secondaryActionText: "Quay lại",
    onSecondaryAction: () {
      context.pop();
    },
  );
}
