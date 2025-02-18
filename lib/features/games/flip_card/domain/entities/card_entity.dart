class CardEntity {
  final int id;
  final String imagePath;
  final String soundPath;
  final bool isFlipped;
  final bool isMatched;

  const CardEntity({
    required this.id,
    required this.imagePath,
    required this.soundPath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardEntity copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardEntity(
      id: id,
      imagePath: imagePath,
      soundPath: soundPath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
