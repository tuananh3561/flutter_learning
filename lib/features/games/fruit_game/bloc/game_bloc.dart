import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<GameStarted>(_onGameStarted);
    on<GamePaused>(_onGamePaused);
    on<GameResumed>(_onGameResumed);
    on<GameOver>(_onGameOver);
    on<ScoreUpdated>(_onScoreUpdated);
    on<LevelUpdated>(_onLevelUpdated);
    on<AudioToggled>(_onAudioToggled);
    on<GameReset>(_onGameReset);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(state.copyWith(
      status: GameStatus.playing,
      score: 0,
      currentLevel: 0,
    ));
  }

  void _onGamePaused(GamePaused event, Emitter<GameState> emit) {
    if (state.status == GameStatus.playing) {
      emit(state.copyWith(status: GameStatus.paused));
    }
  }

  void _onGameResumed(GameResumed event, Emitter<GameState> emit) {
    if (state.status == GameStatus.paused) {
      emit(state.copyWith(status: GameStatus.playing));
    }
  }

  void _onGameOver(GameOver event, Emitter<GameState> emit) {
    emit(state.copyWith(status: GameStatus.gameOver));
  }

  void _onScoreUpdated(ScoreUpdated event, Emitter<GameState> emit) {
    emit(state.copyWith(score: event.score));
  }

  void _onLevelUpdated(LevelUpdated event, Emitter<GameState> emit) {
    emit(state.copyWith(currentLevel: event.level));
  }

  void _onAudioToggled(AudioToggled event, Emitter<GameState> emit) {
    emit(state.copyWith(isMuted: !state.isMuted));
  }

  void _onGameReset(GameReset event, Emitter<GameState> emit) {
    emit(const GameState());
  }
}