import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'dart:async';

/// A factory class for creating and caching Spine components
class SpineComponentFactory {
  /// Singleton instance
  static final SpineComponentFactory _instance =
      SpineComponentFactory._internal();

  /// Factory constructor
  factory SpineComponentFactory() {
    return _instance;
  }

  /// Private constructor
  SpineComponentFactory._internal();

  /// Cache of created Spine components
  final Map<String, List<SpineComponent>> _componentCache = {};

  /// Maximum size of component cache per skeleton
  final int _maxCacheSize = 20;

  /// Create a deep copy of an existing Spine component
  Future<SpineComponent> cloneComponent(
      String key, SpineComponent original) async {
    // We need to reload from assets since Spine doesn't support direct cloning
    return getComponent(
      key,
      skeletonFile: 'assets/Feed the Shark/$key/skeleton.json',
      atlasFile: 'assets/Feed the Shark/$key/skeleton_hdr.atlas.txt',
      position: original.position.clone(),
      size: original.size.clone(),
      scale: original.scale.clone(),
      anchor: original.anchor,
      defaultAnimation:
          original.animationState.getCurrent(0)?.getAnimation().getName() ??
              'Idie',
      loop: original.animationState.getCurrent(0)?.getLoop() ?? true,
    );
  }

  /// Get a Spine component (either cached or new)
  Future<SpineComponent> getComponent(
    String key, {
    required String skeletonFile,
    required String atlasFile,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    Anchor? anchor,
    String? defaultAnimation,
    bool loop = true,
  }) async {
    // Try to get from cache
    if (_componentCache.containsKey(key) && _componentCache[key]!.isNotEmpty) {
      final component = _componentCache[key]!.removeLast();

      // Reset component properties
      if (position != null) component.position = position;
      if (size != null) component.size = size;
      if (scale != null) component.scale = scale;
      if (anchor != null) component.anchor = anchor;

      if (defaultAnimation != null) {
        component.animationState.setAnimationByName(0, defaultAnimation, loop);
      }

      return component;
    }

    // Create a new component from assets
    final component = await SpineComponent.fromAssets(
      skeletonFile: skeletonFile,
      atlasFile: atlasFile,
      position: position ?? Vector2.zero(),
      anchor: anchor ?? Anchor.center,
    );

    if (size != null) {
      component.size = size;
    }

    if (scale != null) {
      component.scale = scale;
    }

    if (defaultAnimation != null) {
      component.animationState.setAnimationByName(0, defaultAnimation, loop);
    } else {
      component.animationState.setAnimationByName(0, 'Idie', true);
    }

    return component;
  }

  /// Return a component to the cache for reuse
  void releaseComponent(String key, SpineComponent component) {
    if (component.isMounted) {
      component.removeFromParent();
    }

    _componentCache[key] ??= [];
    if (_componentCache[key]!.length < _maxCacheSize) {
      _componentCache[key]!.add(component);
    }
  }

  /// Clear the cache for a specific key
  void clearCache(String key) {
    _componentCache.remove(key);
  }

  /// Clear all caches
  void clearAllCaches() {
    _componentCache.clear();
  }

  /// Preload components for better performance
  Future<void> preloadComponents(
    Map<String, Map<String, String>> components, {
    int countPerType = 2,
  }) async {
    for (final entry in components.entries) {
      final key = entry.key;
      final files = entry.value;

      _componentCache[key] ??= [];

      // Preload a few components of each type
      for (int i = 0; i < countPerType; i++) {
        if (_componentCache[key]!.length >= _maxCacheSize) break;

        final component = await SpineComponent.fromAssets(
          skeletonFile: files['skeleton']!,
          atlasFile: files['atlas']!,
          anchor: Anchor.center,
        );

        component.animationState.setAnimationByName(0, 'Idie', true);
        _componentCache[key]!.add(component);
      }
    }
  }
}
