import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final Map<String, bool> _loadedAudio = {};

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  Future<void> preloadAudio(String audioPath) async {
    if (_loadedAudio[audioPath] == true) return;

    try {
      await FlameAudio.audioCache.load(audioPath);
      _loadedAudio[audioPath] = true;
    } catch (e) {
      print('Error preloading audio $audioPath: $e');
      _loadedAudio[audioPath] = false;
    }
  }

  Future<void> playAudio(String audioPath) async {
    try {
      if (_loadedAudio[audioPath] != true) {
        await preloadAudio(audioPath);
      }
      await FlameAudio.play(audioPath);
    } catch (e) {
      print('Error playing audio $audioPath: $e');
      // Try to reload and play again if initial play fails
      try {
        await preloadAudio(audioPath);
        await FlameAudio.play(audioPath);
      } catch (retryError) {
        print('Error retrying audio playback: $retryError');
      }
    }
  }

  Future<void> preloadGameAudio(List<Map<String, String>> fruitData) async {
    for (final fruit in fruitData) {
      if (fruit['audio'] != null) {
        await preloadAudio(fruit['audio']!);
      }
    }
  }

  void clearCache() {
    _loadedAudio.clear();
    FlameAudio.audioCache.clear('');
  }
}
