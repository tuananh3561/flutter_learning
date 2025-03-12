/// Asset Repository Interface - Định nghĩa các phương thức để quản lý assets
/// Interface này tuân theo mẫu Repository Pattern trong Clean Architecture

import 'dart:io';
import 'package:flutter_learning/data/models/asset_model.dart';

/// Interface định nghĩa các phương thức tương tác với assets
abstract class AssetRepository {
  /// Khởi tạo repository
  Future<void> initialize();

  /// Đóng repository khi không sử dụng
  Future<void> close();

  /// Lấy tất cả assets
  Future<List<AssetModel>> getAllAssets();

  /// Lấy asset theo loại
  Future<List<AssetModel>> getAssetsByType(AssetType type);

  /// Lấy asset theo ID
  Future<AssetModel?> getAssetById(String id);

  /// Xóa asset theo ID
  Future<void> deleteAsset(String id);

  /// Quét tất cả assets trong thư mục assets
  Future<List<AssetModel>> scanAllAssets();

  /// Upload spine asset từ local
  Future<AssetModel?> uploadSpineAsset(List<File> files, String targetDir,
      {String? customName});

  /// Upload audio asset từ local
  Future<AssetModel?> uploadAudioAsset(File file, String targetDir,
      {String? customName, bool isMusic = false});

  /// Upload image asset từ local
  Future<AssetModel?> uploadImageAsset(File file, String targetDir,
      {String? customName, Map<String, dynamic>? dimensions});
}
