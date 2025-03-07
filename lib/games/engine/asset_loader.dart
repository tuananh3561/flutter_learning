import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

/// Handles loading of game assets
class GameAssetLoader {
  /// Load a single image
  static Future<void> loadImage(String path) async {
    await Flame.images.load(path);
  }

  /// Load a list of images
  static Future<void> loadImages(List<String> paths) async {
    for (final path in paths) {
      await loadImage(path);
    }
  }

  /// Load a single audio file
  static Future<void> loadAudio(String path) async {
    await FlameAudio.audioCache.load(path);
  }

  /// Load a list of audio files
  static Future<void> loadAudios(List<String> paths) async {
    for (final path in paths) {
      await loadAudio(path);
    }
  }

  /// Preload all Feed the Shark game assets
  static Future<void> preloadFeedTheSharkAssets() async {
    // Load images
    await Flame.images.loadAll([
      'assets/Feed the Shark/background.png',
      'assets/Feed the Shark/shark/4.1-3.8/shark_attack.png',
      'assets/Feed the Shark/shark/4.1-3.8/shark_eat.png',
      'assets/Feed the Shark/shark/4.1-3.8/shark_swim.png',
      'assets/Feed the Shark/ca nho 1/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/ca nho 2/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/ca nho 3/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/ca to 1/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/ca to 2/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/ca to 3/4.1-3.8/fish_idle.png',
      'assets/Feed the Shark/rong bien 1/4.1-3.8/rong_bien.png',
      'assets/Feed the Shark/rong bien 2/4.1-3.8/rong_bien.png',
      'assets/Feed the Shark/bong bong/4.1-3.8/bubbles.png',
    ]);

    // Load audio
    await FlameAudio.audioCache.loadAll([
      'assets/Feed the Shark/Nhạc BG.mp3',
      'assets/Feed the Shark/SFX cá mập.mp3',
      'assets/Feed the Shark/SFX Click.mp3',
      'assets/Feed the Shark/SFX đúng.mp3',
      'assets/Feed the Shark/SFX guiding.mp3',
      'assets/Feed the Shark/SFX hết lượt 1.mp3',
      'assets/Feed the Shark/SFX sai.mp3',
      'assets/Feed the Shark/SFX Unclick.mp3',
      'assets/Feed the Shark/SFX Win.mp3',
      // Animal sounds
      'dog.mp3',
      'cat.mp3',
      'fish.mp3',
      'bird.mp3',
      'duck.mp3',
      'pig.mp3',
      'cow.mp3',
      'sheep.mp3',
      'horse.mp3',
      'frog.mp3',
    ]);
  }
}
