import 'package:equatable/equatable.dart';
import 'background_config_entity.dart';
import 'sound_config_entity.dart';
import 'question_config_entity.dart';
import 'answer_config_entity.dart';
import 'vocabulary_config_entity.dart';
import 'drop_zone_config_entity.dart';
import 'anim_spine_config_entity.dart';

/// Entity class chứa tất cả thông tin cấu hình của game
class GameConfigEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String gamePath;
  final BackgroundConfigEntity backgroundConfig;
  final SoundConfigEntity soundConfig;
  final QuestionConfigEntity questionConfig;
  final AnswerConfigEntity answerConfig;
  final VocabularyConfigEntity vocabularyConfig;
  final DropZoneConfigEntity dropZoneConfig;
  final AnimSpineConfigEntity animSpineConfig;
  final Map<String, dynamic> additionalSettings;

  const GameConfigEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.gamePath,
    required this.backgroundConfig,
    required this.soundConfig,
    required this.questionConfig,
    required this.answerConfig,
    required this.vocabularyConfig,
    required this.dropZoneConfig,
    required this.animSpineConfig,
    this.additionalSettings = const {},
  });

  /// Clone object với những thay đổi được truyền vào
  GameConfigEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? gamePath,
    BackgroundConfigEntity? backgroundConfig,
    SoundConfigEntity? soundConfig,
    QuestionConfigEntity? questionConfig,
    AnswerConfigEntity? answerConfig,
    VocabularyConfigEntity? vocabularyConfig,
    DropZoneConfigEntity? dropZoneConfig,
    AnimSpineConfigEntity? animSpineConfig,
    Map<String, dynamic>? additionalSettings,
  }) {
    return GameConfigEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      gamePath: gamePath ?? this.gamePath,
      backgroundConfig: backgroundConfig ?? this.backgroundConfig,
      soundConfig: soundConfig ?? this.soundConfig,
      questionConfig: questionConfig ?? this.questionConfig,
      answerConfig: answerConfig ?? this.answerConfig,
      vocabularyConfig: vocabularyConfig ?? this.vocabularyConfig,
      dropZoneConfig: dropZoneConfig ?? this.dropZoneConfig,
      animSpineConfig: animSpineConfig ?? this.animSpineConfig,
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        gamePath,
        backgroundConfig,
        soundConfig,
        questionConfig,
        answerConfig,
        vocabularyConfig,
        dropZoneConfig,
        animSpineConfig,
        additionalSettings,
      ];
}
