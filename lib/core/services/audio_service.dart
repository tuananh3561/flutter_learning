import 'package:flame_audio/flame_audio.dart';

/// Dịch vụ âm thanh dùng chung cho tất cả các game
class AudioService {
  /// Singleton instance
  static final AudioService _instance = AudioService._internal();

  /// Factory constructor
  factory AudioService() {
    return _instance;
  }

  /// Internal constructor
  AudioService._internal();

  /// Trạng thái âm lượng của nhạc nền
  bool _isMusicEnabled = true;

  /// Trạng thái âm lượng của hiệu ứng âm thanh
  bool _isSoundEnabled = true;

  /// Âm lượng nhạc nền (0.0 đến 1.0)
  double _musicVolume = 1.0;

  /// Âm lượng hiệu ứng âm thanh (0.0 đến 1.0)
  double _soundVolume = 1.0;

  /// Tên file nhạc nền hiện tại
  String? _currentBackgroundMusic;

  /// Khởi tạo dịch vụ âm thanh
  Future<void> initialize() async {
    // Preload các âm thanh phổ biến
    await preloadCommonSounds();
  }

  /// Preload các âm thanh được sử dụng thường xuyên
  Future<void> preloadCommonSounds() async {
    try {
      // Preload nhạc nền và hiệu ứng âm thanh phổ biến ở đây
      // await FlameAudio.audioCache.loadAll([
      //   'bgm.mp3',
      //   'click.mp3',
      //   'success.mp3',
      //   'failure.mp3',
      // ]);
    } catch (e) {
      print('Error preloading sounds: $e');
    }
  }

  /// Phát nhạc nền
  Future<void> playBackgroundMusic(String fileName) async {
    if (!_isMusicEnabled) return;

    try {
      // Nếu đang phát cùng một file, không cần phát lại
      if (_currentBackgroundMusic == fileName && FlameAudio.bgm.isPlaying) {
        return;
      }

      // Dừng nhạc nền hiện tại nếu có
      if (FlameAudio.bgm.isPlaying) {
        await stopBackgroundMusic();
      }

      // Phát nhạc mới
      _currentBackgroundMusic = fileName;
      await FlameAudio.bgm.play(fileName, volume: _musicVolume);
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  /// Dừng nhạc nền
  Future<void> stopBackgroundMusic() async {
    try {
      if (FlameAudio.bgm.isPlaying) {
        await FlameAudio.bgm.stop();
      }
      _currentBackgroundMusic = null;
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  /// Tạm dừng nhạc nền
  Future<void> pauseBackgroundMusic() async {
    try {
      if (FlameAudio.bgm.isPlaying) {
        await FlameAudio.bgm.pause();
      }
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }

  /// Tiếp tục phát nhạc nền đã tạm dừng
  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;

    try {
      if (!FlameAudio.bgm.isPlaying && _currentBackgroundMusic != null) {
        await FlameAudio.bgm.resume();
      }
    } catch (e) {
      print('Error resuming background music: $e');
    }
  }

  /// Phát hiệu ứng âm thanh
  Future<void> playSoundEffect(String fileName) async {
    if (!_isSoundEnabled) return;

    try {
      await FlameAudio.play(fileName, volume: _soundVolume);
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }

  /// Bật/tắt nhạc nền
  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;

    if (!enabled) {
      pauseBackgroundMusic();
    } else if (_currentBackgroundMusic != null) {
      resumeBackgroundMusic();
    }
  }

  /// Bật/tắt hiệu ứng âm thanh
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  /// Đặt âm lượng nhạc nền
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);

    // Cập nhật âm lượng nếu đang phát
    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
    }
  }

  /// Đặt âm lượng hiệu ứng âm thanh
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  /// Lấy trạng thái âm lượng của nhạc nền
  bool get isMusicEnabled => _isMusicEnabled;

  /// Lấy trạng thái âm lượng của hiệu ứng âm thanh
  bool get isSoundEnabled => _isSoundEnabled;

  /// Lấy âm lượng nhạc nền
  double get musicVolume => _musicVolume;

  /// Lấy âm lượng hiệu ứng âm thanh
  double get soundVolume => _soundVolume;
}
