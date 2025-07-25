import 'package:flutter_learning/domain/entities/game_config/answer_config_entity.dart';

/// Model class cho Answer Configuration, extend từ AnswerConfigEntity
class AnswerConfigModel extends AnswerConfigEntity {
  const AnswerConfigModel({
    required String layout,
    required int columns,
    required double spacing,
    required double itemWidth,
    required double itemHeight,
    required String fontFamily,
    required double fontSize,
    required String fontColor,
    required String backgroundColor,
    required String selectedBackgroundColor,
    required String correctColor,
    required String incorrectColor,
    required double borderRadius,
    required double padding,
    required bool showAnimation,
    String? animationType,
    double? animationDuration,
    required bool shuffleAnswers,
    required List<Map<String, dynamic>> answers,
  }) : super(
          layout: layout,
          columns: columns,
          spacing: spacing,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontColor: fontColor,
          backgroundColor: backgroundColor,
          selectedBackgroundColor: selectedBackgroundColor,
          correctColor: correctColor,
          incorrectColor: incorrectColor,
          borderRadius: borderRadius,
          padding: padding,
          showAnimation: showAnimation,
          animationType: animationType,
          animationDuration: animationDuration,
          shuffleAnswers: shuffleAnswers,
          answers: answers,
        );

  /// Tạo AnswerConfigModel từ JSON
  factory AnswerConfigModel.fromJson(Map<String, dynamic> json) {
    // Xử lý danh sách câu trả lời
    List<Map<String, dynamic>> answers = [];
    if (json['answers'] != null) {
      answers = (json['answers'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return AnswerConfigModel(
      layout: json['layout'] ?? 'grid',
      columns: json['columns'] ?? 2,
      spacing:
          json['spacing'] != null ? (json['spacing'] as num).toDouble() : 8.0,
      itemWidth: json['item_width'] != null
          ? (json['item_width'] as num).toDouble()
          : 150.0,
      itemHeight: json['item_height'] != null
          ? (json['item_height'] as num).toDouble()
          : 60.0,
      fontFamily: json['font_family'] ?? 'Roboto',
      fontSize: json['font_size'] != null
          ? (json['font_size'] as num).toDouble()
          : 16.0,
      fontColor: json['font_color'] ?? '#000000',
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      selectedBackgroundColor: json['selected_background_color'] ?? '#E0E0E0',
      correctColor: json['correct_color'] ?? '#4CAF50',
      incorrectColor: json['incorrect_color'] ?? '#F44336',
      borderRadius: json['border_radius'] != null
          ? (json['border_radius'] as num).toDouble()
          : 8.0,
      padding:
          json['padding'] != null ? (json['padding'] as num).toDouble() : 12.0,
      showAnimation: json['show_animation'] ?? true,
      animationType: json['animation_type'],
      animationDuration: json['animation_duration'] != null
          ? (json['animation_duration'] as num).toDouble()
          : null,
      shuffleAnswers: json['shuffle_answers'] ?? true,
      answers: answers,
    );
  }

  /// Convert AnswerConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'layout': layout,
      'columns': columns,
      'spacing': spacing,
      'item_width': itemWidth,
      'item_height': itemHeight,
      'font_family': fontFamily,
      'font_size': fontSize,
      'font_color': fontColor,
      'background_color': backgroundColor,
      'selected_background_color': selectedBackgroundColor,
      'correct_color': correctColor,
      'incorrect_color': incorrectColor,
      'border_radius': borderRadius,
      'padding': padding,
      'show_animation': showAnimation,
      'animation_type': animationType,
      'animation_duration': animationDuration,
      'shuffle_answers': shuffleAnswers,
      'answers': answers,
    };
  }

  /// Tạo model từ entity
  factory AnswerConfigModel.fromEntity(AnswerConfigEntity entity) {
    return AnswerConfigModel(
      layout: entity.layout,
      columns: entity.columns,
      spacing: entity.spacing,
      itemWidth: entity.itemWidth,
      itemHeight: entity.itemHeight,
      fontFamily: entity.fontFamily,
      fontSize: entity.fontSize,
      fontColor: entity.fontColor,
      backgroundColor: entity.backgroundColor,
      selectedBackgroundColor: entity.selectedBackgroundColor,
      correctColor: entity.correctColor,
      incorrectColor: entity.incorrectColor,
      borderRadius: entity.borderRadius,
      padding: entity.padding,
      showAnimation: entity.showAnimation,
      animationType: entity.animationType,
      animationDuration: entity.animationDuration,
      shuffleAnswers: entity.shuffleAnswers,
      answers: entity.answers,
    );
  }
}
