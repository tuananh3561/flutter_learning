import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  void startPlaying() {
    emit(state.copyWith(
      currentplayingState: PlayingState.playing,
      currentScore: 0,
    ));
  }

  void incrementScore() {
    emit(state.copyWith(
      currentScore: state.currentScore + 1,
    ));
  }

  void gameOver() {
    emit(state.copyWith(
      currentplayingState: PlayingState.gameOver,
    ));
  }

  void restartGame() {
    emit(state.copyWith(
      currentplayingState: PlayingState.none,
      currentScore: 0,
    ));
  }
}
