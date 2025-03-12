/// Asset Model - Định nghĩa cấu trúc dữ liệu cho các loại asset
/// Mô hình này được sử dụng để lưu trữ thông tin về các asset trong ứng dụng
/// bao gồm Spine animations, Audio và Images

import 'package:hive/hive.dart';

part 'asset_model.g.dart';

/// Enum định nghĩa các loại asset
enum AssetType { spine, audio, image }

/// Asset Model base class để lưu trữ trong Hive
@HiveType(typeId: 1)
class AssetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final Map<String, dynamic> metadata;

  @HiveField(5)
  final DateTime dateAdded;

  AssetModel({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.metadata,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  /// Factory method để tạo Spine Asset
  factory AssetModel.spine({
    required String id,
    required String name,
    required String skeletonPath,
    required String atlasPath,
    String defaultAnimation = 'Idle',
    Map<String, dynamic>? scale,
    Map<String, dynamic>? position,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: skeletonPath,
      type: AssetType.spine.toString(),
      metadata: {
        'skeleton': skeletonPath,
        'atlas': atlasPath,
        'animation': defaultAnimation,
        'scale': scale ?? {'x': 0.25, 'y': 0.25},
        'position': position ?? {'x': 0, 'y': 0},
      },
    );
  }

  /// Factory method để tạo Audio Asset
  factory AssetModel.audio({
    required String id,
    required String name,
    required String filePath,
    bool isMusic = false,
    double volume = 1.0,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: filePath,
      type: AssetType.audio.toString(),
      metadata: {
        'isMusic': isMusic,
        'volume': volume,
      },
    );
  }

  /// Factory method để tạo Image Asset
  factory AssetModel.image({
    required String id,
    required String name,
    required String filePath,
    Map<String, dynamic>? dimensions,
    bool isSvg = false,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: filePath,
      type: AssetType.image.toString(),
      metadata: {
        'dimensions': dimensions,
        'isSvg': isSvg,
      },
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'metadata': metadata,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  /// Create from JSON
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      type: json['type'],
      metadata: json['metadata'],
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }
}
