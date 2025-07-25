import 'package:flutter_learning/domain/entities/game_config/game_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/background_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/sound_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/question_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/answer_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/vocabulary_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/drop_zone_config_entity.dart';
import 'package:flutter_learning/domain/entities/game_config/anim_spine_config_entity.dart';
import 'background_config_model.dart';
import 'sound_config_model.dart';
import 'question_config_model.dart';
import 'answer_config_model.dart';
import 'vocabulary_config_model.dart';
import 'drop_zone_config_model.dart';
import 'anim_spine_config_model.dart';

/// Model class cho Game Config, extend từ GameConfigEntity
class GameConfigModel extends GameConfigEntity {
  const GameConfigModel({
    required String id,
    required String name,
    required String description,
    required String gamePath,
    required BackgroundConfigEntity backgroundConfig,
    required SoundConfigEntity soundConfig,
    required QuestionConfigEntity questionConfig,
    required AnswerConfigEntity answerConfig,
    required VocabularyConfigEntity vocabularyConfig,
    required DropZoneConfigEntity dropZoneConfig,
    required AnimSpineConfigEntity animSpineConfig,
    Map<String, dynamic> additionalSettings = const {},
  }) : super(
          id: id,
          name: name,
          description: description,
          gamePath: gamePath,
          backgroundConfig: backgroundConfig,
          soundConfig: soundConfig,
          questionConfig: questionConfig,
          answerConfig: answerConfig,
          vocabularyConfig: vocabularyConfig,
          dropZoneConfig: dropZoneConfig,
          animSpineConfig: animSpineConfig,
          additionalSettings: additionalSettings,
        );

  /// Tạo GameConfigModel từ JSON
  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      gamePath: json['game_path'] ?? '',
      backgroundConfig:
          BackgroundConfigModel.fromJson(json['background_config'] ?? {}),
      soundConfig: SoundConfigModel.fromJson(json['sound_config'] ?? {}),
      questionConfig:
          QuestionConfigModel.fromJson(json['question_config'] ?? {}),
      answerConfig: AnswerConfigModel.fromJson(json['answer_config'] ?? {}),
      vocabularyConfig:
          VocabularyConfigModel.fromJson(json['vocabulary_config'] ?? {}),
      dropZoneConfig:
          DropZoneConfigModel.fromJson(json['drop_zone_config'] ?? {}),
      animSpineConfig:
          AnimSpineConfigModel.fromJson(json['anim_spine_config'] ?? {}),
      additionalSettings: json['additional_settings'] ?? {},
    );
  }

  /// Convert GameConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'game_path': gamePath,
      'background_config': backgroundConfig is BackgroundConfigModel
          ? (backgroundConfig as BackgroundConfigModel).toJson()
          : {},
      'sound_config': soundConfig is SoundConfigModel
          ? (soundConfig as SoundConfigModel).toJson()
          : {},
      'question_config': questionConfig is QuestionConfigModel
          ? (questionConfig as QuestionConfigModel).toJson()
          : {},
      'answer_config': answerConfig is AnswerConfigModel
          ? (answerConfig as AnswerConfigModel).toJson()
          : {},
      'vocabulary_config': vocabularyConfig is VocabularyConfigModel
          ? (vocabularyConfig as VocabularyConfigModel).toJson()
          : {},
      'drop_zone_config': dropZoneConfig is DropZoneConfigModel
          ? (dropZoneConfig as DropZoneConfigModel).toJson()
          : {},
      'anim_spine_config': animSpineConfig is AnimSpineConfigModel
          ? (animSpineConfig as AnimSpineConfigModel).toJson()
          : {},
      'additional_settings': additionalSettings,
    };
  }

  /// Tạo model từ entity
  factory GameConfigModel.fromEntity(GameConfigEntity entity) {
    return GameConfigModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      gamePath: entity.gamePath,
      backgroundConfig: entity.backgroundConfig,
      soundConfig: entity.soundConfig,
      questionConfig: entity.questionConfig,
      answerConfig: entity.answerConfig,
      vocabularyConfig: entity.vocabularyConfig,
      dropZoneConfig: entity.dropZoneConfig,
      animSpineConfig: entity.animSpineConfig,
      additionalSettings: entity.additionalSettings,
    );
  }
}
