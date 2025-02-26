// File: lib/game/components/monkey.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Monkey extends SpriteAnimationComponent with HasGameRef {
  Monkey({
    required super.position,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load monkey sprite sheets
    final spriteSheet = await game.images.load('images/monkey_sprite_sheet.png');

    // Create animation from sprite sheet
    // Assuming the sprite sheet has 8 frames in a row
    const int frameCount = 8;
    const frameWidth = 128; // Adjust according to your sprite sheet
    const frameHeight = 128; // Adjust according to your sprite sheet

    final spriteSize = Vector2(frameWidth.toDouble(), frameHeight.toDouble());

    // Create sprites
    final List<Sprite> sprites = [];
    for (int i = 0; i < frameCount; i++) {
      sprites.add(
        Sprite(
          spriteSheet,
          srcPosition: Vector2(i * frameWidth.toDouble(), 0),
          srcSize: spriteSize,
        ),
      );
    }

    // Create animation
    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.1,
      loop: true,
    );

    // Set anchor
    anchor = Anchor.center;

    // Add jumping effect
    add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(duration: 0.3),
          ),
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.3),
          ),
        ],
        infinite: true,
      ),
    );
  }
}
