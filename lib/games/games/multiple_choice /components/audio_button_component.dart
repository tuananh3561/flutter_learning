import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../engine/resource_manager.dart';

/// Component cho nút audio có thể kéo-thả
class AudioButtonComponent extends PositionComponent
    with DragCallbacks, HasGameRef {
  /// Từ vựng liên quan đến nút
  final String text;

  /// Đường dẫn file audio
  final String audioFile;

  /// ID của zone mà nút thuộc về (nếu có)
  int? zoneId;

  /// Callback khi nút được kéo vào zone hợp lệ
  final Function(String text)? onDrop;

  /// Callback khi nút được tap
  final Function()? onTap;

  /// Vị trí ban đầu
  late final Vector2 _initialPosition;

  /// ResourceManager
  final ResourceManager _resourceManager = ResourceManager();

  /// Trạng thái đang kéo
  bool _isDragging = false;

  /// Giữ tham chiếu đến component hình nền để có thể thay đổi màu
  CustomPainterComponent? _backgroundComponent;

  /// Value notifier để theo dõi thay đổi màu sắc
  late ValueNotifier<Color> _colorNotifier;

  /// Màu mặc định của nút
  final Color _defaultColor = const Color(0xFFFFFFFF); // Màu trắng

  /// Màu khi đúng
  final Color _correctColor = const Color(0xFF4CAF50); // Màu xanh lá

  /// Màu khi sai
  final Color _incorrectColor = const Color(0xFFF44336); // Màu đỏ

  /// Nút audio constructor
  AudioButtonComponent({
    required this.text,
    required this.audioFile,
    required Vector2 position,
    required Vector2 size,
    this.zoneId,
    this.onDrop,
    this.onTap,
  }) : super(position: position, size: size) {
    _initialPosition = position.clone();
    _colorNotifier = ValueNotifier<Color>(_defaultColor);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Thay đổi màu nền thành trắng
    final backgroundPainter = RoundedRectPainter(
      color: _defaultColor, // Màu ban đầu là trắng
      borderRadius: 15.0,
      repaint: _colorNotifier, // Sử dụng notifier để vẽ lại khi màu thay đổi
    );

    _backgroundComponent = CustomPainterComponent(
      painter: backgroundPainter,
      position: Vector2.zero(),
      size: size,
    );

    add(_backgroundComponent!);

    // Thêm border với viền bo tròn
    final borderPainter = RoundedRectBorderPainter(
      color: Colors.blue.withOpacity(0.9),
      borderRadius: 15.0,
      strokeWidth: 2,
    );

    add(CustomPainterComponent(
      painter: borderPainter,
      position: Vector2.zero(),
      size: size,
    ));

    // Thêm icon loa và sóng âm thanh
    final iconSize = size.y * 0.4;
    add(SpriteComponent(
      sprite: await Sprite.load('../../assets/Multiple Choice/audio_icon.png')
        ..paint.colorFilter =
            const ColorFilter.mode(Colors.blue, BlendMode.dstIn),
      position: Vector2(size.x / 2, size.y / 2),
      size: Vector2(iconSize, iconSize),
      anchor: Anchor.center,
    ));

    // Thêm text - Ẩn text vì hình ảnh không hiển thị text
    // Giữ lại code nhưng đặt opacity = 0 để không hiển thị
    final textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white.withOpacity(0), // Ẩn text
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.8),
    );
    add(textComponent);
  }

  @override
  void onDragStart(DragStartEvent event) {
    _isDragging = true;
    priority = 100; // Đặt mức ưu tiên cao nhất khi đang kéo
    scale = Vector2.all(1.05); // Phóng to nút khi kéo

    // Phát âm thanh click
    _resourceManager
        .playSoundEffect('../../assets/Multiple Choice/SFX click.wav');

    // Đợi một chút
    Future.delayed(const Duration(microseconds: 25));

    // Phát âm thanh từ
    _resourceManager.playWordSound(audioFile);

    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.add(event.delta);
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    priority = 0; // Khôi phục mức ưu tiên mặc định
    scale = Vector2.all(1); // Khôi phục kích thước nút

    // Kiểm tra xem nút có được thả vào zone hợp lệ không
    final dropZone = _findDropZone();
    if (dropZone != null) {
      // Đặt nút vào vị trí trung tâm của zone
      position = dropZone.position + dropZone.size / 2 - size / 2;

      // Gọi callback khi thả nút vào zone
      if (onDrop != null) {
        onDrop!(text);
      }
    } else {
      // Nếu không được thả vào zone nào, quay về vị trí ban đầu
      position = _initialPosition.clone();

      // Đặt lại màu mặc định
      _resetColor();
    }

    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;
    priority = 0; // Khôi phục mức ưu tiên mặc định
    scale = Vector2.all(1); // Khôi phục kích thước nút
    position = _initialPosition.clone(); // Quay về vị trí ban đầu

    // Đặt lại màu mặc định
    _resetColor();

    super.onDragCancel(event);
  }

  @override
  bool onTapUp(TapUpEvent event) {
    print('onTapUp');
    // Nếu không đang kéo, phát âm thanh
    if (!_isDragging) {
      // Phát âm thanh của từ
      _resourceManager.playWordSound(audioFile);

      // Gọi callback khi tap
      if (onTap != null) {
        onTap!();
      }
    }
    return true;
  }

  /// Tìm drop zone mà nút đang nằm trên
  DropZoneComponent? _findDropZone() {
    // Tính toán tâm của nút
    final center = position + size / 2;

    // Kiểm tra xem nút có nằm trong zone nào không
    for (final component in gameRef.children.whereType<DropZoneComponent>()) {
      if (component.containsPoint(center)) {
        return component;
      }
    }
    return null;
  }

  /// Reset nút về vị trí ban đầu
  void reset() {
    position = _initialPosition.clone();

    // Đặt lại màu mặc định
    _resetColor();
  }

  /// Cập nhật thuộc tính khi tái sử dụng button từ pool
  void updateProperties({
    required String text,
    required String audioFile,
    required Vector2 position,
    required Vector2 size,
    Function(String)? onDrop,
    Function()? onTap,
  }) {
    // Không thể cập nhật thuộc tính final trực tiếp
    // Thay vào đó, chúng ta sẽ tạo components mới với các giá trị mới

    // Cập nhật kích thước nếu khác
    if (this.size != size) {
      this.size = size;
    }

    // Cập nhật vị trí
    this.position = position;
    _initialPosition = position.clone();

    // Đặt lại màu mặc định
    _resetColor();

    // Đối với các thuộc tính final, chúng ta sẽ sử dụng getter/setter khác
    // hoặc xử lý riêng trong các phương thức
  }

  /// Đặt vị trí ban đầu
  set initialPosition(Vector2 position) {
    _initialPosition.setFrom(position);
  }

  /// Thay đổi màu nền của nút
  void _changeColor(Color color) {
    _colorNotifier.value = color;
  }

  /// Đặt lại màu mặc định
  void _resetColor() {
    _changeColor(_defaultColor);
  }

  /// Đặt màu đúng (xanh lá)
  void _setCorrectColor() {
    _changeColor(_correctColor);
  }

  /// Đặt màu sai (đỏ)
  void _setIncorrectColor() {
    _changeColor(_incorrectColor);
  }

  /// Đánh dấu là đúng (thay đổi màu thành xanh lá)
  void setCorrect() {
    _setCorrectColor();
  }

  /// Đánh dấu là sai (thay đổi màu thành đỏ)
  void setIncorrect() {
    _setIncorrectColor();
  }

  @override
  void onRemove() {
    _colorNotifier.dispose();
    super.onRemove();
  }
}

/// Component đại diện cho vùng drop
class DropZoneComponent extends PositionComponent {
  /// ID của zone
  final int id;

  /// Callback khi có nút được thả vào zone
  final Function(int zoneId)? onDropped;

  /// Constructor
  DropZoneComponent({
    required this.id,
    required Vector2 position,
    required Vector2 size,
    this.onDropped,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Thêm hình nền cho zone với viền bo tròn
    final roundedRectPainter = RoundedRectPainter(
      color: Colors.grey.withOpacity(0.15),
      borderRadius: 15.0,
    );

    add(CustomPainterComponent(
      painter: roundedRectPainter,
      position: Vector2.zero(),
      size: size,
    ));

    // Thêm border với viền bo tròn và nét đứt
    final borderPainter = RoundedRectBorderPainter(
      color: Colors.black.withOpacity(0.3),
      borderRadius: 15.0,
      strokeWidth: 2,
      dashWidth: 6.0,
      dashSpace: 4.0,
      isDashed: true,
    );

    add(CustomPainterComponent(
      painter: borderPainter,
      position: Vector2.zero(),
      size: size,
    ));
  }
}

/// Painter để vẽ hình chữ nhật bo góc
class RoundedRectPainter extends CustomPainter {
  Color color;
  final double borderRadius;
  final Listenable? listenable;

  RoundedRectPainter({
    required this.color,
    required this.borderRadius,
    Listenable? repaint,
  })  : listenable = repaint,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Nếu listenable là ValueNotifier<Color>, sử dụng giá trị đó cho màu sắc
    if (listenable is ValueNotifier<Color>) {
      color = (listenable as ValueNotifier<Color>).value;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(RoundedRectPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius;
  }
}

/// Painter để vẽ viền của hình chữ nhật bo góc
class RoundedRectBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;

  /// Độ dài của mỗi đoạn nét đứt
  final double dashWidth;

  /// Khoảng cách giữa các đoạn nét đứt
  final double dashSpace;

  /// Xác định có vẽ nét đứt hay không
  final bool isDashed;

  RoundedRectBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.isDashed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    if (!isDashed) {
      // Vẽ viền liền nếu không yêu cầu nét đứt
      canvas.drawRRect(rRect, paint);
      return;
    }

    // Tạo đường dẫn cho viền bo góc
    final path = Path()..addRRect(rRect);

    // Vẽ đường viền nét đứt
    final dashPath = Path();
    final pathMetrics = path.computeMetrics().toList();

    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        if (draw) {
          final extractPath =
              pathMetric.extractPath(distance, distance + length);
          dashPath.addPath(extractPath, Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(RoundedRectBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashWidth != oldDelegate.dashWidth ||
        dashSpace != oldDelegate.dashSpace ||
        isDashed != oldDelegate.isDashed;
  }
}
