import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';
import 'feed_the_shark_wrapper.dart';

/// Trang ví dụ để hiển thị cách sử dụng FeedTheSharkWrapper
class FeedTheSharkExample extends StatelessWidget {
  const FeedTheSharkExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FeedTheSharkWrapper(
          gameId: 'feed_the_shark_1', // ID của game
          onGameComplete: () {
            // Xử lý khi game hoàn thành (ví dụ: quay lại màn hình trước)
            Navigator.of(context).pop();
          },
          onBackPressed: () {
            // Hiển thị dialog xác nhận trước khi quay lại
            _showExitConfirmationDialog(context);
          },
        ),
      ),
    );
  }

  /// Hiển thị dialog xác nhận trước khi thoát game
  void _showExitConfirmationDialog(BuildContext context) {
    // Phát âm thanh click
    AudioService().playSoundEffect('../../assets/audio/ui_click.mp3');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thoát Game?'),
          content: const Text(
              'Bạn có chắc muốn thoát khỏi game này không? Tiến trình chơi sẽ không được lưu.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Phát âm thanh khi hủy
                AudioService()
                    .playSoundEffect('../../assets/audio/ui_cancel.mp3');
                Navigator.of(dialogContext).pop(); // Đóng dialog
              },
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                // Phát âm thanh khi xác nhận thoát
                AudioService()
                    .playSoundEffect('../../assets/audio/ui_confirm.mp3');
                Navigator.of(dialogContext).pop(); // Đóng dialog
                Navigator.of(context).pop(); // Quay lại màn hình chính
              },
              child: const Text('Thoát'),
            ),
          ],
        );
      },
    );
  }
}
