import 'package:equatable/equatable.dart';

/// Entity class cho cấu hình drop zone item
class DropZoneItemEntity extends Equatable {
  final String id;
  final String type; // rectangular, circular, custom
  final Map<String, double> position;
  final Map<String, double> size;
  final String? backgroundColor;
  final double? borderRadius;
  final double? borderWidth;
  final String? borderColor;
  final String? imagePath;
  final List<String> acceptedIds;
  final bool showHighlight;
  final String? highlightColor;
  final String? animationOnDrop;

  const DropZoneItemEntity({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    this.backgroundColor,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.imagePath,
    required this.acceptedIds,
    this.showHighlight = true,
    this.highlightColor,
    this.animationOnDrop,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        position,
        size,
        backgroundColor,
        borderRadius,
        borderWidth,
        borderColor,
        imagePath,
        acceptedIds,
        showHighlight,
        highlightColor,
        animationOnDrop,
      ];

  DropZoneItemEntity copyWith({
    String? id,
    String? type,
    Map<String, double>? position,
    Map<String, double>? size,
    String? backgroundColor,
    double? borderRadius,
    double? borderWidth,
    String? borderColor,
    String? imagePath,
    List<String>? acceptedIds,
    bool? showHighlight,
    String? highlightColor,
    String? animationOnDrop,
  }) {
    return DropZoneItemEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      imagePath: imagePath ?? this.imagePath,
      acceptedIds: acceptedIds ?? this.acceptedIds,
      showHighlight: showHighlight ?? this.showHighlight,
      highlightColor: highlightColor ?? this.highlightColor,
      animationOnDrop: animationOnDrop ?? this.animationOnDrop,
    );
  }
}

/// Entity class cho cấu hình drag item
class DragItemEntity extends Equatable {
  final String id;
  final String type; // text, image, mixed
  final String? text;
  final String? imagePath;
  final Map<String, double> initialPosition;
  final Map<String, double> size;
  final String? backgroundColor;
  final String? textColor;
  final double? borderRadius;
  final String? fontFamily;
  final double? fontSize;
  final bool returnToInitialOnMiss;
  final String? soundOnDrag;
  final String? soundOnDrop;

  const DragItemEntity({
    required this.id,
    required this.type,
    this.text,
    this.imagePath,
    required this.initialPosition,
    required this.size,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.fontFamily,
    this.fontSize,
    this.returnToInitialOnMiss = true,
    this.soundOnDrag,
    this.soundOnDrop,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        text,
        imagePath,
        initialPosition,
        size,
        backgroundColor,
        textColor,
        borderRadius,
        fontFamily,
        fontSize,
        returnToInitialOnMiss,
        soundOnDrag,
        soundOnDrop,
      ];

  DragItemEntity copyWith({
    String? id,
    String? type,
    String? text,
    String? imagePath,
    Map<String, double>? initialPosition,
    Map<String, double>? size,
    String? backgroundColor,
    String? textColor,
    double? borderRadius,
    String? fontFamily,
    double? fontSize,
    bool? returnToInitialOnMiss,
    String? soundOnDrag,
    String? soundOnDrop,
  }) {
    return DragItemEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      initialPosition: initialPosition ?? this.initialPosition,
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      returnToInitialOnMiss:
          returnToInitialOnMiss ?? this.returnToInitialOnMiss,
      soundOnDrag: soundOnDrag ?? this.soundOnDrag,
      soundOnDrop: soundOnDrop ?? this.soundOnDrop,
    );
  }
}

/// Entity class cho cấu hình drop zone
class DropZoneConfigEntity extends Equatable {
  final bool enabled;
  final bool snapToCenter;
  final double snapDistance;
  final String successSoundPath;
  final String errorSoundPath;
  final List<DropZoneItemEntity> dropZones;
  final List<DragItemEntity> dragItems;

  const DropZoneConfigEntity({
    required this.enabled,
    required this.snapToCenter,
    required this.snapDistance,
    required this.successSoundPath,
    required this.errorSoundPath,
    required this.dropZones,
    required this.dragItems,
  });

  @override
  List<Object?> get props => [
        enabled,
        snapToCenter,
        snapDistance,
        successSoundPath,
        errorSoundPath,
        dropZones,
        dragItems,
      ];

  DropZoneConfigEntity copyWith({
    bool? enabled,
    bool? snapToCenter,
    double? snapDistance,
    String? successSoundPath,
    String? errorSoundPath,
    List<DropZoneItemEntity>? dropZones,
    List<DragItemEntity>? dragItems,
  }) {
    return DropZoneConfigEntity(
      enabled: enabled ?? this.enabled,
      snapToCenter: snapToCenter ?? this.snapToCenter,
      snapDistance: snapDistance ?? this.snapDistance,
      successSoundPath: successSoundPath ?? this.successSoundPath,
      errorSoundPath: errorSoundPath ?? this.errorSoundPath,
      dropZones: dropZones ?? this.dropZones,
      dragItems: dragItems ?? this.dragItems,
    );
  }
}
