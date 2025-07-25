import 'package:flutter_learning/domain/entities/game_config/game_config_entity.dart';
import 'package:flutter_learning/domain/repositories/game_config_repository.dart';

/// UseCase để lưu toàn bộ cấu hình game
class SaveGameConfigUseCase {
  final GameConfigRepository repository;

  SaveGameConfigUseCase(this.repository);

  /// Lưu cấu hình game theo gameId
  Future<void> execute(String gameId, GameConfigEntity config) async {
    return await repository.saveGameConfig(gameId, config);
  }
}

/// UseCase để lưu cấu hình game vào đường dẫn file
class SaveGameConfigToPathUseCase {
  final GameConfigRepository repository;

  SaveGameConfigToPathUseCase(this.repository);

  /// Lưu cấu hình game vào file
  Future<void> execute(String filePath, GameConfigEntity config) async {
    return await repository.saveGameConfigToPath(filePath, config);
  }
}
