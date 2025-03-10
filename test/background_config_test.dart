import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter_learning/data/models/game_config.dart';

void main() {
  group('BackgroundConfig', () {
    test('should parse from json correctly', () {
      // Arrange
      final json = {
        'background_color': '#FF0000',
        'background_image': {
          'image': 'test_image.png',
          'width': 800.0,
          'height': 600.0,
        },
        'decoration': [
          {
            'id': 'test_decoration',
            'type': 'image',
            'image': 'test_decoration.png',
            'width': 100.0,
            'height': 100.0,
            'position': {
              'x': 50.0,
              'y': 50.0,
            },
          },
          {
            'id': 'test_spine',
            'type': 'spine',
            'atlas': 'test_atlas.txt',
            'skeleton': 'test_skeleton.json',
            'scale': 0.5,
            'animation': 'idle',
            'click_animation': 'click',
            'skins': 'test_skin',
            'position': {
              'x': 100.0,
              'y': 100.0,
            },
          },
        ],
      };

      // Act
      final config = BackgroundConfig.fromJson(json);

      // Assert
      expect(config.backgroundColor, '#FF0000');
      expect(config.backgroundImage?.image, 'test_image.png');
      expect(config.backgroundImage?.width, 800.0);
      expect(config.backgroundImage?.height, 600.0);
      expect(config.decorations.length, 2);

      // Check first decoration (image type)
      final imageDecoration = config.decorations[0];
      expect(imageDecoration.id, 'test_decoration');
      expect(imageDecoration.type, 'image');
      expect(imageDecoration.image, 'test_decoration.png');
      expect(imageDecoration.width, 100.0);
      expect(imageDecoration.height, 100.0);
      expect(imageDecoration.position?.x, 50.0);
      expect(imageDecoration.position?.y, 50.0);

      // Check second decoration (spine type)
      final spineDecoration = config.decorations[1];
      expect(spineDecoration.id, 'test_spine');
      expect(spineDecoration.type, 'spine');
      expect(spineDecoration.atlas, 'test_atlas.txt');
      expect(spineDecoration.skeleton, 'test_skeleton.json');
      expect(spineDecoration.scale, 0.5);
      expect(spineDecoration.animation, 'idle');
      expect(spineDecoration.clickAnimation, 'click');
      expect(spineDecoration.skins, 'test_skin');
      expect(spineDecoration.position?.x, 100.0);
      expect(spineDecoration.position?.y, 100.0);
    });

    test('should convert backgroundColor to Color', () {
      // Arrange
      final config = BackgroundConfig(
        backgroundColor: '#FF0000',
        decorations: [],
      );

      // Act
      final color = config.backgroundColorValue;

      // Assert
      expect(color, equals(const Color(0xFFFF0000)));
    });

    test('should handle default values', () {
      // Arrange
      final json = {'decoration': []};

      // Act
      final config = BackgroundConfig.fromJson(json);

      // Assert
      expect(config.backgroundColor, '#000000');
      expect(config.backgroundImage, isNull);
      expect(config.decorations, isEmpty);
    });

    test('should convert configs to Vector2', () {
      // Arrange
      final bgImage = BackgroundImageConfig(
        image: 'test.png',
        width: 800.0,
        height: 600.0,
      );

      final position = PositionConfig(
        x: 100.0,
        y: 200.0,
      );

      final decoration = DecorationConfig(
        id: 'test',
        type: 'image',
        width: 50.0,
        height: 30.0,
      );

      // Act
      final bgImageSize = bgImage.size;
      final positionVector = position.vector;
      final decorationSize = decoration.size;

      // Assert
      expect(bgImageSize, equals(Vector2(800.0, 600.0)));
      expect(positionVector, equals(Vector2(100.0, 200.0)));
      expect(decorationSize, equals(Vector2(50.0, 30.0)));
    });
  });
}
