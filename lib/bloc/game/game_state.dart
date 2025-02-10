part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.currentScore = 0,
    this.currentPlayingState = PlayingState.none,
  });

  final int currentScore;
  final PlayingState currentPlayingState;

  GameState copyWith({
    int? currentScore,
    PlayingState? currentplayingState,
  }) {
    return GameState(
      currentScore: currentScore ?? this.currentScore,
      currentPlayingState: currentplayingState ?? this.currentPlayingState,
    );
  }

  @override
  List<Object> get props => [
        currentScore,
        currentPlayingState,
      ];
}

enum PlayingState {
  none,
  playing,
  paused,
  gameOver,
}
