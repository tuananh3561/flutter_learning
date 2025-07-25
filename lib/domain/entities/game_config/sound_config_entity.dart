import 'package:equatable/equatable.dart';

/// Sound Effect entity cho cấu hình từng hiệu ứng âm thanh
class SoundEffectEntity extends Equatable {
  final String id;
  final String name;
  final String path;
  final double volume;
  final bool loop;

  const SoundEffectEntity({
    required this.id,
    required this.name,
    required this.path,
    required this.volume,
    this.loop = false,
  });

  @override
  List<Object?> get props => [id, name, path, volume, loop];

  SoundEffectEntity copyWith({
    String? id,
    String? name,
    String? path,
    double? volume,
    bool? loop,
  }) {
    return SoundEffectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      volume: volume ?? this.volume,
      loop: loop ?? this.loop,
    );
  }
}

/// Background Music entity cho cấu hình âm nhạc nền
class BackgroundMusicEntity extends Equatable {
  final bool enabled;
  final String path;
  final double volume;
  final bool loop;
  final double? fadeInDuration;
  final double? fadeOutDuration;
  final bool randomizePlaylist;
  final List<String>? playlist;

  const BackgroundMusicEntity({
    required this.enabled,
    required this.path,
    required this.volume,
    this.loop = true,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.randomizePlaylist = false,
    this.playlist,
  });

  @override
  List<Object?> get props => [
        enabled,
        path,
        volume,
        loop,
        fadeInDuration,
        fadeOutDuration,
        randomizePlaylist,
        playlist,
      ];

  BackgroundMusicEntity copyWith({
    bool? enabled,
    String? path,
    double? volume,
    bool? loop,
    double? fadeInDuration,
    double? fadeOutDuration,
    bool? randomizePlaylist,
    List<String>? playlist,
  }) {
    return BackgroundMusicEntity(
      enabled: enabled ?? this.enabled,
      path: path ?? this.path,
      volume: volume ?? this.volume,
      loop: loop ?? this.loop,
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      fadeOutDuration: fadeOutDuration ?? this.fadeOutDuration,
      randomizePlaylist: randomizePlaylist ?? this.randomizePlaylist,
      playlist: playlist ?? this.playlist,
    );
  }
}

/// Word Sound entity cho cấu hình âm thanh từ vựng
class WordSoundEntity extends Equatable {
  final bool enabled;
  final String pathTemplate;
  final double volume;

  const WordSoundEntity({
    required this.enabled,
    required this.pathTemplate,
    required this.volume,
  });

  @override
  List<Object?> get props => [enabled, pathTemplate, volume];

  WordSoundEntity copyWith({
    bool? enabled,
    String? pathTemplate,
    double? volume,
  }) {
    return WordSoundEntity(
      enabled: enabled ?? this.enabled,
      pathTemplate: pathTemplate ?? this.pathTemplate,
      volume: volume ?? this.volume,
    );
  }
}

/// Sound Configuration entity quản lý tất cả thiết lập âm thanh
class SoundConfigEntity extends Equatable {
  final bool globalSoundEnabled;
  final double globalVolume;
  final BackgroundMusicEntity backgroundMusic;
  final List<SoundEffectEntity> soundEffects;
  final WordSoundEntity wordSounds;

  const SoundConfigEntity({
    required this.globalSoundEnabled,
    required this.globalVolume,
    required this.backgroundMusic,
    required this.soundEffects,
    required this.wordSounds,
  });

  @override
  List<Object?> get props => [
        globalSoundEnabled,
        globalVolume,
        backgroundMusic,
        soundEffects,
        wordSounds,
      ];

  SoundConfigEntity copyWith({
    bool? globalSoundEnabled,
    double? globalVolume,
    BackgroundMusicEntity? backgroundMusic,
    List<SoundEffectEntity>? soundEffects,
    WordSoundEntity? wordSounds,
  }) {
    return SoundConfigEntity(
      globalSoundEnabled: globalSoundEnabled ?? this.globalSoundEnabled,
      globalVolume: globalVolume ?? this.globalVolume,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      soundEffects: soundEffects ?? this.soundEffects,
      wordSounds: wordSounds ?? this.wordSounds,
    );
  }
}
