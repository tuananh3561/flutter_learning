import 'package:equatable/equatable.dart';

/// Các trạng thái của GameManager
abstract class GameManagerState extends Equatable {
  const GameManagerState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class GameInitialState extends GameManagerState {}

/// Trạng thái đang tải
class GameLoadingState extends GameManagerState {}

/// Trạng thái sẵn sàng
class GameReadyState extends GameManagerState {
  final String gameId;

  const GameReadyState({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}

/// Trạng thái đang chơi
class GamePlayingState extends GameManagerState {
  final String gameId;
  final int correctAnswers;
  final int wrongAnswers;
  final int requiredCorrectAnswers;
  final int remainingSeconds;
  final String currentTargetWord;

  const GamePlayingState({
    required this.gameId,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.requiredCorrectAnswers,
    required this.remainingSeconds,
    required this.currentTargetWord,
  });

  @override
  List<Object?> get props => [
        gameId,
        correctAnswers,
        wrongAnswers,
        requiredCorrectAnswers,
        remainingSeconds,
        currentTargetWord,
      ];

  /// Tạo bản sao của trạng thái với các giá trị đã cập nhật
  GamePlayingState copyWith({
    String? gameId,
    int? correctAnswers,
    int? wrongAnswers,
    int? requiredCorrectAnswers,
    int? remainingSeconds,
    String? currentTargetWord,
  }) {
    return GamePlayingState(
      gameId: gameId ?? this.gameId,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      requiredCorrectAnswers:
          requiredCorrectAnswers ?? this.requiredCorrectAnswers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentTargetWord: currentTargetWord ?? this.currentTargetWord,
    );
  }
}

/// Trạng thái tạm dừng
class GamePausedState extends GameManagerState {
  final GamePlayingState gamePlayingState;

  const GamePausedState({required this.gamePlayingState});

  @override
  List<Object?> get props => [gamePlayingState];
}

/// Trạng thái hoàn thành
class GameCompletedState extends GameManagerState {
  final String gameId;
  final int score;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalTime;

  const GameCompletedState({
    required this.gameId,
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalTime,
  });

  @override
  List<Object?> get props =>
      [gameId, score, correctAnswers, wrongAnswers, totalTime];
}

/// Trạng thái thất bại
class GameFailedState extends GameManagerState {
  final String gameId;
  final String errorMessage;

  const GameFailedState({
    required this.gameId,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [gameId, errorMessage];
}
