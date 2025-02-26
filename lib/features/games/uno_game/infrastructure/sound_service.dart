import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SoundType {
  cardPlace,
  cardDraw,
  cardShuffle,
  skip,
  reverse,
  wild,
  drawTwo,
  drawFour,
  uno,
  win,
  lose,
  buttonClick,
}

enum MusicType {
  menu,
  gameplay,
  victory,
  defeat,
}

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  SoundService._internal();

  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final List<AudioPlayer> _soundPlayers =
      List.generate(5, (_) => AudioPlayer());
  int _currentSoundPlayerIndex = 0;

  // Current settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 0.7;
  double _musicVolume = 0.5;

  // Current music track
  MusicType? _currentMusic;

  // Initialize the service
  Future<void> initialize() async {
    await _loadSettings();

    // Set up music player
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicEnabled ? _musicVolume : 0);
  }

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _musicEnabled = prefs.getBool('musicEnabled') ?? true;
    _soundVolume = prefs.getDouble('soundVolume') ?? 0.7;
    _musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
  }

  // Update settings
  Future<void> updateSettings({
    bool? soundEnabled,
    bool? musicEnabled,
    double? soundVolume,
    double? musicVolume,
  }) async {
    if (soundEnabled != null) _soundEnabled = soundEnabled;
    if (musicEnabled != null) _musicEnabled = musicEnabled;
    if (soundVolume != null) _soundVolume = soundVolume;
    if (musicVolume != null) _musicVolume = musicVolume;

    // Update music player volume
    await _musicPlayer.setVolume(_musicEnabled ? _musicVolume : 0);

    // Save settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('musicEnabled', _musicEnabled);
    await prefs.setDouble('soundVolume', _soundVolume);
    await prefs.setDouble('musicVolume', _musicVolume);
  }

  // Play a sound effect
  Future<void> playSound(SoundType sound) async {
    if (!_soundEnabled) return;

    // Get next available sound player
    final player = _soundPlayers[_currentSoundPlayerIndex];
    _currentSoundPlayerIndex =
        (_currentSoundPlayerIndex + 1) % _soundPlayers.length;

    // Get asset path
    final assetPath = _getSoundAssetPath(sound);

    // Play sound
    await player.stop();
    await player.setVolume(_soundVolume);
    await player.setReleaseMode(ReleaseMode.release);
    await player.play(AssetSource(assetPath));
  }

  // Play background music
  Future<void> playMusic(MusicType music) async {
    if (_currentMusic == music) return;

    // Stop current music
    await _musicPlayer.stop();

    if (!_musicEnabled) return;

    // Get asset path
    final assetPath = _getMusicAssetPath(music);

    // Play music
    await _musicPlayer.setVolume(_musicVolume);
    await _musicPlayer.play(AssetSource(assetPath));

    _currentMusic = music;
  }

  // Stop background music
  Future<void> stopMusic() async {
    await _musicPlayer.stop();
    _currentMusic = null;
  }

  // Pause background music
  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  // Resume background music
  Future<void> resumeMusic() async {
    if (!_musicEnabled || _currentMusic == null) return;
    await _musicPlayer.resume();
  }

  // Clean up resources
  Future<void> dispose() async {
    for (final player in _soundPlayers) {
      await player.dispose();
    }
    await _musicPlayer.dispose();
  }

  // Get asset path for sound effects
  String _getSoundAssetPath(SoundType sound) {
    switch (sound) {
      case SoundType.cardPlace:
        return 'sounds/card_place.mp3';
      case SoundType.cardDraw:
        return 'sounds/card_draw.mp3';
      case SoundType.cardShuffle:
        return 'sounds/card_shuffle.mp3';
      case SoundType.skip:
        return 'sounds/skip.mp3';
      case SoundType.reverse:
        return 'sounds/reverse.mp3';
      case SoundType.wild:
        return 'sounds/wild.mp3';
      case SoundType.drawTwo:
        return 'sounds/draw_two.mp3';
      case SoundType.drawFour:
        return 'sounds/draw_four.mp3';
      case SoundType.uno:
        return 'sounds/uno.mp3';
      case SoundType.win:
        return 'sounds/win.mp3';
      case SoundType.lose:
        return 'sounds/lose.mp3';
      case SoundType.buttonClick:
        return 'sounds/button_click.mp3';
    }
  }

  // Get asset path for music
  String _getMusicAssetPath(MusicType music) {
    switch (music) {
      case MusicType.menu:
        return 'music/menu.mp3';
      case MusicType.gameplay:
        return 'music/gameplay.mp3';
      case MusicType.victory:
        return 'music/victory.mp3';
      case MusicType.defeat:
        return 'music/defeat.mp3';
    }
  }
}
