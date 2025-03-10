import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'audio_button_component.dart';

/// Component hiển thị hình ảnh và từ vựng
class ImageCardComponent extends PositionComponent {
  /// Đường dẫn đến file hình ảnh
  final String imagePath;

  /// Văn bản hiển thị (nếu có)
  final String? text;

  /// Có hiển thị border hay không
  final bool showBorder;

  /// Background color
  final Color backgroundColor;

  /// Border color
  final Color borderColor;

  /// Border width
  final double borderWidth;

  /// Sprite cho hình ảnh
  Sprite? _sprite;

  /// Constructor
  ImageCardComponent({
    required this.imagePath,
    required Vector2 position,
    required Vector2 size,
    this.text,
    this.showBorder = true,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Tạo background
    final roundedRectPainter = RoundedRectPainter(
      color: backgroundColor, // Màu trắng
      borderRadius: 15.0,
    );

    final customPaintComponent = CustomPainterComponent(
      painter: roundedRectPainter,
      position: Vector2.zero(),
      size: size,
    );

    add(customPaintComponent);

    // Tạo border nếu cần
    if (showBorder) {
      // Thêm border với viền bo tròn
      final borderPainter = RoundedRectBorderPainter(
        color: borderColor,
        borderRadius: 15.0,
        strokeWidth: 1,
      );

      add(CustomPainterComponent(
        painter: borderPainter,
        position: Vector2.zero(),
        size: size,
      ));
    }

    try {
      // Tải sprite
      _sprite = await Sprite.load(imagePath);

      // Tính toán scale để hình ảnh vừa với card
      final imageRatio = _sprite!.srcSize.x / _sprite!.srcSize.y;
      final cardRatio = size.x / size.y;

      Vector2 spriteSize;
      if (imageRatio > cardRatio) {
        // Hình ảnh rộng hơn
        spriteSize = Vector2(
          size.x * 0.9,
          size.x * 0.9 / imageRatio,
        );
      } else {
        // Hình ảnh cao hơn
        spriteSize = Vector2(
          size.y * 0.7 * imageRatio,
          size.y * 0.7,
        );
      }

      // Thêm sprite vào component
      add(SpriteComponent(
        sprite: _sprite,
        position: Vector2(size.x / 2, size.y * 0.45),
        size: spriteSize,
        anchor: Anchor.center,
      ));
    } catch (e) {
      print('Error loading image: $e');

      // Tạo fallback nếu không tải được hình ảnh
      add(RectangleComponent(
        size: Vector2(size.x * 0.8, size.y * 0.5),
        position: Vector2(size.x * 0.1, size.y * 0.2),
        paint: Paint()
          ..color = Colors.grey.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      ));
    }

    // Thêm text nếu có
    if (text != null && text!.isNotEmpty) {
      final textComponent = TextComponent(
        text: text!,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y * 0.85),
      );
      add(textComponent);
    }
  }
}

/// Component hiển thị nhiều hình ảnh theo grid
class ImageGridComponent extends PositionComponent {
  /// Danh sách đường dẫn hình ảnh
  final List<String> imagePaths;

  /// Số cột
  final int columns;

  /// Khoảng cách giữa các hình ảnh
  final double padding;

  /// Constructor
  ImageGridComponent({
    required this.imagePaths,
    required Vector2 position,
    required Vector2 size,
    this.columns = 2,
    this.padding = 10,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Tính toán số lượng hàng
    final rows = (imagePaths.length / columns).ceil();

    // Tính toán kích thước mỗi hình ảnh
    final cardWidth = (size.x - (padding * (columns + 1))) / columns;
    final cardHeight = (size.y - (padding * (rows + 1))) / rows;
    final cardSize = Vector2(cardWidth, cardHeight);

    // Tạo các card hình ảnh
    for (int i = 0; i < imagePaths.length; i++) {
      final row = i ~/ columns;
      final col = i % columns;

      final cardPosition = Vector2(
        padding + col * (cardWidth + padding),
        padding + row * (cardHeight + padding),
      );

      add(ImageCardComponent(
        imagePath: imagePaths[i],
        position: cardPosition,
        size: cardSize,
      ));
    }
  }
}
