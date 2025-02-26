import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  // Phương thức phát âm thanh cho từ vựng
  Future<void> loadWordSound(String word) async {
    // Kiểm tra xem âm thanh đã được load chưa
    if (!FlameAudio.audioCache.loadedFiles
        .containsKey('voice_over/$word.mp3')) {
      await FlameAudio.audioCache.load('voice_over/$word.mp3');
    }
  }

  void playWordSound(String word) {
    FlameAudio.play('voice_over/$word.mp3');
  }

  void playCorrectSound() {
    FlameAudio.play('correct_sound.mp3');
  }

  void playIncorrectSound() {
    FlameAudio.play('incorrect_sound.mp3');
  }

  void playThrowSound() {
    FlameAudio.play('throw_sound.mp3');
  }

  void playHitSound() {
    FlameAudio.play('hit_sound.mp3');
  }

  void playBackgroundMusic() {
    FlameAudio.bgm.play('background_music.mp3');
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }
}
