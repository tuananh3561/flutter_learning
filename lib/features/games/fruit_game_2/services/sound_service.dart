import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

// Import the Fruit model from your game service
import '../models/fruit.dart';
import 'game_service.dart' show Fruit;

enum SoundType {
  fruitSound,
  correctFeedback,
  incorrectFeedback,
  celebration,
}

class SoundService extends ChangeNotifier {
  // Flag to track whether sounds are enabled
  bool _soundEnabled = true;

  // Cached asset paths for easier access
  final Map<String, String> _fruitSoundPaths = {};

  // Paths for feedback sounds
  final String _correctSoundPath = 'sounds/correct.mp3';
  final String _incorrectSoundPath = 'sounds/incorrect.mp3';
  final String _celebrationSoundPath = 'sounds/celebration.mp3';

  // Constructor to initialize the service
  SoundService() {
    // Initialize FlameAudio
    FlameAudio.bgm.initialize();
  }

  // Getter for sound enabled state
  bool get isSoundEnabled => _soundEnabled;

  // Toggle sound on/off
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  // Preload all game sounds
  Future<void> preloadSounds(List<Fruit> fruits) async {
    try {
      // Preload fruit sounds
      for (final fruit in fruits) {
        await FlameAudio.audioCache.load(fruit.soundPath);
        _fruitSoundPaths[fruit.id] = fruit.soundPath;
      }

      // Preload feedback sounds
      await FlameAudio.audioCache.load(_correctSoundPath);
      await FlameAudio.audioCache.load(_incorrectSoundPath);
      await FlameAudio.audioCache.load(_celebrationSoundPath);

      if (kDebugMode) {
        print('All sounds preloaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error preloading sounds: $e');
      }
    }
  }

  // Play fruit pronunciation sound
  Future<void> playFruitSound(Fruit fruit) async {
    if (!_soundEnabled) return;

    try {
      await FlameAudio.play(fruit.soundPath);
    } catch (e) {
      if (kDebugMode) {
        print('Error playing fruit sound: $e');
      }
    }
  }

  // Play feedback sound based on answer correctness
  Future<void> playFeedbackSound(bool isCorrect) async {
    if (!_soundEnabled) return;

    try {
      final soundPath = isCorrect ? _correctSoundPath : _incorrectSoundPath;
      await FlameAudio.play(soundPath);
    } catch (e) {
      if (kDebugMode) {
        print('Error playing feedback sound: $e');
      }
    }
  }

  // Play celebration sound at the end of the game
  Future<void> playCelebrationSound() async {
    if (!_soundEnabled) return;

    try {
      await FlameAudio.play(_celebrationSoundPath);
    } catch (e) {
      if (kDebugMode) {
        print('Error playing celebration sound: $e');
      }
    }
  }

  // Stop all currently playing sounds
  void stopAllSounds() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping sounds: $e');
      }
    }
  }

  // Play a specific sound by type and ID
  Future<void> playSound(SoundType type, {String? fruitId}) async {
    if (!_soundEnabled) return;

    try {
      switch (type) {
        case SoundType.fruitSound:
          if (fruitId != null && _fruitSoundPaths.containsKey(fruitId)) {
            await FlameAudio.play(_fruitSoundPaths[fruitId]!);
          }
          break;
        case SoundType.correctFeedback:
          await FlameAudio.play(_correctSoundPath);
          break;
        case SoundType.incorrectFeedback:
          await FlameAudio.play(_incorrectSoundPath);
          break;
        case SoundType.celebration:
          await FlameAudio.play(_celebrationSoundPath);
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound: $e');
      }
    }
  }

  // Release resources when the service is disposed
  @override
  void dispose() {
    stopAllSounds();
    super.dispose();
  }
}
