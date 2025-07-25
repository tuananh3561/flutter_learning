import 'package:flutter_learning/domain/entities/game_config/game_config_entity.dart';
import 'package:flutter_learning/domain/repositories/game_config_repository.dart';

/// UseCase để lấy toàn bộ cấu hình game
class GetGameConfigUseCase {
  final GameConfigRepository repository;

  GetGameConfigUseCase(this.repository);

  /// Lấy cấu hình game theo gameId
  Future<GameConfigEntity> execute(String gameId) async {
    return await repository.getGameConfig(gameId);
  }
}

/// UseCase để lấy cấu hình game từ đường dẫn file
class LoadGameConfigFromPathUseCase {
  final GameConfigRepository repository;

  LoadGameConfigFromPathUseCase(this.repository);

  /// Load cấu hình game từ file
  Future<GameConfigEntity> execute(String filePath) async {
    return await repository.loadGameConfigFromPath(filePath);
  }
}

/// UseCase để lấy danh sách các file cấu hình có sẵn
class GetAvailableConfigPathsUseCase {
  final GameConfigRepository repository;

  GetAvailableConfigPathsUseCase(this.repository);

  /// Lấy danh sách các file cấu hình có sẵn
  Future<List<String>> execute() async {
    return await repository.getAvailableConfigPaths();
  }
}
