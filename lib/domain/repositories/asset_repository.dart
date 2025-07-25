/// Asset Repository Interface - Định nghĩa các phương thức để quản lý assets
/// Interface này tuân theo mẫu Repository Pattern trong Clean Architecture

import 'dart:io';
import 'dart:typed_data';
import '../../data/models/asset_model.dart';

/// Interface định nghĩa các phương thức tương tác với assets
abstract class AssetRepository {
  /// Khởi tạo repository
  Future<void> init();

  /// Đóng repository khi không sử dụng
  Future<void> close();

  /// Lấy tất cả assets
  Future<List<AssetModel>> getAllAssets();

  /// Lấy asset theo loại
  Future<List<AssetModel>> getAssetsByType(AssetType type);

  /// Lấy asset theo ID
  Future<AssetModel?> getAssetById(String id);

  /// Xóa asset theo ID
  Future<bool> deleteAsset(String id);

  /// Quét tất cả assets từ server
  Future<List<AssetModel>> scanAllAssets();

  /// Upload spine asset lên server từ files
  Future<AssetModel?> uploadSpineAsset(List<File> files, {String? customName});

  /// Upload spine asset lên server từ bytes (cho web)
  Future<AssetModel?> uploadSpineAssetWeb(Map<String, Uint8List> files,
      {String? customName});

  /// Upload audio asset lên server từ file
  Future<AssetModel?> uploadAudioAsset(File file,
      {String? customName, bool isMusic = false});

  /// Upload audio asset lên server từ bytes (cho web)
  Future<AssetModel?> uploadAudioAssetWeb(Uint8List bytes, String fileName,
      {String? customName, bool isMusic = false});

  /// Upload image asset lên server từ file
  Future<AssetModel?> uploadImageAsset(File file,
      {String? customName, Map<String, dynamic>? dimensions});

  /// Upload image asset lên server từ bytes (cho web)
  Future<AssetModel?> uploadImageAssetWeb(Uint8List bytes, String fileName,
      {String? customName, Map<String, dynamic>? dimensions});
}
