import 'dart:convert';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/game_config.dart';

/// Component quản lý background và các decorations
class BackgroundComponents extends PositionComponent {
  /// Config file path
  final String configFilePath;

  /// Game size
  final Vector2 gameSize;

  /// Background sprite component
  SpriteComponent? _background;

  /// Map of spine components
  final Map<String, SpineComponent> _spineComponents = {};

  /// List of decoration components
  final List<Component> _decorations = [];

  /// Random number generator
  final Random _random = Random();

  /// Config data
  BackgroundConfig? _config;

  /// Constructor
  BackgroundComponents({
    required this.configFilePath,
    required this.gameSize,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load configuration
    await _loadConfiguration();

    // Set background color
    if (_config != null) {
      // Tạo background nếu có trong config
      await _createBackground();

      // Tạo các decoration
      await _createDecorations();
    }
  }

  /// Load configuration from file
  Future<void> _loadConfiguration() async {
    try {
      // Đọc file config
      final String jsonString = await rootBundle.loadString(configFilePath);

      // Parse thành object
      _config = BackgroundConfig.fromJsonString(jsonString);
    } catch (e) {
      print('Error loading background configuration: $e');
      // Tạo config mặc định
      _config = BackgroundConfig(
        backgroundColor: '#87CEEB',
        decorations: [],
      );
    }
  }

  /// Create background from config
  Future<void> _createBackground() async {
    // Thêm background color
    if (_config != null) {
      final backgroundComponent = RectangleComponent(
        size: gameSize,
        paint: Paint()..color = _config!.backgroundColorValue,
      );
      add(backgroundComponent);

      // Thêm background image nếu có
      if (_config!.backgroundImage != null) {
        try {
          final bgImage = _config!.backgroundImage!;

          _background = SpriteComponent(
            sprite: await Sprite.load(bgImage.image),
            size: gameSize,
            position: Vector2.zero(),
          );

          add(_background!);
        } catch (e) {
          print('Error loading background image: $e');
        }
      }
    }
  }

  /// Create decorations from config
  Future<void> _createDecorations() async {
    if (_config == null) return;

    // Loop through all decorations in config
    for (final decoration in _config!.decorations) {
      try {
        Component? decorationComponent;

        // Create decoration based on type
        if (decoration.type == 'image') {
          decorationComponent = await _createImageDecoration(decoration);
        } else if (decoration.type == 'spine') {
          decorationComponent = await _createSpineDecoration(decoration);
        }

        // Add decoration if created successfully
        if (decorationComponent != null) {
          _decorations.add(decorationComponent);
          add(decorationComponent);
        }
      } catch (e) {
        print('Error creating decoration ${decoration.id}: $e');
      }
    }
  }

  /// Create image decoration
  Future<Component?> _createImageDecoration(DecorationConfig config) async {
    if (config.image == null) return null;

    try {
      // Load image
      final sprite = await Sprite.load(config.image!);

      // Set size
      final size = config.size ?? Vector2(100, 100);

      // Create sprite component
      final component = SpriteComponent(
        sprite: sprite,
        position: config.position?.vector ?? Vector2.zero(),
        size: size,
      );

      return component;
    } catch (e) {
      print('Error creating image decoration: $e');
      return null;
    }
  }

  /// Create spine decoration
  Future<Component?> _createSpineDecoration(DecorationConfig config) async {
    if (config.atlas == null || config.skeleton == null) return null;

    try {
      // Create spine component
      final spineComponent = await SpineComponent.fromAssets(
        atlasFile: config.atlas!,
        skeletonFile: config.skeleton!,
        scale: Vector2.all(config.scale ?? 0.1),
        anchor: Anchor.center,
        position: Vector2.zero(),
      );

      // Store spine component for reuse
      _spineComponents[config.id] = spineComponent;

      // Set animation
      if (config.animation != null) {
        spineComponent.animationState
            .setAnimationByName(0, config.animation!, true);
      }

      // Apply skin if specified
      if (config.skins != null) {
        // Check if we should choose random skin
        if (config.skins!.contains('Random')) {
          final skinsAvailable = spineComponent.skeleton.getData()?.getSkins();
          final skinsName =
              skinsAvailable?.map((skin) => skin.getName()).toList();

          // Check if nameSkins is null
          if (skinsName != null && skinsName.isNotEmpty) {
            // Create a new list excluding the first element (index 0)
            final skinsExcludingFirst =
                skinsName.length > 1 ? skinsName.sublist(1) : skinsName;
            // Randomly get an index within the range of the list
            final randomIndex = _random.nextInt(skinsExcludingFirst.length);
            // Get skin name at random position
            final randomSkinName = skinsExcludingFirst[randomIndex];
            // Áp dụng skin này
            spineComponent.skeleton.setSkinByName(randomSkinName);
            spineComponent.skeleton.setSlotsToSetupPose();
          }
        }
        // Apply a specific skin
        else if (!config.skins!.contains('Null')) {
          final skinName = config.skins!
              .split('/')
              .first; // Get first skin if multiple options
          spineComponent.skeleton.setSkinByName(skinName);
          spineComponent.skeleton.setSlotsToSetupPose();
        }
      }

      // Set scale
      spineComponent.scale = Vector2.all(config.scale ?? 0.25);

      // Create container
      final container = PositionComponent(
        position: config.position?.vector ?? Vector2.zero(),
        size: spineComponent.size * (config.scale ?? 0.25),
      );

      // Add tap detection if click_animation is set
      if (config.clickAnimation != null) {
        final tapComponent = _createTappableDecoration(config, spineComponent);
        container.add(tapComponent);
      } else {
        // Just add the spine component
        spineComponent.position = container.size / 2;
        container.add(spineComponent);
      }

      return container;
    } catch (e) {
      print('Error creating spine decoration: $e');
      return null;
    }
  }

  /// Create tappable decoration
  Component _createTappableDecoration(
      DecorationConfig config, SpineComponent spineComponent) {
    // Create tappable component
    final tappable = TappableSpineDecoration(
      spineComponent: spineComponent,
      normalAnimation: config.animation ?? 'idle',
      clickAnimation: config.clickAnimation!,
    );

    // Position spine component
    spineComponent.position = Vector2(tappable.size.x / 2, tappable.size.y / 2);
    tappable.add(spineComponent);

    return tappable;
  }

  /// Get a spine component by ID
  SpineComponent? getSpineComponentById(String id) {
    return _spineComponents[id];
  }

  /// Clean up resources
  @override
  void onRemove() {
    for (final decoration in _decorations) {
      decoration.removeFromParent();
    }
    _decorations.clear();
    _spineComponents.clear();
    super.onRemove();
  }
}

/// Tappable decoration component
class TappableSpineDecoration extends PositionComponent with TapCallbacks {
  /// Spine component
  final SpineComponent spineComponent;

  /// Normal animation name
  final String normalAnimation;

  /// Click animation name
  final String clickAnimation;

  /// Is playing click animation
  bool _isPlayingClickAnimation = false;

  TappableSpineDecoration({
    required this.spineComponent,
    required this.normalAnimation,
    required this.clickAnimation,
    super.position,
    super.size,
  }) {
    size = spineComponent.size;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (!_isPlayingClickAnimation) {
      _isPlayingClickAnimation = true;

      // Play click animation
      spineComponent.animationState
          .setAnimationByName(0, clickAnimation, false);

      // Sau khi animation kết thúc, trở lại animation bình thường
      Future.delayed(const Duration(milliseconds: 500), () {
        // Return to normal animation
        spineComponent.animationState
            .setAnimationByName(0, normalAnimation, true);
        _isPlayingClickAnimation = false;
      });
    }
  }
}
