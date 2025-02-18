class AssetPaths {
  static const String cardFlipSound = 'assets/audio/word/card_flip.mp3';
  static const String gameStartSound = 'assets/audio/word/game_start.mp3';
  static const String victorySound = 'assets/audio/word/victory.mp3';

  static const List<String> cardImages = [
    'assets/images/word/dog.png',
    'assets/images/word/cat.png',
    'assets/images/word/bird.png',
  ];

  static String getMatchSoundPath(String imagePath) {
    final fileName = imagePath.split('/').last.split('.').first;
    return 'assets/audio/word/$fileName.mp3';
  }
}
