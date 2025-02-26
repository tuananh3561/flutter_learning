import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart'; // Đảm bảo đã import flame/input.dart
import 'package:flutter/material.dart';

class WordDisplay extends PositionComponent with TapCallbacks {
  // Sửa thành TapCallbacks
  final List<String> words;
  final Function(String) onWordSelected;

  WordDisplay({
    required this.words,
    required this.onWordSelected,
    super.position,
    super.size,
    super.priority = 10,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    double yOffset = 0;
    for (final word in words) {
      final textComponent = TextComponent(
        text: word,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontFamily: 'YourFont',
          ),
        ),
        position: Vector2(0, yOffset),
        anchor: Anchor.topLeft,
      );
      add(textComponent);
      yOffset += 40;
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // Sửa thành TapDownEvent và thêm @override
    for (int i = 0; i < words.length; i++) {
      final textComponent = children.elementAt(i) as TextComponent;

      if (event.localPosition.y >= textComponent.position.y && //Sửa lại.
          event.localPosition.y <=
              textComponent.position.y + textComponent.height &&
          event.localPosition.x >= textComponent.position.x &&
          event.localPosition.x <=
              textComponent.position.x + textComponent.width) {
        onWordSelected(words[i]);
        return true;
      }
    }
    return false;
  }
}
