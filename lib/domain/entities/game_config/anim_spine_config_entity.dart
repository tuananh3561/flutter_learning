import 'package:equatable/equatable.dart';

/// Entity class cho cấu hình spine animation
class SpineAnimationEntity extends Equatable {
  final String id;
  final String name;
  final String skeletonPath;
  final String atlasPath;
  final String defaultAnimation;
  final double scale;
  final Map<String, double> position;
  final bool loop;
  final bool autoPlay;
  final List<String>? clickAnimations;
  final String? soundPath;
  final bool? playSoundOnStart;

  const SpineAnimationEntity({
    required this.id,
    required this.name,
    required this.skeletonPath,
    required this.atlasPath,
    required this.defaultAnimation,
    required this.scale,
    required this.position,
    required this.loop,
    required this.autoPlay,
    this.clickAnimations,
    this.soundPath,
    this.playSoundOnStart,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        skeletonPath,
        atlasPath,
        defaultAnimation,
        scale,
        position,
        loop,
        autoPlay,
        clickAnimations,
        soundPath,
        playSoundOnStart,
      ];

  SpineAnimationEntity copyWith({
    String? id,
    String? name,
    String? skeletonPath,
    String? atlasPath,
    String? defaultAnimation,
    double? scale,
    Map<String, double>? position,
    bool? loop,
    bool? autoPlay,
    List<String>? clickAnimations,
    String? soundPath,
    bool? playSoundOnStart,
  }) {
    return SpineAnimationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      skeletonPath: skeletonPath ?? this.skeletonPath,
      atlasPath: atlasPath ?? this.atlasPath,
      defaultAnimation: defaultAnimation ?? this.defaultAnimation,
      scale: scale ?? this.scale,
      position: position ?? this.position,
      loop: loop ?? this.loop,
      autoPlay: autoPlay ?? this.autoPlay,
      clickAnimations: clickAnimations ?? this.clickAnimations,
      soundPath: soundPath ?? this.soundPath,
      playSoundOnStart: playSoundOnStart ?? this.playSoundOnStart,
    );
  }
}

/// Entity class cho cấu hình tổng thể animation và spine
class AnimSpineConfigEntity extends Equatable {
  final bool enabled;
  final List<SpineAnimationEntity> spineAnimations;

  const AnimSpineConfigEntity({
    required this.enabled,
    required this.spineAnimations,
  });

  @override
  List<Object?> get props => [enabled, spineAnimations];

  AnimSpineConfigEntity copyWith({
    bool? enabled,
    List<SpineAnimationEntity>? spineAnimations,
  }) {
    return AnimSpineConfigEntity(
      enabled: enabled ?? this.enabled,
      spineAnimations: spineAnimations ?? this.spineAnimations,
    );
  }
}
