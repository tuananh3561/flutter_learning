import 'package:flutter_learning/domain/entities/game_config/sound_config_entity.dart';

/// Model class cho Sound Effect, extend từ SoundEffectEntity
class SoundEffectModel extends SoundEffectEntity {
  const SoundEffectModel({
    required String id,
    required String name,
    required String path,
    required double volume,
    bool loop = false,
  }) : super(
          id: id,
          name: name,
          path: path,
          volume: volume,
          loop: loop,
        );

  /// Tạo SoundEffectModel từ JSON
  factory SoundEffectModel.fromJson(Map<String, dynamic> json) {
    return SoundEffectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      volume: json['volume'] != null ? (json['volume'] as num).toDouble() : 1.0,
      loop: json['loop'] ?? false,
    );
  }

  /// Convert SoundEffectModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'volume': volume,
      'loop': loop,
    };
  }

  /// Tạo model từ entity
  factory SoundEffectModel.fromEntity(SoundEffectEntity entity) {
    return SoundEffectModel(
      id: entity.id,
      name: entity.name,
      path: entity.path,
      volume: entity.volume,
      loop: entity.loop,
    );
  }
}

/// Model class cho Background Music, extend từ BackgroundMusicEntity
class BackgroundMusicModel extends BackgroundMusicEntity {
  const BackgroundMusicModel({
    required bool enabled,
    required String path,
    required double volume,
    bool loop = true,
    double? fadeInDuration,
    double? fadeOutDuration,
    bool randomizePlaylist = false,
    List<String>? playlist,
  }) : super(
          enabled: enabled,
          path: path,
          volume: volume,
          loop: loop,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          randomizePlaylist: randomizePlaylist,
          playlist: playlist,
        );

  /// Tạo BackgroundMusicModel từ JSON
  factory BackgroundMusicModel.fromJson(Map<String, dynamic> json) {
    List<String>? playlist;
    if (json['playlist'] != null) {
      playlist = (json['playlist'] as List).cast<String>();
    }

    return BackgroundMusicModel(
      enabled: json['enabled'] ?? false,
      path: json['path'] ?? '',
      volume: json['volume'] != null ? (json['volume'] as num).toDouble() : 1.0,
      loop: json['loop'] ?? true,
      fadeInDuration: json['fade_in_duration'] != null
          ? (json['fade_in_duration'] as num).toDouble()
          : null,
      fadeOutDuration: json['fade_out_duration'] != null
          ? (json['fade_out_duration'] as num).toDouble()
          : null,
      randomizePlaylist: json['randomize_playlist'] ?? false,
      playlist: playlist,
    );
  }

  /// Convert BackgroundMusicModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'enabled': enabled,
      'path': path,
      'volume': volume,
      'loop': loop,
      'randomize_playlist': randomizePlaylist,
    };

    if (fadeInDuration != null) data['fade_in_duration'] = fadeInDuration;
    if (fadeOutDuration != null) data['fade_out_duration'] = fadeOutDuration;
    if (playlist != null) data['playlist'] = playlist;

    return data;
  }

  /// Tạo model từ entity
  factory BackgroundMusicModel.fromEntity(BackgroundMusicEntity entity) {
    return BackgroundMusicModel(
      enabled: entity.enabled,
      path: entity.path,
      volume: entity.volume,
      loop: entity.loop,
      fadeInDuration: entity.fadeInDuration,
      fadeOutDuration: entity.fadeOutDuration,
      randomizePlaylist: entity.randomizePlaylist,
      playlist: entity.playlist,
    );
  }
}

/// Model class cho Word Sound, extend từ WordSoundEntity
class WordSoundModel extends WordSoundEntity {
  const WordSoundModel({
    required bool enabled,
    required String pathTemplate,
    required double volume,
  }) : super(
          enabled: enabled,
          pathTemplate: pathTemplate,
          volume: volume,
        );

  /// Tạo WordSoundModel từ JSON
  factory WordSoundModel.fromJson(Map<String, dynamic> json) {
    return WordSoundModel(
      enabled: json['enabled'] ?? false,
      pathTemplate: json['path_template'] ?? '',
      volume: json['volume'] != null ? (json['volume'] as num).toDouble() : 1.0,
    );
  }

  /// Convert WordSoundModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'path_template': pathTemplate,
      'volume': volume,
    };
  }

  /// Tạo model từ entity
  factory WordSoundModel.fromEntity(WordSoundEntity entity) {
    return WordSoundModel(
      enabled: entity.enabled,
      pathTemplate: entity.pathTemplate,
      volume: entity.volume,
    );
  }
}

/// Model class cho Sound Configuration, extend từ SoundConfigEntity
class SoundConfigModel extends SoundConfigEntity {
  const SoundConfigModel({
    required bool globalSoundEnabled,
    required double globalVolume,
    required BackgroundMusicEntity backgroundMusic,
    required List<SoundEffectEntity> soundEffects,
    required WordSoundEntity wordSounds,
  }) : super(
          globalSoundEnabled: globalSoundEnabled,
          globalVolume: globalVolume,
          backgroundMusic: backgroundMusic,
          soundEffects: soundEffects,
          wordSounds: wordSounds,
        );

  /// Tạo SoundConfigModel từ JSON
  factory SoundConfigModel.fromJson(Map<String, dynamic> json) {
    // Parse background music
    BackgroundMusicEntity backgroundMusic;
    if (json['background_music'] != null) {
      backgroundMusic = BackgroundMusicModel.fromJson(json['background_music']);
    } else {
      backgroundMusic = BackgroundMusicModel(
        enabled: false,
        path: '',
        volume: 1.0,
      );
    }

    // Parse sound effects
    List<SoundEffectEntity> soundEffects = [];
    if (json['sound_effects'] != null) {
      soundEffects = (json['sound_effects'] as List)
          .map((item) => SoundEffectModel.fromJson(item))
          .toList();
    }

    // Parse word sounds
    WordSoundEntity wordSounds;
    if (json['word_sounds'] != null) {
      wordSounds = WordSoundModel.fromJson(json['word_sounds']);
    } else {
      wordSounds = WordSoundModel(
        enabled: false,
        pathTemplate: '',
        volume: 1.0,
      );
    }

    return SoundConfigModel(
      globalSoundEnabled: json['global_sound_enabled'] ?? true,
      globalVolume: json['global_volume'] != null
          ? (json['global_volume'] as num).toDouble()
          : 1.0,
      backgroundMusic: backgroundMusic,
      soundEffects: soundEffects,
      wordSounds: wordSounds,
    );
  }

  /// Convert SoundConfigModel to JSON
  Map<String, dynamic> toJson() {
    // Convert sound effects to JSON
    final List<Map<String, dynamic>> soundEffectsJsonList = soundEffects
        .map((item) => item is SoundEffectModel
            ? item.toJson()
            : SoundEffectModel.fromEntity(item).toJson())
        .toList();

    return {
      'global_sound_enabled': globalSoundEnabled,
      'global_volume': globalVolume,
      'background_music': backgroundMusic is BackgroundMusicModel
          ? (backgroundMusic as BackgroundMusicModel).toJson()
          : BackgroundMusicModel.fromEntity(backgroundMusic).toJson(),
      'sound_effects': soundEffectsJsonList,
      'word_sounds': wordSounds is WordSoundModel
          ? (wordSounds as WordSoundModel).toJson()
          : WordSoundModel.fromEntity(wordSounds).toJson(),
    };
  }

  /// Tạo model từ entity
  factory SoundConfigModel.fromEntity(SoundConfigEntity entity) {
    // Convert background music
    final backgroundMusicModel = entity.backgroundMusic is BackgroundMusicModel
        ? entity.backgroundMusic as BackgroundMusicModel
        : BackgroundMusicModel.fromEntity(entity.backgroundMusic);

    // Convert sound effects
    final List<SoundEffectEntity> soundEffectModels = entity.soundEffects
        .map((item) =>
            item is SoundEffectModel ? item : SoundEffectModel.fromEntity(item))
        .toList();

    // Convert word sounds
    final wordSoundsModel = entity.wordSounds is WordSoundModel
        ? entity.wordSounds as WordSoundModel
        : WordSoundModel.fromEntity(entity.wordSounds);

    return SoundConfigModel(
      globalSoundEnabled: entity.globalSoundEnabled,
      globalVolume: entity.globalVolume,
      backgroundMusic: backgroundMusicModel,
      soundEffects: soundEffectModels,
      wordSounds: wordSoundsModel,
    );
  }
}
