import 'package:nakama/nakama.dart';

class NakamaDataSource {
  final client = getNakamaClient(
    host: '127.0.0.1',
    ssl: false,
    serverKey: 'defaultkey',
    grpcPort: 7349, // optional
    httpPort: 7350, // optional
  );

  late Session _currentSession;

  Future<Session> initSession(
    String deviceId,
    String username,
  ) async {
    _currentSession = await client.authenticateDevice(
      deviceId: deviceId,
      username: username,
    );

    return _currentSession;
  }

  Future<LeaderboardRecordList> retrieveLeaderboard(
      String leaderboardName) async {
    final list = await client.listLeaderboardRecords(
      session: _currentSession,
      leaderboardName: leaderboardName,
    );

    return list;
  }

  Future<LeaderboardRecord> submitScore(
    int score,
    String leaderboardName,
  ) async {
    return client.writeLeaderboardRecord(
      session: _currentSession,
      leaderboardName: leaderboardName,
      score: score,
    );
  }
}
