import 'package:flutter_learning/domain/entities/game_config/drop_zone_config_entity.dart';

/// Model class cho DropZoneItem, extend từ DropZoneItemEntity
class DropZoneItemModel extends DropZoneItemEntity {
  const DropZoneItemModel({
    required String id,
    required String type,
    required Map<String, double> position,
    required Map<String, double> size,
    String? backgroundColor,
    double? borderRadius,
    double? borderWidth,
    String? borderColor,
    String? imagePath,
    required List<String> acceptedIds,
    bool showHighlight = true,
    String? highlightColor,
    String? animationOnDrop,
  }) : super(
          id: id,
          type: type,
          position: position,
          size: size,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          borderColor: borderColor,
          imagePath: imagePath,
          acceptedIds: acceptedIds,
          showHighlight: showHighlight,
          highlightColor: highlightColor,
          animationOnDrop: animationOnDrop,
        );

  /// Tạo DropZoneItemModel từ JSON
  factory DropZoneItemModel.fromJson(Map<String, dynamic> json) {
    // Xử lý position từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> position = {};
    if (json['position'] != null) {
      (json['position'] as Map<String, dynamic>).forEach((key, value) {
        position[key] = (value as num).toDouble();
      });
    }

    // Xử lý size từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> size = {};
    if (json['size'] != null) {
      (json['size'] as Map<String, dynamic>).forEach((key, value) {
        size[key] = (value as num).toDouble();
      });
    }

    // Xử lý acceptedIds
    List<String> acceptedIds = [];
    if (json['accepted_ids'] != null) {
      acceptedIds = List<String>.from(json['accepted_ids']);
    }

    return DropZoneItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'rectangular',
      position: position,
      size: size,
      backgroundColor: json['background_color'],
      borderRadius: json['border_radius'] != null
          ? (json['border_radius'] as num).toDouble()
          : null,
      borderWidth: json['border_width'] != null
          ? (json['border_width'] as num).toDouble()
          : null,
      borderColor: json['border_color'],
      imagePath: json['image_path'],
      acceptedIds: acceptedIds,
      showHighlight: json['show_highlight'] ?? true,
      highlightColor: json['highlight_color'],
      animationOnDrop: json['animation_on_drop'],
    );
  }

  /// Convert DropZoneItemModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'type': type,
      'position': position,
      'size': size,
      'accepted_ids': acceptedIds,
      'show_highlight': showHighlight,
    };

    if (backgroundColor != null) data['background_color'] = backgroundColor;
    if (borderRadius != null) data['border_radius'] = borderRadius;
    if (borderWidth != null) data['border_width'] = borderWidth;
    if (borderColor != null) data['border_color'] = borderColor;
    if (imagePath != null) data['image_path'] = imagePath;
    if (highlightColor != null) data['highlight_color'] = highlightColor;
    if (animationOnDrop != null) data['animation_on_drop'] = animationOnDrop;

    return data;
  }

  /// Tạo model từ entity
  factory DropZoneItemModel.fromEntity(DropZoneItemEntity entity) {
    return DropZoneItemModel(
      id: entity.id,
      type: entity.type,
      position: entity.position,
      size: entity.size,
      backgroundColor: entity.backgroundColor,
      borderRadius: entity.borderRadius,
      borderWidth: entity.borderWidth,
      borderColor: entity.borderColor,
      imagePath: entity.imagePath,
      acceptedIds: entity.acceptedIds,
      showHighlight: entity.showHighlight,
      highlightColor: entity.highlightColor,
      animationOnDrop: entity.animationOnDrop,
    );
  }
}

/// Model class cho DragItem, extend từ DragItemEntity
class DragItemModel extends DragItemEntity {
  const DragItemModel({
    required String id,
    required String type,
    String? text,
    String? imagePath,
    required Map<String, double> initialPosition,
    required Map<String, double> size,
    String? backgroundColor,
    String? textColor,
    double? borderRadius,
    String? fontFamily,
    double? fontSize,
    bool returnToInitialOnMiss = true,
    String? soundOnDrag,
    String? soundOnDrop,
  }) : super(
          id: id,
          type: type,
          text: text,
          imagePath: imagePath,
          initialPosition: initialPosition,
          size: size,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderRadius: borderRadius,
          fontFamily: fontFamily,
          fontSize: fontSize,
          returnToInitialOnMiss: returnToInitialOnMiss,
          soundOnDrag: soundOnDrag,
          soundOnDrop: soundOnDrop,
        );

  /// Tạo DragItemModel từ JSON
  factory DragItemModel.fromJson(Map<String, dynamic> json) {
    // Xử lý initialPosition từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> initialPosition = {};
    if (json['initial_position'] != null) {
      (json['initial_position'] as Map<String, dynamic>).forEach((key, value) {
        initialPosition[key] = (value as num).toDouble();
      });
    }

    // Xử lý size từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> size = {};
    if (json['size'] != null) {
      (json['size'] as Map<String, dynamic>).forEach((key, value) {
        size[key] = (value as num).toDouble();
      });
    }

    return DragItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'text',
      text: json['text'],
      imagePath: json['image_path'],
      initialPosition: initialPosition,
      size: size,
      backgroundColor: json['background_color'],
      textColor: json['text_color'],
      borderRadius: json['border_radius'] != null
          ? (json['border_radius'] as num).toDouble()
          : null,
      fontFamily: json['font_family'],
      fontSize: json['font_size'] != null
          ? (json['font_size'] as num).toDouble()
          : null,
      returnToInitialOnMiss: json['return_to_initial_on_miss'] ?? true,
      soundOnDrag: json['sound_on_drag'],
      soundOnDrop: json['sound_on_drop'],
    );
  }

  /// Convert DragItemModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'type': type,
      'initial_position': initialPosition,
      'size': size,
      'return_to_initial_on_miss': returnToInitialOnMiss,
    };

    if (text != null) data['text'] = text;
    if (imagePath != null) data['image_path'] = imagePath;
    if (backgroundColor != null) data['background_color'] = backgroundColor;
    if (textColor != null) data['text_color'] = textColor;
    if (borderRadius != null) data['border_radius'] = borderRadius;
    if (fontFamily != null) data['font_family'] = fontFamily;
    if (fontSize != null) data['font_size'] = fontSize;
    if (soundOnDrag != null) data['sound_on_drag'] = soundOnDrag;
    if (soundOnDrop != null) data['sound_on_drop'] = soundOnDrop;

    return data;
  }

  /// Tạo model từ entity
  factory DragItemModel.fromEntity(DragItemEntity entity) {
    return DragItemModel(
      id: entity.id,
      type: entity.type,
      text: entity.text,
      imagePath: entity.imagePath,
      initialPosition: entity.initialPosition,
      size: entity.size,
      backgroundColor: entity.backgroundColor,
      textColor: entity.textColor,
      borderRadius: entity.borderRadius,
      fontFamily: entity.fontFamily,
      fontSize: entity.fontSize,
      returnToInitialOnMiss: entity.returnToInitialOnMiss,
      soundOnDrag: entity.soundOnDrag,
      soundOnDrop: entity.soundOnDrop,
    );
  }
}

/// Model class cho DropZone Configuration, extend từ DropZoneConfigEntity
class DropZoneConfigModel extends DropZoneConfigEntity {
  const DropZoneConfigModel({
    required bool enabled,
    required bool snapToCenter,
    required double snapDistance,
    required String successSoundPath,
    required String errorSoundPath,
    required List<DropZoneItemEntity> dropZones,
    required List<DragItemEntity> dragItems,
  }) : super(
          enabled: enabled,
          snapToCenter: snapToCenter,
          snapDistance: snapDistance,
          successSoundPath: successSoundPath,
          errorSoundPath: errorSoundPath,
          dropZones: dropZones,
          dragItems: dragItems,
        );

  /// Tạo DropZoneConfigModel từ JSON
  factory DropZoneConfigModel.fromJson(Map<String, dynamic> json) {
    // Xử lý drop zones
    List<DropZoneItemEntity> dropZones = [];
    if (json['drop_zones'] != null) {
      dropZones = (json['drop_zones'] as List)
          .map((item) => DropZoneItemModel.fromJson(item))
          .toList();
    }

    // Xử lý drag items
    List<DragItemEntity> dragItems = [];
    if (json['drag_items'] != null) {
      dragItems = (json['drag_items'] as List)
          .map((item) => DragItemModel.fromJson(item))
          .toList();
    }

    return DropZoneConfigModel(
      enabled: json['enabled'] ?? false,
      snapToCenter: json['snap_to_center'] ?? true,
      snapDistance: json['snap_distance'] != null
          ? (json['snap_distance'] as num).toDouble()
          : 20.0,
      successSoundPath: json['success_sound_path'] ?? '',
      errorSoundPath: json['error_sound_path'] ?? '',
      dropZones: dropZones,
      dragItems: dragItems,
    );
  }

  /// Convert DropZoneConfigModel to JSON
  Map<String, dynamic> toJson() {
    // Convert drop zones to JSON
    final List<Map<String, dynamic>> dropZonesJsonList = dropZones
        .map((item) => item is DropZoneItemModel
            ? item.toJson()
            : DropZoneItemModel.fromEntity(item).toJson())
        .toList();

    // Convert drag items to JSON
    final List<Map<String, dynamic>> dragItemsJsonList = dragItems
        .map((item) => item is DragItemModel
            ? item.toJson()
            : DragItemModel.fromEntity(item).toJson())
        .toList();

    return {
      'enabled': enabled,
      'snap_to_center': snapToCenter,
      'snap_distance': snapDistance,
      'success_sound_path': successSoundPath,
      'error_sound_path': errorSoundPath,
      'drop_zones': dropZonesJsonList,
      'drag_items': dragItemsJsonList,
    };
  }

  /// Tạo model từ entity
  factory DropZoneConfigModel.fromEntity(DropZoneConfigEntity entity) {
    // Convert drop zones
    final List<DropZoneItemEntity> dropZoneModels = entity.dropZones
        .map((item) => item is DropZoneItemModel
            ? item
            : DropZoneItemModel.fromEntity(item))
        .toList();

    // Convert drag items
    final List<DragItemEntity> dragItemModels = entity.dragItems
        .map((item) =>
            item is DragItemModel ? item : DragItemModel.fromEntity(item))
        .toList();

    return DropZoneConfigModel(
      enabled: entity.enabled,
      snapToCenter: entity.snapToCenter,
      snapDistance: entity.snapDistance,
      successSoundPath: entity.successSoundPath,
      errorSoundPath: entity.errorSoundPath,
      dropZones: dropZoneModels,
      dragItems: dragItemModels,
    );
  }
}
