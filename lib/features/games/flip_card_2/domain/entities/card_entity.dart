import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class CardEntity extends Equatable {
  final int id;
  final String imagePath;
  final String soundPath;
  final bool isFlipped;
  final bool isMatched;
  final Offset position;

  const CardEntity({
    required this.id,
    required this.imagePath,
    required this.soundPath,
    required this.position,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardEntity copyWith({
    bool? isFlipped,
    bool? isMatched,
    Offset? position,
  }) {
    return CardEntity(
      id: id,
      imagePath: imagePath,
      soundPath: soundPath,
      position: position ?? this.position,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  List<Object?> get props => [
        id,
        imagePath,
        soundPath,
        isFlipped,
        isMatched,
        position,
      ];
}
