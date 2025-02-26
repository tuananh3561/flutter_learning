import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  const GameStarted();
}

class GamePaused extends GameEvent {
  const GamePaused();
}

class GameResumed extends GameEvent {
  const GameResumed();
}

class GameOver extends GameEvent {
  const GameOver();
}

class ScoreUpdated extends GameEvent {
  final int score;
  const ScoreUpdated(this.score);

  @override
  List<Object?> get props => [score];
}

class LevelUpdated extends GameEvent {
  final int level;
  const LevelUpdated(this.level);

  @override
  List<Object?> get props => [level];
}

class AudioToggled extends GameEvent {
  const AudioToggled();
}

class GameReset extends GameEvent {
  const GameReset();
}