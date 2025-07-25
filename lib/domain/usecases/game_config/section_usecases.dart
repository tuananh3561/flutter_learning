import 'package:flutter_learning/domain/entities/game_config/background_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/sound_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/question_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/answer_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/vocabulary_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/drop_zone_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/anim_spine_config_entity.dart';
import 'package:flutter_learning/domain/repositories/game_config_repository.dart';

/// ===== Background Config UseCases =====

/// UseCase để lấy cấu hình background
class GetBackgroundConfigUseCase {
  final GameConfigRepository repository;

  GetBackgroundConfigUseCase(this.repository);

  Future<BackgroundConfigEntity> execute(String gameId) async {
    return await repository.getBackgroundConfig(gameId);
  }
}

/// UseCase để lưu cấu hình background
class SaveBackgroundConfigUseCase {
  final GameConfigRepository repository;

  SaveBackgroundConfigUseCase(this.repository);

  Future<void> execute(String gameId, BackgroundConfigEntity config) async {
    return await repository.saveBackgroundConfig(gameId, config);
  }
}

/// ===== Sound Config UseCases =====

/// UseCase để lấy cấu hình sound
class GetSoundConfigUseCase {
  final GameConfigRepository repository;

  GetSoundConfigUseCase(this.repository);

  Future<SoundConfigEntity> execute(String gameId) async {
    return await repository.getSoundConfig(gameId);
  }
}

/// UseCase để lưu cấu hình sound
class SaveSoundConfigUseCase {
  final GameConfigRepository repository;

  SaveSoundConfigUseCase(this.repository);

  Future<void> execute(String gameId, SoundConfigEntity config) async {
    return await repository.saveSoundConfig(gameId, config);
  }
}

/// ===== Question Config UseCases =====

/// UseCase để lấy cấu hình question
class GetQuestionConfigUseCase {
  final GameConfigRepository repository;

  GetQuestionConfigUseCase(this.repository);

  Future<QuestionConfigEntity> execute(String gameId) async {
    return await repository.getQuestionConfig(gameId);
  }
}

/// UseCase để lưu cấu hình question
class SaveQuestionConfigUseCase {
  final GameConfigRepository repository;

  SaveQuestionConfigUseCase(this.repository);

  Future<void> execute(String gameId, QuestionConfigEntity config) async {
    return await repository.saveQuestionConfig(gameId, config);
  }
}

/// ===== Answer Config UseCases =====

/// UseCase để lấy cấu hình answer
class GetAnswerConfigUseCase {
  final GameConfigRepository repository;

  GetAnswerConfigUseCase(this.repository);

  Future<AnswerConfigEntity> execute(String gameId) async {
    return await repository.getAnswerConfig(gameId);
  }
}

/// UseCase để lưu cấu hình answer
class SaveAnswerConfigUseCase {
  final GameConfigRepository repository;

  SaveAnswerConfigUseCase(this.repository);

  Future<void> execute(String gameId, AnswerConfigEntity config) async {
    return await repository.saveAnswerConfig(gameId, config);
  }
}

/// ===== Vocabulary Config UseCases =====

/// UseCase để lấy cấu hình vocabulary
class GetVocabularyConfigUseCase {
  final GameConfigRepository repository;

  GetVocabularyConfigUseCase(this.repository);

  Future<VocabularyConfigEntity> execute(String gameId) async {
    return await repository.getVocabularyConfig(gameId);
  }
}

/// UseCase để lưu cấu hình vocabulary
class SaveVocabularyConfigUseCase {
  final GameConfigRepository repository;

  SaveVocabularyConfigUseCase(this.repository);

  Future<void> execute(String gameId, VocabularyConfigEntity config) async {
    return await repository.saveVocabularyConfig(gameId, config);
  }
}

/// ===== Drop Zone Config UseCases =====

/// UseCase để lấy cấu hình drop zone
class GetDropZoneConfigUseCase {
  final GameConfigRepository repository;

  GetDropZoneConfigUseCase(this.repository);

  Future<DropZoneConfigEntity> execute(String gameId) async {
    return await repository.getDropZoneConfig(gameId);
  }
}

/// UseCase để lưu cấu hình drop zone
class SaveDropZoneConfigUseCase {
  final GameConfigRepository repository;

  SaveDropZoneConfigUseCase(this.repository);

  Future<void> execute(String gameId, DropZoneConfigEntity config) async {
    return await repository.saveDropZoneConfig(gameId, config);
  }
}

/// ===== Anim Spine Config UseCases =====

/// UseCase để lấy cấu hình anim spine
class GetAnimSpineConfigUseCase {
  final GameConfigRepository repository;

  GetAnimSpineConfigUseCase(this.repository);

  Future<AnimSpineConfigEntity> execute(String gameId) async {
    return await repository.getAnimSpineConfig(gameId);
  }
}

/// UseCase để lưu cấu hình anim spine
class SaveAnimSpineConfigUseCase {
  final GameConfigRepository repository;

  SaveAnimSpineConfigUseCase(this.repository);

  Future<void> execute(String gameId, AnimSpineConfigEntity config) async {
    return await repository.saveAnimSpineConfig(gameId, config);
  }
}
