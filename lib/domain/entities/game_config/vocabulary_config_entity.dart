import 'package:equatable/equatable.dart';

/// Entity class cho từng từ vựng
class VocabularyItemEntity extends Equatable {
  final String id;
  final String word;
  final String? translation;
  final String? description;
  final String? imagePath;
  final String? soundPath;
  final bool isActive;

  const VocabularyItemEntity({
    required this.id,
    required this.word,
    this.translation,
    this.description,
    this.imagePath,
    this.soundPath,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        word,
        translation,
        description,
        imagePath,
        soundPath,
        isActive,
      ];

  VocabularyItemEntity copyWith({
    String? id,
    String? word,
    String? translation,
    String? description,
    String? imagePath,
    String? soundPath,
    bool? isActive,
  }) {
    return VocabularyItemEntity(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      soundPath: soundPath ?? this.soundPath,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Entity class cho cấu hình từ vựng
class VocabularyConfigEntity extends Equatable {
  final bool enabled;
  final String fontFamily;
  final double fontSize;
  final String fontColor;
  final bool showImages;
  final bool playSoundOnDisplay;
  final double displayDuration;
  final List<VocabularyItemEntity> words;

  const VocabularyConfigEntity({
    required this.enabled,
    required this.fontFamily,
    required this.fontSize,
    required this.fontColor,
    required this.showImages,
    required this.playSoundOnDisplay,
    required this.displayDuration,
    required this.words,
  });

  @override
  List<Object?> get props => [
        enabled,
        fontFamily,
        fontSize,
        fontColor,
        showImages,
        playSoundOnDisplay,
        displayDuration,
        words,
      ];

  VocabularyConfigEntity copyWith({
    bool? enabled,
    String? fontFamily,
    double? fontSize,
    String? fontColor,
    bool? showImages,
    bool? playSoundOnDisplay,
    double? displayDuration,
    List<VocabularyItemEntity>? words,
  }) {
    return VocabularyConfigEntity(
      enabled: enabled ?? this.enabled,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      showImages: showImages ?? this.showImages,
      playSoundOnDisplay: playSoundOnDisplay ?? this.playSoundOnDisplay,
      displayDuration: displayDuration ?? this.displayDuration,
      words: words ?? this.words,
    );
  }
}
