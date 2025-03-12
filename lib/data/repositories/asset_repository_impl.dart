/// Asset Repository Implementation - Thực thi interface repository cho Asset
/// Cung cấp các phương thức để thao tác với assets

import 'dart:io';
import 'package:flutter_learning/data/datasources/local/asset_local_datasource.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flutter_learning/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource _localDataSource;

  AssetRepositoryImpl(this._localDataSource);

  @override
  Future<void> initialize() async {
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
  Future<void> deleteAsset(String id) async {
    await _localDataSource.deleteAsset(id);
  }

  @override
  Future<List<AssetModel>> scanAllAssets() async {
    return await _localDataSource.scanAllAssets();
  }

  @override
  Future<AssetModel?> uploadSpineAsset(List<File> files, String targetDir,
      {String? customName}) async {
    return await _localDataSource.uploadSpineAsset(files, targetDir,
        customName: customName);
  }

  @override
  Future<AssetModel?> uploadAudioAsset(File file, String targetDir,
      {String? customName, bool isMusic = false}) async {
    return await _localDataSource.uploadAudioAsset(
      file,
      targetDir,
      customName: customName,
      isMusic: isMusic,
    );
  }

  @override
  Future<AssetModel?> uploadImageAsset(File file, String targetDir,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    return await _localDataSource.uploadImageAsset(
      file,
      targetDir,
      customName: customName,
      dimensions: dimensions,
    );
  }
}
