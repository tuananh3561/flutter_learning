import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';

/// States the shark can be in
enum SharkState {
  /// Not visible
  hidden,

  /// Moving toward fish
  attacking,

  /// Eating the fish
  eating,

  /// Swimming away
  swimming,
}

/// Component representing the shark in the Feed the Shark game
class SharkComponent extends PositionComponent {
  /// Current state of the shark
  SharkState _state = SharkState.hidden;

  /// Target fish position
  late Vector2 _targetPosition;

  /// Speed the shark moves at
  final double speed;

  /// Sound effect for when the shark eats
  final String eatSoundEffect;

  /// Duration for eating animation
  final Duration eatingDuration;

  /// Duration for swimming animation
  final Duration swimmingDuration;

  /// Animation finished callback
  Function? onAnimationFinished;

  /// The animation component
  SpineComponent? _animationComponent;

  /// Audio service instance
  final AudioService _audioService = AudioService();

  /// Animation names for different states
  static const String _attackAnimationName = 'attack';
  static const String _eatAnimationName = 'eat';
  static const String _swimAnimationName = 'idle';

  /// Whether the shark is visible
  bool _isVisible = false;

  /// Constructor
  SharkComponent({
    required this.speed,
    required this.eatSoundEffect,
    required this.eatingDuration,
    required this.swimmingDuration,
    required Vector2 position,
    required Vector2 size,
    required SpineComponent spineComponent,
  }) : super(position: position, size: size) {
    _animationComponent = spineComponent;

    // Add the animation component as a child
    if (_animationComponent != null) {
      add(_animationComponent!);
    }

    // Initially hidden
    _setVisibility(false);
  }

  /// Helper method to set visibility
  void _setVisibility(bool visible) {
    _isVisible = visible;
    // Hide/show the component by controlling the animation component's opacity
    // if (_animationComponent != null) {
    //   _animationComponent!.opacity = visible ? 1.0 : 0.0;
    // }
  }

  /// Helper method to play an animation
  void _playAnimation(String name, {bool loop = false, Function? onComplete}) {
    // This is a simplified version that doesn't actually change animations
    // In a real implementation with Spine, this would switch animations
    // if (_animationComponent?.animation != null) {
    //   _animationComponent?.playing = true;

    //   // If there's a completion callback, schedule it
    //   if (onComplete != null) {
    //     final duration =
    //         name == _eatAnimationName ? eatingDuration : swimmingDuration;
    //     Future.delayed(duration, () {
    //       onComplete();
    //     });
    //   }
    // }
    _animationComponent?.animationState
        .setAnimationByName(0, 'shark bite', true);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == SharkState.attacking) {
      // Move towards target
      final direction = _targetPosition - position;
      if (direction.length > speed * dt) {
        position += direction.normalized() * speed * dt;
      } else {
        // Reached target, start eating
        position = _targetPosition;
        _startEating();
      }
    }
  }

  /// Start the attack animation and move towards the target
  void attack(Vector2 targetPosition) {
    if (_state != SharkState.hidden) return;

    _state = SharkState.attacking;
    _targetPosition = targetPosition;
    _playAnimation(_attackAnimationName);

    // Make the shark visible
    _setVisibility(true);
  }

  /// Start the eating animation
  void _startEating() {
    _state = SharkState.eating;
    _playAnimation(_eatAnimationName, onComplete: () {
      _startSwimming();
    });
    _audioService.playSoundEffect(eatSoundEffect);
  }

  /// Start the swimming animation to swim away
  void _startSwimming() {
    _state = SharkState.swimming;
    _playAnimation(_swimAnimationName, loop: true);

    // When swimming animation should finish (after duration)
    Future.delayed(swimmingDuration, () {
      if (_state == SharkState.swimming) {
        hide();
        if (onAnimationFinished != null) {
          onAnimationFinished!();
        }
      }
    });
  }

  /// Hide the shark (set opacity to 0)
  void hide() {
    _state = SharkState.hidden;
    _setVisibility(false);
  }
}
