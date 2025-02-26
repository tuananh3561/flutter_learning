import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../models/fruit.dart';
import '../services/game_service.dart';

/// Helper class for loading and managing game assets
class AssetLoader {
  /// The images cache
  final Images _imagesCache;

  /// Asset paths that have been verified to exist
  final Set<String> _validatedAssets = {};

  /// Constructor
  AssetLoader({Images? imagesCache}) : _imagesCache = imagesCache ?? Images();

  /// Preload all game assets
  Future<void> preloadAssets(List<Fruit> fruits) async {
    await _preloadFruitAssets(fruits);
    await _preloadUIAssets();
    await _preloadSoundAssets();
  }

  /// Preload all fruit-related assets
  Future<void> _preloadFruitAssets(List<Fruit> fruits) async {
    for (final fruit in fruits) {
      // Validate and load image
      if (await _validateAsset(fruit.imagePath)) {
        await _imagesCache.load(fruit.imagePath);
      }
    }
  }

  /// Preload UI assets
  Future<void> _preloadUIAssets() async {
    final uiAssets = [
      GameConfig.speakerIconPath,
      GameConfig.monkeySpriteSheetPath,
      GameConfig.coinImagePath,
    ];

    for (final asset in uiAssets) {
      if (await _validateAsset(asset)) {
        await _imagesCache.load(asset);
      }
    }
  }

  /// Preload sound assets
  Future<void> _preloadSoundAssets() async {
    final soundAssets = [
      GameConfig.correctSoundPath,
      GameConfig.incorrectSoundPath,
      GameConfig.celebrationSoundPath,
    ];

    for (final asset in soundAssets) {
      await _validateAsset(asset);
    }
  }

  /// Validate that an asset exists
  Future<bool> _validateAsset(String assetPath) async {
    // Skip validation if already validated
    if (_validatedAssets.contains(assetPath)) {
      return true;
    }

    try {
      // Try to load the asset to see if it exists
      await rootBundle.load(assetPath);
      _validatedAssets.add(assetPath);
      return true;
    } catch (e) {
      print('Warning: Asset not found: $assetPath');
      return false;
    }
  }

  /// Get a list of all required assets for pubspec.yaml
  static List<String> getAllRequiredAssets(List<Fruit> fruits) {
    final List<String> assets = [];

    // Add fruit assets
    for (final fruit in fruits) {
      assets.add(fruit.imagePath);
      assets.add(fruit.soundPath);
    }

    // Add UI assets
    assets.addAll([
      GameConfig.speakerIconPath,
      GameConfig.monkeySpriteSheetPath,
      GameConfig.coinImagePath,
    ]);

    // Add sound assets
    assets.addAll([
      GameConfig.correctSoundPath,
      GameConfig.incorrectSoundPath,
      GameConfig.celebrationSoundPath,
    ]);

    return assets;
  }

  /// Get a sample pubspec.yaml assets section
  static String getPubspecAssetsSection(List<Fruit> fruits) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('flutter:');
    buffer.writeln('  assets:');

    // Add all assets
    for (final asset in getAllRequiredAssets(fruits)) {
      buffer.writeln('    - $asset');
    }

    return buffer.toString();
  }
}
