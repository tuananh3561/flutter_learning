import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feed_the_shark_game.dart';

/// Widget để hiển thị màn hình game Feed The Shark
class FeedTheSharkGameScreen extends StatefulWidget {
  /// Số lượng câu trả lời đúng cần để hoàn thành game
  final int requiredCorrectAnswers;

  /// Callback được gọi khi hoàn thành game
  final Function? onGameComplete;

  /// Callback được gọi khi chọn từ đúng
  final Function(String)? onCorrectWord;

  /// Callback được gọi khi chọn từ sai
  final Function(String)? onWrongWord;

  /// Callback được gọi khi đặt từ mục tiêu mới
  final Function(String)? onSetTargetWord;

  const FeedTheSharkGameScreen({
    Key? key,
    this.requiredCorrectAnswers = 5,
    this.onGameComplete,
    this.onCorrectWord,
    this.onWrongWord,
    this.onSetTargetWord,
  }) : super(key: key);

  @override
  State<FeedTheSharkGameScreen> createState() => _FeedTheSharkGameScreenState();
}

class _FeedTheSharkGameScreenState extends State<FeedTheSharkGameScreen> {
  late FeedTheSharkGame _game;

  @override
  void initState() {
    super.initState();

    // Khởi tạo game với các callback
    _game = FeedTheSharkGame(
      gameSize: Vector2(1024, 576), // Kích thước mặc định cho game
      requiredCorrectAnswers: widget.requiredCorrectAnswers,
      onGameComplete: widget.onGameComplete,
      onCorrectWord: widget.onCorrectWord,
      onWrongWord: widget.onWrongWord,
      onSetTargetWord: widget.onSetTargetWord,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue[100],
      child: GameWidget(
        game: _game,
        // Hiển thị vòng loading khi game đang tải
        loadingBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10.h),
              Text(
                'Đang tải game...',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Xử lý lỗi nếu có
        errorBuilder: (context, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10.h),
              Text(
                'Có lỗi xảy ra: $error',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên khi widget bị hủy
    _game.onGameEnd();
    super.dispose();
  }
}
