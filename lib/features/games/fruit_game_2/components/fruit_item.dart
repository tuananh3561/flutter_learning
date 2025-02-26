// File: lib/game/components/fruit_item.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../models/fruit.dart';

class FruitItem extends SpriteComponent with TapCallbacks {
  final Fruit fruit;
  final Function() onTap;

  FruitItem({
    required this.fruit,
    required super.position,
    required super.size,
    required this.onTap,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(fruit.imagePath);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onTap();
    return true;
  }
}
