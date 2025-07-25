import 'package:flutter_learning/domain/entities/game_config/vocabulary_config_entity.dart';

/// Model class cho Vocabulary Item, extend từ VocabularyItemEntity
class VocabularyItemModel extends VocabularyItemEntity {
  const VocabularyItemModel({
    required String id,
    required String word,
    String? translation,
    String? description,
    String? imagePath,
    String? soundPath,
    bool isActive = true,
  }) : super(
          id: id,
          word: word,
          translation: translation,
          description: description,
          imagePath: imagePath,
          soundPath: soundPath,
          isActive: isActive,
        );

  /// Tạo VocabularyItemModel từ JSON
  factory VocabularyItemModel.fromJson(Map<String, dynamic> json) {
    return VocabularyItemModel(
      id: json['id'] ?? '',
      word: json['word'] ?? '',
      translation: json['translation'],
      description: json['description'],
      imagePath: json['image_path'],
      soundPath: json['sound_path'],
      isActive: json['is_active'] ?? true,
    );
  }

  /// Convert VocabularyItemModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'word': word,
      'is_active': isActive,
    };

    if (translation != null) data['translation'] = translation;
    if (description != null) data['description'] = description;
    if (imagePath != null) data['image_path'] = imagePath;
    if (soundPath != null) data['sound_path'] = soundPath;

    return data;
  }

  /// Tạo model từ entity
  factory VocabularyItemModel.fromEntity(VocabularyItemEntity entity) {
    return VocabularyItemModel(
      id: entity.id,
      word: entity.word,
      translation: entity.translation,
      description: entity.description,
      imagePath: entity.imagePath,
      soundPath: entity.soundPath,
      isActive: entity.isActive,
    );
  }
}

/// Model class cho Vocabulary Configuration, extend từ VocabularyConfigEntity
class VocabularyConfigModel extends VocabularyConfigEntity {
  const VocabularyConfigModel({
    required bool enabled,
    required String fontFamily,
    required double fontSize,
    required String fontColor,
    required bool showImages,
    required bool playSoundOnDisplay,
    required double displayDuration,
    required List<VocabularyItemEntity> words,
  }) : super(
          enabled: enabled,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontColor: fontColor,
          showImages: showImages,
          playSoundOnDisplay: playSoundOnDisplay,
          displayDuration: displayDuration,
          words: words,
        );

  /// Tạo VocabularyConfigModel từ JSON
  factory VocabularyConfigModel.fromJson(Map<String, dynamic> json) {
    // Xử lý danh sách từ vựng
    List<VocabularyItemEntity> words = [];
    if (json['words'] != null) {
      words = (json['words'] as List)
          .map((item) => VocabularyItemModel.fromJson(item))
          .toList();
    }

    return VocabularyConfigModel(
      enabled: json['enabled'] ?? false,
      fontFamily: json['font_family'] ?? 'Roboto',
      fontSize: json['font_size'] != null
          ? (json['font_size'] as num).toDouble()
          : 20.0,
      fontColor: json['font_color'] ?? '#000000',
      showImages: json['show_images'] ?? true,
      playSoundOnDisplay: json['play_sound_on_display'] ?? true,
      displayDuration: json['display_duration'] != null
          ? (json['display_duration'] as num).toDouble()
          : 2.0,
      words: words,
    );
  }

  /// Convert VocabularyConfigModel to JSON
  Map<String, dynamic> toJson() {
    // Convert words list to JSON
    final List<Map<String, dynamic>> wordsJsonList = words
        .map((item) => item is VocabularyItemModel
            ? item.toJson()
            : VocabularyItemModel.fromEntity(item).toJson())
        .toList();

    return {
      'enabled': enabled,
      'font_family': fontFamily,
      'font_size': fontSize,
      'font_color': fontColor,
      'show_images': showImages,
      'play_sound_on_display': playSoundOnDisplay,
      'display_duration': displayDuration,
      'words': wordsJsonList,
    };
  }

  /// Tạo model từ entity
  factory VocabularyConfigModel.fromEntity(VocabularyConfigEntity entity) {
    // Convert words
    final List<VocabularyItemEntity> wordModels = entity.words
        .map((item) => item is VocabularyItemModel
            ? item
            : VocabularyItemModel.fromEntity(item))
        .toList();

    return VocabularyConfigModel(
      enabled: entity.enabled,
      fontFamily: entity.fontFamily,
      fontSize: entity.fontSize,
      fontColor: entity.fontColor,
      showImages: entity.showImages,
      playSoundOnDisplay: entity.playSoundOnDisplay,
      displayDuration: entity.displayDuration,
      words: wordModels,
    );
  }
}
