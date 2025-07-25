import 'package:flutter_learning/domain/entities/game_config/game_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/background_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/sound_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/question_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/answer_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/vocabulary_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/drop_zone_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/anim_spine_config_entity.dart';

/// Repository interface cho quản lý Game Config
abstract class GameConfigRepository {
  /// Lấy toàn bộ cấu hình game
  Future<GameConfigEntity> getGameConfig(String gameId);

  /// Lưu toàn bộ cấu hình game
  Future<void> saveGameConfig(String gameId, GameConfigEntity config);

  /// Lấy cấu hình từ đường dẫn file
  Future<GameConfigEntity> loadGameConfigFromPath(String filePath);

  /// Lưu cấu hình vào đường dẫn file
  Future<void> saveGameConfigToPath(String filePath, GameConfigEntity config);

  /// Lấy danh sách các file cấu hình có sẵn
  Future<List<String>> getAvailableConfigPaths();

  /// Lấy cấu hình phần background
  Future<BackgroundConfigEntity> getBackgroundConfig(String gameId);

  /// Lưu cấu hình phần background
  Future<void> saveBackgroundConfig(
      String gameId, BackgroundConfigEntity config);

  /// Lấy cấu hình phần sound
  Future<SoundConfigEntity> getSoundConfig(String gameId);

  /// Lưu cấu hình phần sound
  Future<void> saveSoundConfig(String gameId, SoundConfigEntity config);

  /// Lấy cấu hình phần question
  Future<QuestionConfigEntity> getQuestionConfig(String gameId);

  /// Lưu cấu hình phần question
  Future<void> saveQuestionConfig(String gameId, QuestionConfigEntity config);

  /// Lấy cấu hình phần answer
  Future<AnswerConfigEntity> getAnswerConfig(String gameId);

  /// Lưu cấu hình phần answer
  Future<void> saveAnswerConfig(String gameId, AnswerConfigEntity config);

  /// Lấy cấu hình phần vocabulary
  Future<VocabularyConfigEntity> getVocabularyConfig(String gameId);

  /// Lưu cấu hình phần vocabulary
  Future<void> saveVocabularyConfig(
      String gameId, VocabularyConfigEntity config);

  /// Lấy cấu hình phần drop zone
  Future<DropZoneConfigEntity> getDropZoneConfig(String gameId);

  /// Lưu cấu hình phần drop zone
  Future<void> saveDropZoneConfig(String gameId, DropZoneConfigEntity config);

  /// Lấy cấu hình phần anim spine
  Future<AnimSpineConfigEntity> getAnimSpineConfig(String gameId);

  /// Lưu cấu hình phần anim spine
  Future<void> saveAnimSpineConfig(String gameId, AnimSpineConfigEntity config);
}
