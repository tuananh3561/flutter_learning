import 'package:equatable/equatable.dart';

/// Decoration item class cho các item trang trí trong background
class DecorationItemEntity extends Equatable {
  final String id;
  final String type; // image, animation, spine
  final double scale;
  final Map<String, double> position;
  final String? imagePath;
  final String? animationName;
  final String? skeletonPath;
  final String? atlasPath;
  final bool? looping;
  final bool? autoStart;

  const DecorationItemEntity({
    required this.id,
    required this.type,
    required this.scale,
    required this.position,
    this.imagePath,
    this.animationName,
    this.skeletonPath,
    this.atlasPath,
    this.looping,
    this.autoStart,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        scale,
        position,
        imagePath,
        animationName,
        skeletonPath,
        atlasPath,
        looping,
        autoStart,
      ];

  DecorationItemEntity copyWith({
    String? id,
    String? type,
    double? scale,
    Map<String, double>? position,
    String? imagePath,
    String? animationName,
    String? skeletonPath,
    String? atlasPath,
    bool? looping,
    bool? autoStart,
  }) {
    return DecorationItemEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      scale: scale ?? this.scale,
      position: position ?? this.position,
      imagePath: imagePath ?? this.imagePath,
      animationName: animationName ?? this.animationName,
      skeletonPath: skeletonPath ?? this.skeletonPath,
      atlasPath: atlasPath ?? this.atlasPath,
      looping: looping ?? this.looping,
      autoStart: autoStart ?? this.autoStart,
    );
  }
}

/// Entity class cho background configuration
class BackgroundConfigEntity extends Equatable {
  final String backgroundColor;
  final Map<String, dynamic>? backgroundImage;
  final List<DecorationItemEntity> decorations;

  const BackgroundConfigEntity({
    required this.backgroundColor,
    this.backgroundImage,
    this.decorations = const [],
  });

  @override
  List<Object?> get props => [backgroundColor, backgroundImage, decorations];

  BackgroundConfigEntity copyWith({
    String? backgroundColor,
    Map<String, dynamic>? backgroundImage,
    List<DecorationItemEntity>? decorations,
  }) {
    return BackgroundConfigEntity(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      decorations: decorations ?? this.decorations,
    );
  }
}
