/// Asset Repository Implementation
/// Triển khai repository cho asset management, sử dụng AssetLocalDataSource

import 'dart:io';
import 'dart:typed_data';
import '../datasources/local/asset_local_datasource.dart';
import '../../domain/repositories/asset_repository.dart';
import '../models/asset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource _localDataSource;

  AssetRepositoryImpl(this._localDataSource);

  @override
  Future<void> init() async {
    await _localDataSource.init();
  }

  @override
  Future<void> close() async {
    await _localDataSource.close();
  }

  @override
  Future<List<AssetModel>> getAllAssets() async {
    return _localDataSource.getAllAssets();
  }

  @override
  Future<List<AssetModel>> getAssetsByType(AssetType type) async {
    return _localDataSource.getAssetsByType(type);
  }

  @override
  Future<AssetModel?> getAssetById(String id) async {
    return _localDataSource.getAssetById(id);
  }

  @override
  Future<AssetModel?> uploadSpineAsset(List<File> files,
      {String? customName}) async {
    return _localDataSource.uploadSpineAsset(files, customName: customName);
  }

  @override
  Future<AssetModel?> uploadSpineAssetWeb(Map<String, Uint8List> files,
      {String? customName}) async {
    return _localDataSource.uploadSpineAssetWeb(files, customName: customName);
  }

  @override
  Future<AssetModel?> uploadAudioAsset(File file,
      {String? customName, bool isMusic = false}) async {
    return _localDataSource.uploadAudioAsset(file,
        customName: customName, isMusic: isMusic);
  }

  @override
  Future<AssetModel?> uploadAudioAssetWeb(Uint8List bytes, String fileName,
      {String? customName, bool isMusic = false}) async {
    return _localDataSource.uploadAudioAssetWeb(bytes, fileName,
        customName: customName, isMusic: isMusic);
  }

  @override
  Future<AssetModel?> uploadImageAsset(File file,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    return _localDataSource.uploadImageAsset(file,
        customName: customName, dimensions: dimensions);
  }

  @override
  Future<AssetModel?> uploadImageAssetWeb(Uint8List bytes, String fileName,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    return _localDataSource.uploadImageAssetWeb(bytes, fileName,
        customName: customName, dimensions: dimensions);
  }

  @override
  Future<bool> deleteAsset(String id) async {
    try {
      await _localDataSource.deleteAsset(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<AssetModel>> scanAllAssets() async {
    return _localDataSource.scanAllAssets();
  }
}
