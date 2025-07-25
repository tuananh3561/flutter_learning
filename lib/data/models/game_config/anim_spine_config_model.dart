import 'package:flutter_learning/domain/entities/game_config/anim_spine_config_entity.dart';

/// Model class cho SpineAnimation, extend từ SpineAnimationEntity
class SpineAnimationModel extends SpineAnimationEntity {
  const SpineAnimationModel({
    required String id,
    required String name,
    required String skeletonPath,
    required String atlasPath,
    required String defaultAnimation,
    required double scale,
    required Map<String, double> position,
    required bool loop,
    required bool autoPlay,
    List<String>? clickAnimations,
    String? soundPath,
    bool? playSoundOnStart,
  }) : super(
          id: id,
          name: name,
          skeletonPath: skeletonPath,
          atlasPath: atlasPath,
          defaultAnimation: defaultAnimation,
          scale: scale,
          position: position,
          loop: loop,
          autoPlay: autoPlay,
          clickAnimations: clickAnimations,
          soundPath: soundPath,
          playSoundOnStart: playSoundOnStart,
        );

  /// Tạo SpineAnimationModel từ JSON
  factory SpineAnimationModel.fromJson(Map<String, dynamic> json) {
    // Xử lý position từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> position = {};
    if (json['position'] != null) {
      (json['position'] as Map<String, dynamic>).forEach((key, value) {
        position[key] = (value as num).toDouble();
      });
    }

    // Xử lý clickAnimations
    List<String>? clickAnimations;
    if (json['click_animations'] != null) {
      clickAnimations = List<String>.from(json['click_animations']);
    }

    return SpineAnimationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      skeletonPath: json['skeleton_path'] ?? '',
      atlasPath: json['atlas_path'] ?? '',
      defaultAnimation: json['default_animation'] ?? 'Idie',
      scale: json['scale'] != null ? (json['scale'] as num).toDouble() : 1.0,
      position: position,
      loop: json['loop'] ?? true,
      autoPlay: json['auto_play'] ?? true,
      clickAnimations: clickAnimations,
      soundPath: json['sound_path'],
      playSoundOnStart: json['play_sound_on_start'],
    );
  }

  /// Convert SpineAnimationModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'skeleton_path': skeletonPath,
      'atlas_path': atlasPath,
      'default_animation': defaultAnimation,
      'scale': scale,
      'position': position,
      'loop': loop,
      'auto_play': autoPlay,
    };

    if (clickAnimations != null) data['click_animations'] = clickAnimations;
    if (soundPath != null) data['sound_path'] = soundPath;
    if (playSoundOnStart != null)
      data['play_sound_on_start'] = playSoundOnStart;

    return data;
  }

  /// Tạo model từ entity
  factory SpineAnimationModel.fromEntity(SpineAnimationEntity entity) {
    return SpineAnimationModel(
      id: entity.id,
      name: entity.name,
      skeletonPath: entity.skeletonPath,
      atlasPath: entity.atlasPath,
      defaultAnimation: entity.defaultAnimation,
      scale: entity.scale,
      position: entity.position,
      loop: entity.loop,
      autoPlay: entity.autoPlay,
      clickAnimations: entity.clickAnimations,
      soundPath: entity.soundPath,
      playSoundOnStart: entity.playSoundOnStart,
    );
  }
}

/// Model class cho AnimSpine Configuration, extend từ AnimSpineConfigEntity
class AnimSpineConfigModel extends AnimSpineConfigEntity {
  const AnimSpineConfigModel({
    required bool enabled,
    required List<SpineAnimationEntity> spineAnimations,
  }) : super(
          enabled: enabled,
          spineAnimations: spineAnimations,
        );

  /// Tạo AnimSpineConfigModel từ JSON
  factory AnimSpineConfigModel.fromJson(Map<String, dynamic> json) {
    // Xử lý spine animations
    List<SpineAnimationEntity> spineAnimations = [];
    if (json['spine_animations'] != null) {
      spineAnimations = (json['spine_animations'] as List)
          .map((item) => SpineAnimationModel.fromJson(item))
          .toList();
    }

    return AnimSpineConfigModel(
      enabled: json['enabled'] ?? false,
      spineAnimations: spineAnimations,
    );
  }

  /// Convert AnimSpineConfigModel to JSON
  Map<String, dynamic> toJson() {
    // Convert spine animations to JSON
    final List<Map<String, dynamic>> spineAnimationsJsonList = spineAnimations
        .map((item) => item is SpineAnimationModel
            ? item.toJson()
            : SpineAnimationModel.fromEntity(item).toJson())
        .toList();

    return {
      'enabled': enabled,
      'spine_animations': spineAnimationsJsonList,
    };
  }

  /// Tạo model từ entity
  factory AnimSpineConfigModel.fromEntity(AnimSpineConfigEntity entity) {
    // Convert spine animations
    final List<SpineAnimationEntity> spineAnimationModels = entity
        .spineAnimations
        .map((item) => item is SpineAnimationModel
            ? item
            : SpineAnimationModel.fromEntity(item))
        .toList();

    return AnimSpineConfigModel(
      enabled: entity.enabled,
      spineAnimations: spineAnimationModels,
    );
  }
}
