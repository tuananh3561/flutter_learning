class LevelData {
  final List<String> words;
  final String targetWord;
  final int maxAttempts;

  LevelData({
    required this.words,
    required this.targetWord,
    required this.maxAttempts,
  });
}

final List<LevelData> levels = [
  LevelData(
      words: ['bounce', 'roll', 'fall'], targetWord: 'bounce', maxAttempts: 3),
  LevelData(
      words: ['float', 'trip', 'sink'], targetWord: 'float', maxAttempts: 3),
  LevelData(
      words: ['grow', 'dive', 'sink'], targetWord: 'grow', maxAttempts: 3),

  // Thêm các level khác
];
