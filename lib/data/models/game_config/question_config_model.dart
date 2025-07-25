import 'package:flutter_learning/domain/entities/game_config/question_config_entity.dart';

/// Model class cho Question Configuration, extend từ QuestionConfigEntity
class QuestionConfigModel extends QuestionConfigEntity {
  const QuestionConfigModel({
    required String fontFamily,
    required double fontSize,
    required String fontColor,
    required String backgroundColor,
    required double borderRadius,
    required double padding,
    required String position,
    required Map<String, double> coordinates,
    required Map<String, double> dimensions,
    required bool showAnimation,
    String? animationType,
    double? animationDuration,
    required List<Map<String, dynamic>> questions,
  }) : super(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontColor: fontColor,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          padding: padding,
          position: position,
          coordinates: coordinates,
          dimensions: dimensions,
          showAnimation: showAnimation,
          animationType: animationType,
          animationDuration: animationDuration,
          questions: questions,
        );

  /// Tạo QuestionConfigModel từ JSON
  factory QuestionConfigModel.fromJson(Map<String, dynamic> json) {
    // Xử lý coordinates từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> coordinates = {};
    if (json['coordinates'] != null) {
      (json['coordinates'] as Map<String, dynamic>).forEach((key, value) {
        coordinates[key] = (value as num).toDouble();
      });
    }

    // Xử lý dimensions từ Map<String, dynamic> sang Map<String, double>
    final Map<String, double> dimensions = {};
    if (json['dimensions'] != null) {
      (json['dimensions'] as Map<String, dynamic>).forEach((key, value) {
        dimensions[key] = (value as num).toDouble();
      });
    }

    // Xử lý danh sách câu hỏi
    List<Map<String, dynamic>> questions = [];
    if (json['questions'] != null) {
      questions = (json['questions'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return QuestionConfigModel(
      fontFamily: json['font_family'] ?? 'Roboto',
      fontSize: json['font_size'] != null
          ? (json['font_size'] as num).toDouble()
          : 18.0,
      fontColor: json['font_color'] ?? '#000000',
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      borderRadius: json['border_radius'] != null
          ? (json['border_radius'] as num).toDouble()
          : 8.0,
      padding:
          json['padding'] != null ? (json['padding'] as num).toDouble() : 16.0,
      position: json['position'] ?? 'top',
      coordinates: coordinates,
      dimensions: dimensions,
      showAnimation: json['show_animation'] ?? false,
      animationType: json['animation_type'],
      animationDuration: json['animation_duration'] != null
          ? (json['animation_duration'] as num).toDouble()
          : null,
      questions: questions,
    );
  }

  /// Convert QuestionConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'font_family': fontFamily,
      'font_size': fontSize,
      'font_color': fontColor,
      'background_color': backgroundColor,
      'border_radius': borderRadius,
      'padding': padding,
      'position': position,
      'coordinates': coordinates,
      'dimensions': dimensions,
      'show_animation': showAnimation,
      'animation_type': animationType,
      'animation_duration': animationDuration,
      'questions': questions,
    };
  }

  /// Tạo model từ entity
  factory QuestionConfigModel.fromEntity(QuestionConfigEntity entity) {
    return QuestionConfigModel(
      fontFamily: entity.fontFamily,
      fontSize: entity.fontSize,
      fontColor: entity.fontColor,
      backgroundColor: entity.backgroundColor,
      borderRadius: entity.borderRadius,
      padding: entity.padding,
      position: entity.position,
      coordinates: entity.coordinates,
      dimensions: entity.dimensions,
      showAnimation: entity.showAnimation,
      animationType: entity.animationType,
      animationDuration: entity.animationDuration,
      questions: entity.questions,
    );
  }
}
