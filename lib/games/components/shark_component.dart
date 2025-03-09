import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';

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

  /// Direction of attack (1 for right to left, -1 for left to right)
  int _attackDirection = -1;

  /// Speed the shark moves at
  final double speed;

  /// Sound effect for when the shark eats
  final String eatSoundEffect;

  /// Duration for eating animation
  final Duration eatingDuration;

  /// Duration for swimming animation
  final Duration swimmingDuration;

  /// Size of the game screen
  final Vector2 gameSize;

  /// Callback when fish is eaten
  Function? onFishEaten;

  /// Animation finished callback
  Function? onAnimationFinished;

  /// The animation component
  SpineComponent? _animationComponent;

  /// Audio service instance
  final AudioService _audioService = AudioService();

  /// Animation names for different states
  static const String _attackAnimationName = 'shark bite';
  static const String _eatAnimationName = 'animation';
  static const String _swimAnimationName = 'Idie';
  static const String _happyAnimationName = 'shark happy';

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
    required this.gameSize,
    this.onFishEaten,
  }) : super(position: position, size: size, priority: 100) {
    // Thiết lập priority cao để luôn hiển thị trên cùng
    _animationComponent = spineComponent;
    _animationComponent?.scale = Vector2(0.25, 0.25);
    _animationComponent?.animationState.setListener(_animationListener);

    // Set initial animation to idle
    _playAnimation(_swimAnimationName, loop: true);

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
  void _playAnimation(String name, {bool loop = false}) {
    _animationComponent?.animationState.setAnimationByName(0, name, loop);
  }

  void _animationListener(EventType type, TrackEntry entry, Event? event) {
    // Kiểm tra component đã được mount chưa trước khi xử lý animation
    if (!isMounted) return;

    if (type == EventType.start &&
        entry.getAnimation().getName() == _eatAnimationName) {
      _endAnimationEating();
    }
    if (type == EventType.complete &&
        entry.getAnimation().getName() == _eatAnimationName) {
      _completeAnimationEating();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Kiểm tra component đã được mount chưa trước khi update
    if (!isMounted) return;

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
    } else if (_state == SharkState.swimming) {
      final direction = _targetPosition - position;
      if (direction.length > speed * dt) {
        position += direction.normalized() * speed * dt;
      }
    }
  }

  /// Start the attack animation and move towards the target
  void attack(Vector2 targetPosition, {int attackDirection = -1}) {
    if (_state != SharkState.hidden) return;

    _state = SharkState.attacking;
    _targetPosition = targetPosition;
    _attackDirection = attackDirection;

    // Set initial position based on attack direction
    if (_attackDirection > 0) {
      // Attack from right
      position = Vector2(gameSize.x + 100, targetPosition.y);

      // Flip shark horizontally if it's attacking from the right
      if (_animationComponent != null &&
          _animationComponent!.isFlippedHorizontally) {
        _animationComponent!.flipHorizontally();
      }
    } else {
      // Attack from left
      position = Vector2(-300, targetPosition.y);

      // Make sure shark is not flipped if attacking from the left
      if (_animationComponent != null &&
          !_animationComponent!.isFlippedHorizontally) {
        _animationComponent!.flipHorizontally();
      }
    }

    _playAnimation(_attackAnimationName);

    // Make the shark visible
    _setVisibility(true);
  }

  /// Start the eating animation
  void _startEating() {
    _state = SharkState.eating;
    _playAnimation(_eatAnimationName);
    _audioService.playSoundEffect(eatSoundEffect);
  }

  void _endAnimationEating() {
    // Gọi callback để xóa con cá trước
    if (onFishEaten != null) {
      onFishEaten!();
    }
  }

  void _completeAnimationEating() {
    // Gọi callback để xóa con cá trước
    if (onFishEaten != null) {
      onFishEaten!();
    }

    // Đợi 0.5 giây trước khi bắt đầu bơi đi
    Future.delayed(const Duration(milliseconds: 100), () {
      _startSwimming();
    });
  }

  /// Start the swimming animation to swim away
  void _startSwimming() {
    _state = SharkState.swimming;
    _playAnimation(_swimAnimationName, loop: true);

    // Cho cá mập bơi ra khỏi màn hình
    _swimAway();
  }

  /// Make the shark swim away off screen
  void _swimAway() {
    // Kiểm tra component đã được mount chưa trước khi thực hiện
    if (!isMounted) return;

    // Xác định điểm đích để cá mập bơi ra khỏi màn hình
    Vector2 destinationPoint;

    if (_attackDirection > 0) {
      // Nếu tấn công từ phải, bơi về bên trái
      destinationPoint = Vector2(-300, position.y);
    } else {
      // Nếu tấn công từ trái, bơi về bên phải
      destinationPoint = Vector2(gameSize.x + 100, position.y);
    }
    _targetPosition = destinationPoint;

    // Tính thời gian di chuyển dựa vào khoảng cách và tốc độ
    final distance = (destinationPoint - position).length;
    final swimTime = (distance / speed) * 1000; // Chuyển đổi thành milliseconds

    // Đặt hẹn giờ để ẩn cá mập sau khi bơi ra khỏi màn hình
    Future.delayed(Duration(milliseconds: swimTime.toInt()), () {
      // Check if component is still mounted before proceeding
      if (!isMounted) return;

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

  @override
  void onRemove() {
    // Đảm bảo dừng tất cả các animation và callback
    _state = SharkState.hidden;
    super.onRemove();
  }
}
