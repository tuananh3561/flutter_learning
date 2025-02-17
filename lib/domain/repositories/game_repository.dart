import 'package:flappy_dash/data/local/device_data_source.dart';
import 'package:flappy_dash/data/remote/nakama_data_source.dart';
import 'package:nakama/nakama.dart';

class GameRepository {
  final DeviceDataSource _deviceDataSource;
  final NakamaDataSource _nakamaDataSource;

  GameRepository(this._deviceDataSource, this._nakamaDataSource);

  Future<Session> initSession() async {
    final deviceId = await _deviceDataSource.getDeviceId();
    final session = _nakamaDataSource.initSession(deviceId, 'tuananh');
    return session;
  }

  Future<LeaderboardRecordList> getLeaderboard(String leaderboardName) =>
      _nakamaDataSource.retrieveLeaderboard(leaderboardName);

  Future<LeaderboardRecord> submitScore(int score, String leaderboardName) =>
      _nakamaDataSource.submitScore(score, leaderboardName);
}
