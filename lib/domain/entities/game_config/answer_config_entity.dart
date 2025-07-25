import 'package:equatable/equatable.dart';

/// Entity class cho cấu hình câu trả lời
class AnswerConfigEntity extends Equatable {
  final String layout; // grid, horizontal, vertical
  final int columns;
  final double spacing;
  final double itemWidth;
  final double itemHeight;
  final String fontFamily;
  final double fontSize;
  final String fontColor;
  final String backgroundColor;
  final String selectedBackgroundColor;
  final String correctColor;
  final String incorrectColor;
  final double borderRadius;
  final double padding;
  final bool showAnimation;
  final String? animationType;
  final double? animationDuration;
  final bool shuffleAnswers;
  final List<Map<String, dynamic>> answers;

  const AnswerConfigEntity({
    required this.layout,
    required this.columns,
    required this.spacing,
    required this.itemWidth,
    required this.itemHeight,
    required this.fontFamily,
    required this.fontSize,
    required this.fontColor,
    required this.backgroundColor,
    required this.selectedBackgroundColor,
    required this.correctColor,
    required this.incorrectColor,
    required this.borderRadius,
    required this.padding,
    required this.showAnimation,
    this.animationType,
    this.animationDuration,
    required this.shuffleAnswers,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        layout,
        columns,
        spacing,
        itemWidth,
        itemHeight,
        fontFamily,
        fontSize,
        fontColor,
        backgroundColor,
        selectedBackgroundColor,
        correctColor,
        incorrectColor,
        borderRadius,
        padding,
        showAnimation,
        animationType,
        animationDuration,
        shuffleAnswers,
        answers,
      ];

  AnswerConfigEntity copyWith({
    String? layout,
    int? columns,
    double? spacing,
    double? itemWidth,
    double? itemHeight,
    String? fontFamily,
    double? fontSize,
    String? fontColor,
    String? backgroundColor,
    String? selectedBackgroundColor,
    String? correctColor,
    String? incorrectColor,
    double? borderRadius,
    double? padding,
    bool? showAnimation,
    String? animationType,
    double? animationDuration,
    bool? shuffleAnswers,
    List<Map<String, dynamic>>? answers,
  }) {
    return AnswerConfigEntity(
      layout: layout ?? this.layout,
      columns: columns ?? this.columns,
      spacing: spacing ?? this.spacing,
      itemWidth: itemWidth ?? this.itemWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      correctColor: correctColor ?? this.correctColor,
      incorrectColor: incorrectColor ?? this.incorrectColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      showAnimation: showAnimation ?? this.showAnimation,
      animationType: animationType ?? this.animationType,
      animationDuration: animationDuration ?? this.animationDuration,
      shuffleAnswers: shuffleAnswers ?? this.shuffleAnswers,
      answers: answers ?? this.answers,
    );
  }
}
