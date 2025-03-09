import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';

/// Represents a fish in the Feed the Shark game
class FishComponent extends PositionComponent with TapCallbacks {
  /// The text associated with this fish
  final String text;

  /// The audio file associated with this fish
  final String audioFile;

  /// Direction the fish is swimming (-1 = left to right, 1 = right to left)
  final int direction;

  /// Lane number (0-3) determining vertical position
  final int lane;

  /// Speed at which the fish moves
  final double speed;

  /// Whether this fish is the correct answer
  final bool isCorrectAnswer;

  /// Callback when fish is tapped
  final Function(FishComponent) onTap;

  /// Whether the fish is currently being eaten
  bool isBeingEaten = false;

  /// Whether the fish is stunned after being tapped (and before being eaten)
  bool isStunned = false;

  /// Whether the fish is shaking (when incorrectly tapped)
  bool isShaking = false;

  /// Counter for wrong taps on this fish
  int wrongTapCount = 0;

  /// Whether fish is escaping (after 3 wrong taps)
  bool isEscaping = false;

  /// Text component to display on fish belly
  TextComponent? _textComponent;

  /// The component for animation
  SpineComponent? _animationComponent;

  /// Minimum scale for the animation component
  static const double _minScale = 0.25;
  static const double _defaultScale = 0.1;

  /// Scale factor per character
  static const double _scaleFactorPerChar = 0.02;

  /// Audio service instance
  final AudioService _audioService = AudioService();

  /// Animation names for different states
  static const String _swimAnimationName = 'Idie';
  static const String _tapAnimationName = 'user tap';
  static const String _untapAnimationName = 'user Untap';
  static const String _untapLoopAnimationName = 'user Untap loop';

  /// Constructor
  FishComponent({
    required this.text,
    required this.audioFile,
    required this.direction,
    required this.lane,
    required this.speed,
    required this.isCorrectAnswer,
    required this.onTap,
    required Vector2 position,
    required Vector2 size,
    required SpineComponent spineComponent,
  }) : super(position: position, size: size) {
    // Store the animation component (we call it spineComponent for compatibility)
    _animationComponent = spineComponent;
    _animationComponent?.priority = 80;

    // Set initial animation to idle
    _playAnimation(_swimAnimationName, loop: true);

    // Set random skin
    _setRandomSkin();

    // Set initial scale based on direction and text length
    _adjustAnimationScale();

    // Flip horizontally if direction is negative
    if (direction < 0) {
      _animationComponent?.flipHorizontally();
    }

    // Add the animation component as a child
    if (_animationComponent != null) {
      add(_animationComponent!);
    }

    // Add text on fish belly
    _addTextComponent();
  }

  /// Set random skin for the fish
  void _setRandomSkin() {
    final skinsAvailable = _animationComponent?.skeleton.getData()?.getSkins();
    final skinsName = skinsAvailable?.map((skin) => skin.getName()).toList();

    if (skinsName != null && skinsName.isNotEmpty) {
      // Create Random object
      final random = Random();
      // Create a new list excluding the first element (index 0)
      final skinsExcludingFirst = skinsName.sublist(1);
      // Randomly get an index within the range of the list
      final randomIndex = random.nextInt(skinsExcludingFirst.length);
      // Get skin name at random position
      final randomSkinName = skinsExcludingFirst[randomIndex];
      // Áp dụng skin này
      _animationComponent?.skeleton.setSkinByName(randomSkinName);
      _animationComponent?.skeleton.setSlotsToSetupPose();
    }
  }

  /// Adjusts the animation scale based on text length
  void _adjustAnimationScale() {
    if (_animationComponent == null) return;

    // Calculate scale factor based on text length
    // Longer text means larger fish
    final scaleX =
        max(_minScale, _defaultScale + (text.length * _scaleFactorPerChar));

    // Keep y scale as minimum
    final scaleY =
        max(_minScale, _defaultScale + (text.length * _scaleFactorPerChar / 2));

    // Apply the new scale
    _animationComponent!.scale = Vector2(scaleX, scaleY);

    // Update component size based on new scale
    if (_animationComponent!.size.x > 0 && _animationComponent!.size.y > 0) {
      size = _animationComponent!.size * scaleX;
    }
    _animationComponent?.position = size / 2;
  }

  /// Add text component to display on fish belly
  void _addTextComponent() {
    _textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (_textComponent != null) {
      // Position text on fish belly - may need adjustment based on fish size
      _textComponent!.position = Vector2(
        direction > 0 ? size.x / 2 - 16 : size.x / 2 + 16,
        size.y / 2, // Slightly below center for "belly" position
      );

      // Center text
      _textComponent!.anchor = Anchor.center;
      _textComponent!.priority = 90;
      // Add text component as a child
      add(_textComponent!);
    }
  }

  /// Helper method to play an animation
  void _playAnimation(String name, {bool loop = false}) {
    // This is a simplified version that doesn't actually change animations
    // In a real implementation with Spine, this would switch animations
    // if (_animationComponent?.animation != null) {
    //   if (name == 'shake') {
    //     // For shaking, we'll actually shake the component in the update method
    //   } else if (name == 'stunned') {
    //     // For stunned, we'll stop the animation
    //     _animationComponent?.animationTicker?.reset();
    //     _animationComponent?.playing = false;
    //   } else if (name == 'idle' && loop) {
    //     // Resume playing for idle
    //     _animationComponent?.playing = true;
    //   }
    // }
    _animationComponent?.animationState.setAnimationByName(0, name, loop);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Kiểm tra component đã được mount chưa trước khi cập nhật
    if (!isMounted) return;

    if (isEscaping) {
      // Move much faster when escaping
      position.x += direction * speed * dt * 5;
      // Optionally make the fish "dive" down when escaping
      position.y += 50 * dt;
      return;
    }

    if (!isBeingEaten && !isStunned) {
      // Move the fish based on direction and speed
      position.x += direction * speed * dt;
    }

    if (isShaking) {
      // Apply shaking effect when incorrectly tapped
      position.y +=
          sin(DateTime.now().millisecondsSinceEpoch / 50).toDouble() * 2;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    // Don't process taps when fish is escaping
    if (isEscaping) return;

    onTap(this);
  }

  /// Play the audio associated with this fish
  Future<void> playAudio() async {
    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    await _audioService.playWordSound(audioFile);
  }

  /// Stun the fish (when correctly tapped)
  void stun() {
    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    isStunned = true;
    _playAnimation('user tap');
  }

  /// Make the fish shake (when incorrectly tapped)
  void shake() {
    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    isShaking = true;
    // Increment wrong tap counter
    wrongTapCount++;

    // Check if this fish should escape
    if (wrongTapCount >= 3 && !isCorrectAnswer) {
      startEscaping();
      return;
    }

    // Start a timer to stop shaking after a short time
    Future.delayed(const Duration(milliseconds: 500), () {
      // Kiểm tra component đã được mount chưa
      if (!isMounted) return;

      isShaking = false;
      if (!isBeingEaten && !isStunned && !isEscaping) {
        _playAnimation(_swimAnimationName, loop: true);
      }
    });
  }

  /// Start escaping animation after 3 wrong taps
  void startEscaping() {
    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    isEscaping = true;
    isShaking = false;

    // Optionally play a "scared" animation if available
    _playAnimation(_tapAnimationName, loop: true);

    // Play a sound effect for escaping
    _audioService.playSoundEffect(audioFile);
  }

  /// Start the "being eaten" animation
  void startEatingAnimation() {
    // Kiểm tra component đã được mount chưa
    if (!isMounted) return;

    isBeingEaten = true;
    // We'll keep the stunned animation while being eaten
  }

  @override
  void onRemove() {
    // Dừng tất cả animations và callbacks
    isShaking = false;
    isEscaping = false;
    isBeingEaten = false;
    isStunned = false;

    super.onRemove();
  }

  /// Check if fish is out of bounds
  bool isOutOfBounds(Vector2 gameSize) {
    return (direction < 0 && position.x < -size.x - 50) ||
        (direction > 0 && position.x > gameSize.x + 50) ||
        (isEscaping &&
            position.y > gameSize.y + 50); // Add check for diving down
  }
}
