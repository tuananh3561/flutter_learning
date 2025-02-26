import 'package:equatable/equatable.dart';

enum GameStatus { initial, playing, paused, gameOver }

class GameState extends Equatable {
  final GameStatus status;
  final int score;
  final int currentLevel;
  final bool isMuted;

  const GameState({
    this.status = GameStatus.initial,
    this.score = 0,
    this.currentLevel = 0,
    this.isMuted = false,
  });

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? currentLevel,
    bool? isMuted,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      currentLevel: currentLevel ?? this.currentLevel,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  @override
  List<Object?> get props => [status, score, currentLevel, isMuted];
}
