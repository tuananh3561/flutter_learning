import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../core/services/audio_service.dart';
import 'game_manager_event.dart';
import 'game_manager_state.dart';

/// Bloc quản lý trạng thái của game Feed The Shark
class GameManagerBloc extends Bloc<GameManagerEvent, GameManagerState> {
  final AudioService _audioService = AudioService();
  Timer? _gameTimer;
  static const int _totalGameTimeInSeconds = 300; // 5 phút

  GameManagerBloc() : super(GameInitialState()) {
    on<LoadGameEvent>(_onLoadGame);
    on<StartGameEvent>(_onStartGame);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<CorrectAnswerEvent>(_onCorrectAnswer);
    on<WrongAnswerEvent>(_onWrongAnswer);
    on<CompleteGameEvent>(_onCompleteGame);
    on<ResetGameEvent>(_onResetGame);
    on<UpdateTimeEvent>(_onUpdateTime);
    on<SetTargetWordEvent>(_onSetTargetWord);
  }

  void _onLoadGame(LoadGameEvent event, Emitter<GameManagerState> emit) async {
    emit(GameLoadingState());

    try {
      // Logic tải game ở đây, có thể yêu cầu từ API hoặc local

      // Sau khi tải xong, chuyển sang trạng thái sẵn sàng
      emit(GameReadyState(gameId: event.gameId));
    } catch (e) {
      emit(GameFailedState(
        gameId: event.gameId,
        errorMessage: 'Không thể tải game: ${e.toString()}',
      ));
    }
  }

  void _onStartGame(StartGameEvent event, Emitter<GameManagerState> emit) {
    if (state is GameReadyState) {
      final readyState = state as GameReadyState;

      // Phát nhạc nền khi bắt đầu game
      _audioService
          .playBackgroundMusic('../../assets/Feed the Shark/Nhạc BG.mp3');

      // Khởi tạo trạng thái đang chơi
      final playingState = GamePlayingState(
        gameId: readyState.gameId,
        correctAnswers: 0,
        wrongAnswers: 0,
        requiredCorrectAnswers: 5, // Mặc định cần 5 câu trả lời đúng
        remainingSeconds: _totalGameTimeInSeconds,
        currentTargetWord: '', // Sẽ được cập nhật sau
      );

      emit(playingState);

      // Khởi tạo timer đếm ngược
      _startGameTimer();
    }
  }

  void _onPauseGame(PauseGameEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Tạm dừng nhạc nền
      _audioService.pauseBackgroundMusic();

      // Tạm dừng timer
      _gameTimer?.cancel();

      // Chuyển sang trạng thái tạm dừng
      emit(GamePausedState(gamePlayingState: playingState));
    }
  }

  void _onResumeGame(ResumeGameEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePausedState) {
      final pausedState = state as GamePausedState;

      // Tiếp tục phát nhạc nền
      _audioService.resumeBackgroundMusic();

      // Chuyển về trạng thái đang chơi
      emit(pausedState.gamePlayingState);

      // Khởi động lại timer
      _startGameTimer();
    }
  }

  void _onCorrectAnswer(
      CorrectAnswerEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Phát âm thanh đúng
      _audioService.playSoundEffect('../../assets/Feed the Shark/SFX đúng.mp3');

      // Tăng số câu trả lời đúng
      final newCorrectAnswers = playingState.correctAnswers + 1;

      // Cập nhật trạng thái
      final updatedState = playingState.copyWith(
        correctAnswers: newCorrectAnswers,
      );

      emit(updatedState);

      // Kiểm tra xem đã hoàn thành game chưa
      if (newCorrectAnswers >= playingState.requiredCorrectAnswers) {
        // Hoàn thành game
        add(CompleteGameEvent(score: newCorrectAnswers * 10));
      }
    }
  }

  void _onWrongAnswer(WrongAnswerEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Phát âm thanh sai
      _audioService.playSoundEffect('../../assets/Feed the Shark/SFX sai.mp3');

      // Tăng số câu trả lời sai
      final updatedState = playingState.copyWith(
        wrongAnswers: playingState.wrongAnswers + 1,
      );

      emit(updatedState);
    }
  }

  void _onCompleteGame(
      CompleteGameEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Dừng timer
      _gameTimer?.cancel();

      // Dừng nhạc nền
      _audioService.stopBackgroundMusic();

      // Phát âm thanh chiến thắng
      _audioService.playSoundEffect('../../assets/Feed the Shark/SFX Win.mp3');

      // Chuyển sang trạng thái hoàn thành
      emit(GameCompletedState(
        gameId: playingState.gameId,
        score: event.score,
        correctAnswers: playingState.correctAnswers,
        wrongAnswers: playingState.wrongAnswers,
        totalTime: _totalGameTimeInSeconds - playingState.remainingSeconds,
      ));
    }
  }

  void _onResetGame(ResetGameEvent event, Emitter<GameManagerState> emit) {
    // Dừng timer nếu đang chạy
    _gameTimer?.cancel();

    if (state is GamePlayingState ||
        state is GamePausedState ||
        state is GameCompletedState) {
      String gameId = '';

      if (state is GamePlayingState) {
        gameId = (state as GamePlayingState).gameId;
      } else if (state is GamePausedState) {
        gameId = (state as GamePausedState).gamePlayingState.gameId;
      } else if (state is GameCompletedState) {
        gameId = (state as GameCompletedState).gameId;
      }

      // Reset về trạng thái sẵn sàng
      emit(GameReadyState(gameId: gameId));
    }
  }

  void _onUpdateTime(UpdateTimeEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Cập nhật thời gian còn lại
      emit(playingState.copyWith(
        remainingSeconds: event.remainingSeconds,
      ));

      // Nếu hết thời gian, hoàn thành game
      if (event.remainingSeconds <= 0) {
        add(CompleteGameEvent(score: playingState.correctAnswers * 10));
      }
    }
  }

  void _onSetTargetWord(
      SetTargetWordEvent event, Emitter<GameManagerState> emit) {
    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      // Cập nhật từ mục tiêu mới
      emit(playingState.copyWith(
        currentTargetWord: event.targetWord,
      ));
    }
  }

  /// Khởi động timer đếm ngược
  void _startGameTimer() {
    _gameTimer?.cancel();

    if (state is GamePlayingState) {
      final playingState = state as GamePlayingState;

      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remainingSeconds = playingState.remainingSeconds - 1;
        add(UpdateTimeEvent(remainingSeconds: remainingSeconds));
      });
    }
  }

  @override
  Future<void> close() {
    // Dọn dẹp tài nguyên khi đóng bloc
    _gameTimer?.cancel();
    return super.close();
  }
}
