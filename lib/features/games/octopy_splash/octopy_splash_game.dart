import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'components/background.dart';
import 'managers/game_manager.dart';
import 'managers/sound_manager.dart';
import 'levels/level_data.dart';
import 'levels/base_level.dart';

class OctopySplashGame extends FlameGame {
  late GameManager gameManager;
  late SoundManager soundManager;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameManager = GameManager();
    soundManager = SoundManager();

    add(Background());
    add(BaseLevel(
        gameManager, soundManager, levels[0])); // Bắt đầu với level đầu tiên

    await images.loadAll([
      'background.png',
      'cat/idle.png',
      'octopus/idle.png',
      'octopus/hit.png',
      'water_balloon.png',
    ]);

    await FlameAudio.audioCache.loadAll([
      'background_music.mp3',
      'correct_sound.mp3',
      'incorrect_sound.mp3',
      'throw_sound.mp3',
      'hit_sound.mp3',
      'voice_over/bounce.mp3',
      'voice_over/float.mp3',
      'voice_over/grow.mp3',
      'voice_over/roll.mp3',
      'voice_over/sink.mp3',
      'voice_over/dive.mp3',
    ]);
    soundManager.playBackgroundMusic(); // Bắt đầu nhạc nền
  }
}
