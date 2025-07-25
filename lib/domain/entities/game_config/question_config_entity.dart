import 'package:equatable/equatable.dart';

/// Entity class cho cấu hình câu hỏi
class QuestionConfigEntity extends Equatable {
  final String fontFamily;
  final double fontSize;
  final String fontColor;
  final String backgroundColor;
  final double borderRadius;
  final double padding;
  final String position;
  final Map<String, double> coordinates;
  final Map<String, double> dimensions;
  final bool showAnimation;
  final String? animationType;
  final double? animationDuration;
  final List<Map<String, dynamic>> questions;

  const QuestionConfigEntity({
    required this.fontFamily,
    required this.fontSize,
    required this.fontColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.position,
    required this.coordinates,
    required this.dimensions,
    required this.showAnimation,
    this.animationType,
    this.animationDuration,
    required this.questions,
  });

  @override
  List<Object?> get props => [
        fontFamily,
        fontSize,
        fontColor,
        backgroundColor,
        borderRadius,
        padding,
        position,
        coordinates,
        dimensions,
        showAnimation,
        animationType,
        animationDuration,
        questions,
      ];

  QuestionConfigEntity copyWith({
    String? fontFamily,
    double? fontSize,
    String? fontColor,
    String? backgroundColor,
    double? borderRadius,
    double? padding,
    String? position,
    Map<String, double>? coordinates,
    Map<String, double>? dimensions,
    bool? showAnimation,
    String? animationType,
    double? animationDuration,
    List<Map<String, dynamic>>? questions,
  }) {
    return QuestionConfigEntity(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      position: position ?? this.position,
      coordinates: coordinates ?? this.coordinates,
      dimensions: dimensions ?? this.dimensions,
      showAnimation: showAnimation ?? this.showAnimation,
      animationType: animationType ?? this.animationType,
      animationDuration: animationDuration ?? this.animationDuration,
      questions: questions ?? this.questions,
    );
  }
}
