import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../engine/resource_manager.dart';

/// Màn hình hiển thị tiến trình tải tài nguyên
class LoadingScreen extends PositionComponent {
  /// Progress bar background
  late RectangleComponent _background;

  /// Progress bar indicator
  late RectangleComponent _progressBar;

  /// Loading text
  late TextComponent _loadingText;

  /// Loading description
  late TextComponent _loadingDescription;

  /// Action to perform when loading is complete
  final VoidCallback onLoadingComplete;

  /// Whether loading has been marked as complete
  bool _isCompleteHandled = false;

  /// Background color for progress bar
  final Color backgroundColor;

  /// Progress bar color
  final Color progressColor;

  /// Text color
  final Color textColor;

  /// Resource manager instance
  final ResourceManager _resourceManager = ResourceManager();

  /// Loading tips
  final List<String> _loadingTips = [
    'Đang tải hình ảnh...',
    'Đang tải âm thanh...',
    'Đang chuẩn bị Spine animations...',
    'Sắp xong rồi...',
    'Hãy chọn đúng từ vựng để cho cá mập ăn!',
    'Cá mập rất thích từ vựng đúng!',
  ];

  /// Current tip index
  int _currentTipIndex = 0;

  /// Timer for rotating tips
  double _tipTimer = 0;

  /// Interval for tip rotation (seconds)
  final double _tipInterval = 2.5;

  /// Loading screen constructor
  LoadingScreen({
    required Vector2 size,
    required this.onLoadingComplete,
    this.backgroundColor = const Color(0x88000000),
    this.progressColor = Colors.blue,
    this.textColor = Colors.white,
  }) : super(
          size: size,
          position: Vector2.zero(),
          priority: 1000, // Very high priority to be rendered on top
        ) {
    _setupComponents();
  }

  /// Setup all child components
  void _setupComponents() {
    // Add semi-transparent background covering entire screen
    final fullScreenBackground = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      paint: Paint()..color = const Color(0xCC000000),
    );
    add(fullScreenBackground);

    // Add gradient decoration at top and bottom
    final topGradient = GradientComponent(
      size: Vector2(size.x, 100),
      position: Vector2(0, 0),
      from: Colors.blue.withOpacity(0.3),
      to: Colors.transparent,
      direction: GradientDirection.bottomToTop,
    );
    add(topGradient);

    final bottomGradient = GradientComponent(
      size: Vector2(size.x, 100),
      position: Vector2(0, size.y - 100),
      from: Colors.blue.withOpacity(0.3),
      to: Colors.transparent,
      direction: GradientDirection.topToBottom,
    );
    add(bottomGradient);

    // Add title
    final titleText = TextComponent(
      text: 'Chuẩn bị cho game Feed the Shark',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    titleText.position = Vector2(
      size.x / 2,
      size.y / 4,
    );
    titleText.anchor = Anchor.center;
    add(titleText);

    // Add progress bar background
    final progressBarWidth = size.x * 0.8;
    const progressBarHeight = 30.0;
    final progressBarX = (size.x - progressBarWidth) / 2;
    final progressBarY = size.y / 2;

    _background = RectangleComponent(
      size: Vector2(progressBarWidth, progressBarHeight),
      position: Vector2(progressBarX, progressBarY),
      paint: Paint()..color = backgroundColor,
    );
    add(_background);

    // Add progress bar indicator (initially zero width)
    _progressBar = RectangleComponent(
      size: Vector2(0, progressBarHeight),
      position: Vector2(progressBarX, progressBarY),
      paint: Paint()..color = progressColor,
    );
    add(_progressBar);

    // Add progress percentage text
    _loadingText = TextComponent(
      text: 'Loading... 0%',
      textRenderer: TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    _loadingText.position = Vector2(
      size.x / 2,
      progressBarY - 40,
    );
    _loadingText.anchor = Anchor.center;
    add(_loadingText);

    // Add loading description
    _loadingDescription = TextComponent(
      text: _loadingTips[0],
      textRenderer: TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    );

    _loadingDescription.position = Vector2(
      size.x / 2,
      progressBarY + 60,
    );
    _loadingDescription.anchor = Anchor.center;
    add(_loadingDescription);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update progress bar based on loading status
    final progress = _resourceManager.loadingProgress;
    final progressBarWidth = _background.size.x * progress;
    _progressBar.size.x = progressBarWidth;

    // Update text
    final progressPercent = (progress * 100).toInt();
    _loadingText.text = 'Loading... $progressPercent%';

    // Rotate tips
    _tipTimer += dt;
    if (_tipTimer >= _tipInterval) {
      _tipTimer = 0;
      _currentTipIndex = (_currentTipIndex + 1) % _loadingTips.length;
      _loadingDescription.text = _loadingTips[_currentTipIndex];
    }

    // Check if loading is complete
    if (_resourceManager.isLoaded && !_isCompleteHandled) {
      _isCompleteHandled = true;
      // Delay a bit to show 100% before removing
      Future.delayed(const Duration(milliseconds: 500), () {
        onLoadingComplete();
      });
    }

    // Check for errors
    if (_resourceManager.loadingState == ResourceLoadingState.error) {
      _loadingText.text = 'Error: ${_resourceManager.errorMessage}';
      _progressBar.paint.color = Colors.red;
    }
  }
}

/// Component to draw a gradient
class GradientComponent extends PositionComponent {
  /// Start color of gradient
  final Color from;

  /// End color of gradient
  final Color to;

  /// Direction of gradient
  final GradientDirection direction;

  /// Constructor
  GradientComponent({
    required Vector2 size,
    required Vector2 position,
    required this.from,
    required this.to,
    this.direction = GradientDirection.leftToRight,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    final gradient = LinearGradient(
      begin: _getBegin(),
      end: _getEnd(),
      colors: [from, to],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  /// Get begin alignment based on direction
  Alignment _getBegin() {
    switch (direction) {
      case GradientDirection.leftToRight:
        return Alignment.centerLeft;
      case GradientDirection.rightToLeft:
        return Alignment.centerRight;
      case GradientDirection.topToBottom:
        return Alignment.topCenter;
      case GradientDirection.bottomToTop:
        return Alignment.bottomCenter;
    }
  }

  /// Get end alignment based on direction
  Alignment _getEnd() {
    switch (direction) {
      case GradientDirection.leftToRight:
        return Alignment.centerRight;
      case GradientDirection.rightToLeft:
        return Alignment.centerLeft;
      case GradientDirection.topToBottom:
        return Alignment.bottomCenter;
      case GradientDirection.bottomToTop:
        return Alignment.topCenter;
    }
  }
}

/// Direction for gradient
enum GradientDirection {
  /// Left to right (horizontal)
  leftToRight,

  /// Right to left (horizontal)
  rightToLeft,

  /// Top to bottom (vertical)
  topToBottom,

  /// Bottom to top (vertical)
  bottomToTop,
}
