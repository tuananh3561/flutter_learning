// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flappy_dash/features/games/commons/audio/audio_helper.dart';
import 'package:nakama/nakama.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(
    this._audioHelper,
  ) : super(const GameState()) {
    _initializeNakama();
  }

  final AudioHelper _audioHelper;

  void _initializeNakama() async {
    final client = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      grpcPort: 7349, // optional
      httpPort: 7350, // optional
    );
    final session = await client.authenticateDevice(
      deviceId: 'test-device-id',
      username: 'tuananh',
    );
    print("Session is: ${session.token}");

    // final list = await client.listLeaderboardRecords(
    //   session: session,
    //   leaderboardName: "main_leaderboard",
    // );

    // print("Leaderboard records: $list");

    // final group = await client.createGroup(
    //   session: session,
    //   name: "Flutter devs",
    //   description: 'This is a cool group for Flutter devs!',
    // );
    // print("Group is created: ${group.id}");
  }

  void startPlaying() {
    _audioHelper.playBackgroundAudio();
    emit(state.copyWith(
      currentPlayingState: PlayingState.playing,
      currentScore: 0,
    ));
  }

  void increaseScore() {
    _audioHelper.playScoreCollectSound();
    emit(state.copyWith(
      currentScore: state.currentScore + 1,
    ));
  }

  void gameOver() {
    _audioHelper.stopBackgroundAudio();
    emit(state.copyWith(
      currentPlayingState: PlayingState.gameOver,
    ));
  }

  void restartGame() {
    emit(state.copyWith(
      currentPlayingState: PlayingState.idle,
      currentScore: 0,
    ));
  }
}
