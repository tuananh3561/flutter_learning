import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Mô hình cho cấu hình background và decorations
class BackgroundConfig {
  final String backgroundColor;
  final BackgroundImageConfig? backgroundImage;
  final List<DecorationConfig> decorations;

  BackgroundConfig({
    required this.backgroundColor,
    this.backgroundImage,
    required this.decorations,
  });

  /// Parse từ Map JSON
  factory BackgroundConfig.fromJson(Map<String, dynamic> json) {
    return BackgroundConfig(
      backgroundColor: json['background_color'] ?? '#000000',
      backgroundImage: json['background_image'] != null
          ? BackgroundImageConfig.fromJson(json['background_image'])
          : null,
      decorations: (json['decoration'] as List<dynamic>?)
              ?.map((item) => DecorationConfig.fromJson(item))
              .toList() ??
          [],
    );
  }

  /// Parse từ chuỗi JSON
  factory BackgroundConfig.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return BackgroundConfig.fromJson(json);
  }

  /// Convert backgroundColor từ hex string sang Color
  Color get backgroundColorValue {
    final hexColor = backgroundColor.replaceFirst('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}

/// Mô hình cho cấu hình background image
class BackgroundImageConfig {
  final String image;
  final double width;
  final double height;

  BackgroundImageConfig({
    required this.image,
    required this.width,
    required this.height,
  });

  /// Parse từ Map JSON
  factory BackgroundImageConfig.fromJson(Map<String, dynamic> json) {
    return BackgroundImageConfig(
      image: json['image'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }

  /// Chuyển đổi sang kích thước Vector2
  Vector2 get size => Vector2(width, height);
}

/// Mô hình cho cấu hình decoration
class DecorationConfig {
  final String id;
  final String type; // "image" hoặc "spine"

  // Thuộc tính chung
  final double? width;
  final double? height;
  final PositionConfig? position;

  // Thuộc tính cho image
  final String? image;

  // Thuộc tính cho spine
  final String? atlas;
  final String? skeleton;
  final double? scale;
  final String? animation;
  final String? clickAnimation;
  final String? skins;

  DecorationConfig({
    required this.id,
    required this.type,
    this.width,
    this.height,
    this.position,
    this.image,
    this.atlas,
    this.skeleton,
    this.scale,
    this.animation,
    this.clickAnimation,
    this.skins,
  });

  /// Parse từ Map JSON
  factory DecorationConfig.fromJson(Map<String, dynamic> json) {
    return DecorationConfig(
      id: json['id'] as String,
      type: json['type'] as String,
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      position: json['position'] != null
          ? PositionConfig.fromJson(json['position'])
          : null,
      image: json['image'] as String?,
      atlas: json['atlas'] as String?,
      skeleton: json['skeleton'] as String?,
      scale: json['scale'] != null ? (json['scale'] as num).toDouble() : null,
      animation: json['animation'] as String?,
      clickAnimation: json['click_animation'] as String?,
      skins: json['skins'] as String?,
    );
  }

  /// Chuyển đổi sang kích thước Vector2
  Vector2? get size =>
      (width != null && height != null) ? Vector2(width!, height!) : null;
}

/// Mô hình cho cấu hình vị trí
class PositionConfig {
  final double x;
  final double y;

  PositionConfig({
    required this.x,
    required this.y,
  });

  /// Parse từ Map JSON
  factory PositionConfig.fromJson(Map<String, dynamic> json) {
    return PositionConfig(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  /// Chuyển đổi sang Vector2
  Vector2 get vector => Vector2(x, y);
}
