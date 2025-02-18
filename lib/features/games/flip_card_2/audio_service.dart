import 'package:flutter_soloud/flutter_soloud.dart';

import 'config/asset_paths.dart';

class AudioService {
  late SoLoud _soloud;

  late final AudioSource _cardFlip;
  late final AudioSource _gameStart;
  late final AudioSource _victory;

  Future<void> initialize() async {
    _soloud = SoLoud.instance;
    if (_soloud.isInitialized) {
      return;
    }
    await _soloud.init();
    _cardFlip = await _soloud.loadAsset(AssetPaths.cardFlipSound);
    _gameStart = await _soloud.loadAsset(AssetPaths.gameStartSound);
    _victory = await _soloud.loadAsset(AssetPaths.victorySound);
  }

  Future<void> playCardFlip() async {
    await _soloud.play(_cardFlip);
  }

  Future<void> playGameStart() async {
    await _soloud.play(_gameStart);
  }

  Future<void> playMatchSound(String soundPath) async {
    AudioSource matchSound = await _soloud.loadAsset(soundPath);
    await _soloud.play(matchSound);
  }

  Future<void> playVictory() async {
    await _soloud.play(_victory);
  }

  void dispose() {
    _soloud.deinit();
  }
}
