import 'package:flutter_learning/domain/entities/game_config/background_config_entity.dart';

/// Model class cho Decoration Item, extend từ DecorationItemEntity
class DecorationItemModel extends DecorationItemEntity {
  const DecorationItemModel({
    required String id,
    required String type,
    required double scale,
    required Map<String, double> position,
    String? imagePath,
    String? animationName,
    String? skeletonPath,
    String? atlasPath,
    bool? looping,
    bool? autoStart,
  }) : super(
          id: id,
          type: type,
          scale: scale,
          position: position,
          imagePath: imagePath,
          animationName: animationName,
          skeletonPath: skeletonPath,
          atlasPath: atlasPath,
          looping: looping,
          autoStart: autoStart,
        );

  /// Tạo DecorationItemModel từ JSON
  factory DecorationItemModel.fromJson(Map<String, dynamic> json) {
    // Xử lý position từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> position = {};
    if (json['position'] != null) {
      (json['position'] as Map<String, dynamic>).forEach((key, value) {
        position[key] = (value as num).toDouble();
      });
    }

    return DecorationItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'image',
      scale: json['scale'] != null ? (json['scale'] as num).toDouble() : 1.0,
      position: position,
      imagePath: json['image'],
      animationName: json['animation'],
      skeletonPath: json['skeleton'],
      atlasPath: json['atlas'],
      looping: json['looping'],
      autoStart: json['auto_start'],
    );
  }

  /// Convert DecorationItemModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'type': type,
      'scale': scale,
      'position': position,
    };

    // Thêm các thuộc tính tùy theo loại
    switch (type) {
      case 'image':
        if (imagePath != null) data['image'] = imagePath;
        break;
      case 'animation':
        if (imagePath != null) data['image'] = imagePath;
        if (animationName != null) data['animation'] = animationName;
        if (looping != null) data['looping'] = looping;
        if (autoStart != null) data['auto_start'] = autoStart;
        break;
      case 'spine':
        if (skeletonPath != null) data['skeleton'] = skeletonPath;
        if (atlasPath != null) data['atlas'] = atlasPath;
        if (animationName != null) data['animation'] = animationName;
        break;
    }

    return data;
  }

  /// Tạo model từ entity
  factory DecorationItemModel.fromEntity(DecorationItemEntity entity) {
    return DecorationItemModel(
      id: entity.id,
      type: entity.type,
      scale: entity.scale,
      position: entity.position,
      imagePath: entity.imagePath,
      animationName: entity.animationName,
      skeletonPath: entity.skeletonPath,
      atlasPath: entity.atlasPath,
      looping: entity.looping,
      autoStart: entity.autoStart,
    );
  }
}

/// Model class cho Background Configuration, extend từ BackgroundConfigEntity
class BackgroundConfigModel extends BackgroundConfigEntity {
  const BackgroundConfigModel({
    required String backgroundColor,
    Map<String, dynamic>? backgroundImage,
    List<DecorationItemEntity> decorations = const [],
  }) : super(
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          decorations: decorations,
        );

  /// Tạo BackgroundConfigModel từ JSON
  factory BackgroundConfigModel.fromJson(Map<String, dynamic> json) {
    List<DecorationItemEntity> decorations = [];
    if (json['decoration'] != null) {
      decorations = (json['decoration'] as List)
          .map((item) => DecorationItemModel.fromJson(item))
          .toList();
    }

    return BackgroundConfigModel(
      backgroundColor: json['background_color'] ?? '#87CEEB',
      backgroundImage: json['background_image'],
      decorations: decorations,
    );
  }

  /// Convert BackgroundConfigModel to JSON
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> decorationJsonList = decorations
        .map((item) => item is DecorationItemModel
            ? item.toJson()
            : DecorationItemModel.fromEntity(item).toJson())
        .toList();

    return {
      'background_color': backgroundColor,
      'background_image': backgroundImage,
      'decoration': decorationJsonList,
    };
  }

  /// Tạo model từ entity
  factory BackgroundConfigModel.fromEntity(BackgroundConfigEntity entity) {
    List<DecorationItemEntity> decorationModels = entity.decorations
        .map((item) => item is DecorationItemModel
            ? item
            : DecorationItemModel.fromEntity(item))
        .toList();

    return BackgroundConfigModel(
      backgroundColor: entity.backgroundColor,
      backgroundImage: entity.backgroundImage,
      decorations: decorationModels,
    );
  }
}
