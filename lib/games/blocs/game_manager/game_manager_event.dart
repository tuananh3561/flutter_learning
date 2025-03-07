import 'package:equatable/equatable.dart';

/// Các sự kiện của GameManager
abstract class GameManagerEvent extends Equatable {
  const GameManagerEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện tải game
class LoadGameEvent extends GameManagerEvent {
  final String gameId;

  const LoadGameEvent({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}

/// Sự kiện bắt đầu game
class StartGameEvent extends GameManagerEvent {}

/// Sự kiện tạm dừng game
class PauseGameEvent extends GameManagerEvent {}

/// Sự kiện tiếp tục game
class ResumeGameEvent extends GameManagerEvent {}

/// Sự kiện trả lời đúng
class CorrectAnswerEvent extends GameManagerEvent {
  final String word;

  const CorrectAnswerEvent({required this.word});

  @override
  List<Object?> get props => [word];
}

/// Sự kiện trả lời sai
class WrongAnswerEvent extends GameManagerEvent {
  final String word;

  const WrongAnswerEvent({required this.word});

  @override
  List<Object?> get props => [word];
}

/// Sự kiện hoàn thành game
class CompleteGameEvent extends GameManagerEvent {
  final int score;

  const CompleteGameEvent({required this.score});

  @override
  List<Object?> get props => [score];
}

/// Sự kiện reset game
class ResetGameEvent extends GameManagerEvent {}

/// Sự kiện cập nhật thời gian
class UpdateTimeEvent extends GameManagerEvent {
  final int remainingSeconds;

  const UpdateTimeEvent({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];
}

/// Sự kiện đặt từ mục tiêu mới
class SetTargetWordEvent extends GameManagerEvent {
  final String targetWord;

  const SetTargetWordEvent({required this.targetWord});

  @override
  List<Object?> get props => [targetWord];
}
