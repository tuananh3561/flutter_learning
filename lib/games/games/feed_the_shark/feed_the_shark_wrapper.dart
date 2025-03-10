import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/game_manager/game_manager.dart';
import '../../../core/services/audio_service.dart';
import 'feed_the_shark_game_screen.dart';

/// Widget wrapper cho game Feed The Shark với tích hợp GameManagerBloc
class FeedTheSharkWrapper extends StatelessWidget {
  /// ID của game
  final String gameId;

  /// Callback khi người chơi hoàn thành game
  final Function? onGameComplete;

  /// Callback khi người chơi nhấn nút Back
  final Function? onBackPressed;

  const FeedTheSharkWrapper({
    Key? key,
    required this.gameId,
    this.onGameComplete,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GameManagerBloc()..add(LoadGameEvent(gameId: gameId)),
      child: Stack(
        children: [
          // Game content with BlocConsumer
          BlocConsumer<GameManagerBloc, GameManagerState>(
            listener: (context, state) {
              if (state is GameCompletedState) {
                // Khi game hoàn thành, gọi callback
                if (onGameComplete != null) {
                  onGameComplete!();
                }
              }
            },
            builder: (context, state) {
              if (state is GameLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GameReadyState) {
                return _buildStartGameScreen(context);
              } else if (state is GamePlayingState) {
                return _buildGameScreen(context, state);
              } else if (state is GamePausedState) {
                return _buildPauseScreen(context, state);
              } else if (state is GameCompletedState) {
                return _buildGameCompleteScreen(context, state);
              } else if (state is GameFailedState) {
                return _buildErrorScreen(context, state);
              } else {
                return const Center(child: Text('Đang khởi tạo game...'));
              }
            },
          ),

          // Back button overlay (always visible)
          Positioned(
            top: 10.h,
            left: 10.w,
            child: _buildBackButton(context),
          ),
        ],
      ),
    );
  }

  /// Tạo nút Back
  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          // Tạm dừng game nếu đang chơi
          final gameBloc = context.read<GameManagerBloc>();
          final currentState = gameBloc.state;
          if (currentState is GamePlayingState) {
            gameBloc.add(PauseGameEvent());
          }

          // Nếu có callback, gọi callback
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            // Mặc định: quay lại màn hình trước đó
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black87,
            size: 24.sp,
          ),
        ),
      ),
    );
  }

  /// Màn hình bắt đầu game
  Widget _buildStartGameScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Feed The Shark',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Tìm và cho cá mập ăn từ đúng!',
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () {
              context.read<GameManagerBloc>().add(StartGameEvent());
            },
            child: const Text('Bắt Đầu Chơi'),
          ),
        ],
      ),
    );
  }

  /// Màn hình game chính
  Widget _buildGameScreen(BuildContext context, GamePlayingState state) {
    final bloc = context.read<GameManagerBloc>();

    // Hàm callback khi tìm thấy từ đúng
    void onCorrectWord(String word) {
      bloc.add(CorrectAnswerEvent(word: word));
    }

    // Hàm callback khi chọn từ sai
    void onWrongWord(String word) {
      bloc.add(WrongAnswerEvent(word: word));
    }

    // Hàm callback khi đặt từ mục tiêu mới
    void onSetTargetWord(String word) {
      bloc.add(SetTargetWordEvent(targetWord: word));
    }

    return Stack(
      children: [
        // Màn hình game
        FeedTheSharkGameScreen(
          requiredCorrectAnswers: state.requiredCorrectAnswers,
          onGameComplete: () {
            // Khi game báo hoàn thành, gửi sự kiện CompleteGame
            bloc.add(CompleteGameEvent(score: state.correctAnswers * 10));
          },
          onCorrectWord: onCorrectWord,
          onWrongWord: onWrongWord,
          onSetTargetWord: onSetTargetWord,
        ),

        // UI phần trên màn hình game
        Positioned(
          top: 20.h,
          left: 10.w,
          right: 10.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nút tạm dừng
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                onPressed: () {
                  bloc.add(PauseGameEvent());
                },
              ),

              // Hiển thị thông tin game
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  'Điểm: ${state.correctAnswers * 10} | Đúng: ${state.correctAnswers}/${state.requiredCorrectAnswers} | Thời gian: ${_formatTime(state.remainingSeconds)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hiển thị từ cần tìm
        if (state.currentTargetWord.isNotEmpty)
          Positioned(
            top: 60.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Hãy tìm từ: ${state.currentTargetWord}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Màn hình tạm dừng
  Widget _buildPauseScreen(BuildContext context, GamePausedState state) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Tạm Dừng',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<GameManagerBloc>().add(ResumeGameEvent());
              },
              icon: Icon(Icons.play_arrow, size: 24.sp),
              label: Text('Tiếp Tục', style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<GameManagerBloc>().add(ResetGameEvent());
              },
              icon: Icon(Icons.refresh, size: 24.sp),
              label: Text('Chơi Lại', style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            ElevatedButton.icon(
              onPressed: () {
                // Phát âm thanh khi nhấn
                AudioService()
                    .playSoundEffect('../../assets/audio/ui_click.mp3');

                // Hiển thị dialog xác nhận
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Quay về Trang Chủ?'),
                      content: const Text(
                          'Bạn có chắc muốn quay về trang chủ? Tiến trình chơi sẽ không được lưu.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                          },
                          child: const Text('Huỷ'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog

                            // Nếu có callback, gọi callback
                            if (onBackPressed != null) {
                              onBackPressed!();
                            } else {
                              // Mặc định: quay lại màn hình trước đó
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Về Trang Chủ'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.home, size: 24.sp),
              label: Text('Trang Chủ', style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Màn hình hoàn thành game
  Widget _buildGameCompleteScreen(
      BuildContext context, GameCompletedState state) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chúc Mừng!',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Bạn đã hoàn thành game',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  _buildStatRow('Điểm số', '${state.score}'),
                  _buildStatRow('Câu trả lời đúng', '${state.correctAnswers}'),
                  _buildStatRow('Câu trả lời sai', '${state.wrongAnswers}'),
                  _buildStatRow('Thời gian', _formatTime(state.totalTime)),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                context.read<GameManagerBloc>().add(ResetGameEvent());
              },
              child: const Text('Chơi Lại'),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () {
                // Quay lại màn hình chọn game
                if (onGameComplete != null) {
                  onGameComplete!();
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('Trở Về Menu'),
            ),
          ],
        ),
      ),
    );
  }

  /// Màn hình lỗi
  Widget _buildErrorScreen(BuildContext context, GameFailedState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          SizedBox(height: 20.h),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () {
              context
                  .read<GameManagerBloc>()
                  .add(LoadGameEvent(gameId: state.gameId));
            },
            child: const Text('Thử Lại'),
          ),
        ],
      ),
    );
  }

  /// Helper để hiển thị hàng thống kê
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Format thời gian từ giây sang mm:ss
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
