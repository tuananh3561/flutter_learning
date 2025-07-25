/// Asset Model - Định nghĩa cấu trúc dữ liệu cho các loại asset
/// Mô hình này được sử dụng để lưu trữ thông tin về các asset trong ứng dụng
/// bao gồm Spine animations, Audio và Images

import 'package:hive/hive.dart';
import '../../core/network/media_api_service.dart';

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
  final String url;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final Map<String, dynamic> metadata;

  @HiveField(6)
  final DateTime dateAdded;

  @HiveField(7)
  final String folderPath;

  @HiveField(8)
  final String bucket;

  AssetModel({
    required this.id,
    required this.name,
    required this.path,
    required this.url,
    required this.type,
    required this.metadata,
    required this.folderPath,
    required this.bucket,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  /// Factory method để tạo Spine Asset
  factory AssetModel.spine({
    required String id,
    required String name,
    required String url,
    required String skeletonPath,
    required String atlasPath,
    required String folderPath,
    required String bucket,
    String defaultAnimation = 'Idle',
    Map<String, dynamic>? scale,
    Map<String, dynamic>? position,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: skeletonPath,
      url: url,
      folderPath: folderPath,
      bucket: bucket,
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
    required String url,
    required String filePath,
    required String folderPath,
    required String bucket,
    bool isMusic = false,
    double volume = 1.0,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: filePath,
      url: url,
      folderPath: folderPath,
      bucket: bucket,
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
    required String url,
    required String filePath,
    required String folderPath,
    required String bucket,
    Map<String, dynamic>? dimensions,
    bool isSvg = false,
  }) {
    return AssetModel(
      id: id,
      name: name,
      path: filePath,
      url: url,
      folderPath: folderPath,
      bucket: bucket,
      type: AssetType.image.toString(),
      metadata: {
        'dimensions': dimensions,
        'isSvg': isSvg,
      },
    );
  }

  /// Factory method từ MediaFileInfo
  factory AssetModel.fromMediaFileInfo(MediaFileInfo fileInfo) {
    // Xác định loại asset dựa vào đường dẫn folder hoặc file extension
    AssetType assetType;
    final lowerPath = fileInfo.folderPath.toLowerCase();

    if (lowerPath.contains('/spine')) {
      assetType = AssetType.spine;
    } else if (lowerPath.contains('/audio')) {
      assetType = AssetType.audio;
    } else if (lowerPath.contains('/image')) {
      assetType = AssetType.image;
    } else {
      // Xác định theo extension
      final ext = fileInfo.name.split('.').last.toLowerCase();
      if (['json', 'atlas', 'txt'].contains(ext)) {
        assetType = AssetType.spine;
      } else if (['mp3', 'wav', 'ogg'].contains(ext)) {
        assetType = AssetType.audio;
      } else {
        assetType = AssetType.image;
      }
    }

    // Tạo metadata dựa vào loại asset
    Map<String, dynamic> metadata = {};
    switch (assetType) {
      case AssetType.spine:
        final isJson = fileInfo.name.toLowerCase().endsWith('.json');
        final skeletonPath = isJson ? fileInfo.url : '';
        final atlasPath = !isJson ? fileInfo.url : '';

        metadata = {
          'skeleton': skeletonPath,
          'atlas': atlasPath,
          'animation': 'Idle',
          'scale': {'x': 0.25, 'y': 0.25},
          'position': {'x': 0, 'y': 0},
        };
        break;

      case AssetType.audio:
        final isMusic = !fileInfo.name.startsWith('SFX_');
        metadata = {
          'isMusic': isMusic,
          'volume': 1.0,
        };
        break;

      case AssetType.image:
        final isSvg = fileInfo.name.toLowerCase().endsWith('.svg');
        metadata = {
          'dimensions': {'width': 0, 'height': 0},
          'isSvg': isSvg,
        };
        break;
    }

    return AssetModel(
      id: fileInfo.id,
      name: fileInfo.name,
      path: fileInfo.folderPath + '/' + fileInfo.name,
      url: fileInfo.url,
      type: assetType.toString(),
      metadata: metadata,
      dateAdded: fileInfo.createdAt,
      folderPath: fileInfo.folderPath,
      bucket: fileInfo.bucket,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'url': url,
      'type': type,
      'metadata': metadata,
      'dateAdded': dateAdded.toIso8601String(),
      'folderPath': folderPath,
      'bucket': bucket,
    };
  }

  /// Create from JSON
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      url: json['url'] ?? '',
      type: json['type'],
      metadata: json['metadata'],
      dateAdded: DateTime.parse(json['dateAdded']),
      folderPath: json['folderPath'] ?? '',
      bucket: json['bucket'] ?? '',
    );
  }
}
