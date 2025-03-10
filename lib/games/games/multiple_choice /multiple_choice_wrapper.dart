import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/audio_service.dart';
import 'multiple_choice_game.dart';

/// Wrapper cho game Multiple Choice
class MultipleChoiceWrapper extends StatefulWidget {
  /// Constructor
  const MultipleChoiceWrapper({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceWrapper> createState() => _MultipleChoiceWrapperState();
}

class _MultipleChoiceWrapperState extends State<MultipleChoiceWrapper> {
  /// Game instance
  late MultipleChoiceGame _game;

  /// Số lượt chơi cần để hoàn thành game
  final int _requiredRounds = 5;

  /// Số lượng đáp án cho mỗi lượt chơi
  final int _numberOfChoices = 3;

  /// Số từ đúng
  int _correctWords = 0;

  /// Số từ sai
  int _wrongWords = 0;

  /// Từ vựng hiện tại
  String _currentWord = '';

  /// Hiển thị màn hình cảnh báo
  bool _showWarning = false;

  @override
  void initState() {
    super.initState();
    // Force portrait orientation for the game
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    _initGame();
  }

  /// Khởi tạo game
  void _initGame() {
    _game = MultipleChoiceGame(
      gameSize: Vector2(1.sw, 1.sh),
      requiredRounds: _requiredRounds,
      numberOfChoices: _numberOfChoices,
      onGameComplete: _onGameComplete,
      onCorrectMatch: _onCorrectMatch,
      onWrongMatch: _onWrongMatch,
    );
  }

  /// Xử lý khi game kết thúc
  void _onGameComplete() {
    // Hiển thị dialog kết quả
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Correct answers: $_correctWords'),
            Text('Wrong attempts: $_wrongWords'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Quay về màn hình trước
            },
            child: const Text('Back to Home'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset game
              setState(() {
                _correctWords = 0;
                _wrongWords = 0;
                _currentWord = '';
                _initGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  /// Xử lý khi ghép đúng từ
  void _onCorrectMatch(String word) {
    setState(() {
      _correctWords++;
      _currentWord = word;
    });
  }

  /// Xử lý khi ghép sai từ
  void _onWrongMatch(String word) {
    setState(() {
      _wrongWords++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Multiple Choice Game'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.help_outline),
      //       onPressed: () {
      //         setState(() {
      //           _showWarning = true;
      //         });
      //       },
      //     ),
      //   ],
      // ),
      body: _showWarning ? _buildWarningScreen() : _buildGameScreen(),
    );
  }

  /// Xây dựng màn hình cảnh báo
  Widget _buildWarningScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade200, Colors.blue.shade500],
        ),
      ),
      child: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.volume_up,
                  size: 60.w,
                  color: Colors.blue,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Multiple Choice Game',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Listen to the audio and match it with the correct image.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '1. Tap on audio buttons to hear the words\n'
                  '2. Drag the correct audio button to the drop zone below the image\n'
                  '3. Complete $_requiredRounds rounds to finish the game',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: () {
                    AudioService().playSoundEffect(
                        '../../assets/Multiple Choice/SFX click.wav');
                    setState(() {
                      _showWarning = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Start Game',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Xây dựng màn hình game
  Widget _buildGameScreen() {
    return GameWidget(game: _game);
    // return Column(
    //   children: [
    //     // Game stats
    //     Container(
    //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
    //       color: Colors.blue.shade100,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             'Correct: $_correctWords / $_requiredRounds',
    //             style: TextStyle(
    //               fontSize: 6.sp,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.green,
    //             ),
    //           ),
    //           Text(
    //             'Wrong: $_wrongWords',
    //             style: TextStyle(
    //               fontSize: 6.sp,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.red,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     // Game view
    //     Expanded(
    //       child: GameWidget(
    //         game: _game,
    //         overlayBuilderMap: {
    //           'pause_button': (context, game) => Positioned(
    //                 top: 10.h,
    //                 right: 10.w,
    //                 child: IconButton(
    //                   icon: Icon(
    //                     Icons.pause_circle_filled,
    //                     size: 40.w,
    //                     color: Colors.blue.withOpacity(0.8),
    //                   ),
    //                   onPressed: () {
    //                     AudioService().playSoundEffect(
    //                         '../../assets/Multiple Choice/SFX click.wav');
    //                     _showPauseDialog();
    //                   },
    //                 ),
    //               ),
    //         },
    //         initialActiveOverlays: const ['pause_button'],
    //       ),
    //     ),
    //   ],
    // );
  }

  /// Hiển thị dialog tạm dừng
  void _showPauseDialog() {
    // Tạm dừng game
    _game.pauseGame();

    // Hiển thị dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Paused'),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              AudioService().playSoundEffect(
                  '../../assets/Multiple Choice/SFX click.wav');
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Quay về màn hình trước
            },
            child: const Text('Quit'),
          ),
          TextButton(
            onPressed: () {
              AudioService().playSoundEffect(
                  '../../assets/Multiple Choice/SFX click.wav');
              Navigator.of(context).pop();
              // Tiếp tục game
              _game.resumeGame();
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   // Reset orientation when leaving the screen
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   super.dispose();
  // }
}
