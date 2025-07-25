/// Asset Local DataSource - Quản lý lưu trữ và truy xuất thông tin asset từ local storage
/// Sử dụng Hive để lưu trữ dữ liệu asset và MediaApiService để tương tác với server

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import '../../../data/models/asset_model.dart';
import '../../../core/network/media_api_service.dart';
import 'package:http/http.dart' as http;

/// Class quản lý lưu trữ asset trên local storage và tương tác với server
class AssetLocalDataSource {
  static const String _assetBoxName = 'asset_box';
  static const String _spineFolder = 'Test/spine';
  static const String _audioFolder = 'Test/audio';
  static const String _imageFolder = 'Test/image';

  late Box<AssetModel> _assetBox;
  bool _isInitialized = false;

  final MediaApiService _apiService;

  AssetLocalDataSource(this._apiService);

  /// Khởi tạo Hive và mở box để lưu trữ
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    // Đăng ký adapter cho AssetModel - implementation needed
    Hive.registerAdapter(AssetModelAdapter());

    _assetBox = await Hive.openBox<AssetModel>(_assetBoxName);
    _isInitialized = true;
  }

  /// Đóng Hive box khi không sử dụng
  Future<void> close() async {
    if (_isInitialized) {
      await _assetBox.close();
      _isInitialized = false;
    }
  }

  /// Thêm một asset mới vào database
  Future<void> addAsset(AssetModel asset) async {
    await _assetBox.put(asset.id, asset);
  }

  /// Cập nhật asset
  Future<void> updateAsset(AssetModel asset) async {
    await _assetBox.put(asset.id, asset);
  }

  /// Xóa asset
  Future<void> deleteAsset(String id) async {
    await _assetBox.delete(id);
  }

  /// Lấy asset theo ID
  AssetModel? getAssetById(String id) {
    return _assetBox.get(id);
  }

  /// Lấy tất cả assets
  List<AssetModel> getAllAssets() {
    return _assetBox.values.toList();
  }

  /// Lấy assets theo loại
  List<AssetModel> getAssetsByType(AssetType type) {
    return _assetBox.values
        .where((asset) => asset.type == type.toString())
        .toList();
  }

  /// Tạo ID duy nhất cho asset dựa vào đường dẫn và nội dung
  String _generateAssetId(String assetPath, String assetName) {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final input = '$assetPath-$assetName-$now';
    return md5.convert(utf8.encode(input)).toString();
  }

  /// Quét tất cả assets từ server để cập nhật danh sách
  Future<List<AssetModel>> scanAllAssets() async {
    List<AssetModel> discoveredAssets = [];

    print("Bắt đầu quét assets từ server...");

    // Quét thư mục Spine
    print("Đang quét thư mục Spine: $_spineFolder");
    final spineFiles =
        await _apiService.getFilesAndFolders(folderPath: _spineFolder);
    print("Tìm thấy ${spineFiles.length} file Spine");
    for (var file in spineFiles) {
      final asset = AssetModel.fromMediaFileInfo(file);
      discoveredAssets.add(asset);
      await addAsset(asset);
    }

    // Quét thư mục Audio
    print("Đang quét thư mục Audio: $_audioFolder");
    final audioFiles =
        await _apiService.getFilesAndFolders(folderPath: _audioFolder);
    print("Tìm thấy ${audioFiles.length} file Audio");
    for (var file in audioFiles) {
      print(
          "Processing audio file: ${file.name}, ID: ${file.id}, Type: ${file.type}, URL: ${file.url}");
      try {
        final asset = AssetModel.fromMediaFileInfo(file);
        discoveredAssets.add(asset);
        await addAsset(asset);
        print("  -> Added audio asset: ${asset.name}, ID: ${asset.id}");
      } catch (e) {
        print("  -> Error processing audio file ${file.name}: $e");
      }
    }

    // Quét thư mục Image
    print("Đang quét thư mục Image: $_imageFolder");
    final imageFiles =
        await _apiService.getFilesAndFolders(folderPath: _imageFolder);
    print("Tìm thấy ${imageFiles.length} file Image");
    for (var file in imageFiles) {
      final asset = AssetModel.fromMediaFileInfo(file);
      discoveredAssets.add(asset);
      await addAsset(asset);
    }

    print("Quét assets hoàn tất, tổng cộng ${discoveredAssets.length} assets");
    return discoveredAssets;
  }

  /// Upload Spine files lên server
  Future<AssetModel?> uploadSpineAsset(List<File> files,
      {String? customName}) async {
    try {
      // Xác định tên cho thư mục Spine dựa vào file skeleton.json
      String spineFolderName = customName ?? 'unknown_spine';

      final jsonFile = files.firstWhere(
        (file) => path.basename(file.path).toLowerCase().endsWith('.json'),
        orElse: () => files.first,
      );

      if (path.basename(jsonFile.path).toLowerCase() == 'skeleton.json' &&
          customName == null) {
        // Nếu là skeleton.json, lấy tên thư mục cha
        final directory = path.dirname(jsonFile.path);
        spineFolderName = path.basename(directory);
      } else if (customName == null) {
        // Nếu không phải skeleton.json và không có custom name,
        // dùng tên file không có extension
        spineFolderName =
            path.basenameWithoutExtension(path.basename(jsonFile.path));
      }

      String skeletonPath = '';
      String atlasPath = '';

      // Upload từng file lên server
      for (var file in files) {
        final fileName = path.basename(file.path);
        final targetFolder = '$_spineFolder/$spineFolderName';

        final result = await _apiService.uploadFile(
          file: file,
          folderPath: targetFolder,
          description: 'Spine asset: $fileName',
        );

        if (!result.success) {
          throw Exception(
              'Upload failed for file $fileName: ${result.message}');
        }

        // Lưu đường dẫn của file skeleton và atlas
        if (fileName.toLowerCase().endsWith('.json')) {
          skeletonPath = result.url!;
        } else if (fileName.toLowerCase().endsWith('.atlas') ||
            fileName.toLowerCase().endsWith('.atlas.txt')) {
          atlasPath = result.url!;
        }
      }

      if (skeletonPath.isEmpty) {
        throw Exception('No skeleton file was uploaded');
      }

      // Tạo asset model cho spine
      final assetId = _generateAssetId(_spineFolder, spineFolderName);
      final assetUrl = skeletonPath; // Sử dụng skeleton path làm URL chính

      final spineAsset = AssetModel.spine(
        id: assetId,
        name: spineFolderName,
        url: assetUrl,
        skeletonPath: skeletonPath,
        atlasPath: atlasPath,
        folderPath: '$_spineFolder/$spineFolderName',
        bucket: 'monkeymedia2020',
      );

      // Lưu vào database
      await addAsset(spineAsset);

      return spineAsset;
    } catch (e) {
      print('Error uploading spine asset: $e');
      return null;
    }
  }

  /// Upload audio file lên server
  Future<AssetModel?> uploadAudioAsset(File file,
      {String? customName, bool isMusic = false}) async {
    try {
      // Lấy tên file và đuôi
      final fileName = path.basename(file.path);
      final fileExt = path.extension(file.path);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Định danh theo quy tắc
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetFileName = isMusic ? sanitizedName : 'SFX_$sanitizedName';
      final targetName = '$targetFileName$fileExt';

      // Upload file lên server
      final result = await _apiService.uploadFile(
        file: file,
        folderPath: _audioFolder,
        description: isMusic ? 'Background music' : 'Sound effect',
      );

      if (!result.success) {
        throw Exception('Upload failed: ${result.message}');
      }

      // Tạo ID duy nhất cho asset
      final audioId = _generateAssetId(_audioFolder, targetName);

      // Tạo asset model cho audio
      final audioAsset = AssetModel.audio(
        id: audioId,
        name: displayName,
        url: result.url!,
        filePath: '$_audioFolder/$targetName',
        folderPath: _audioFolder,
        bucket: 'monkeymedia2020',
        isMusic: isMusic,
      );

      // Lưu vào database
      await addAsset(audioAsset);

      return audioAsset;
    } catch (e) {
      print('Error uploading audio asset: $e');
      return null;
    }
  }

  /// Upload image file lên server
  Future<AssetModel?> uploadImageAsset(File file,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    try {
      // Lấy tên file và đuôi
      final fileName = path.basename(file.path);
      final fileExt = path.extension(file.path);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Định danh theo quy tắc
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetName = '$sanitizedName$fileExt';

      // Kiểm tra có phải SVG không
      final isSvg = fileExt.toLowerCase() == '.svg';

      // Upload file lên server
      final result = await _apiService.uploadFile(
        file: file,
        folderPath: _imageFolder,
        description: isSvg ? 'Vector image' : 'Raster image',
      );

      if (!result.success) {
        throw Exception('Upload failed: ${result.message}');
      }

      // Tạo ID duy nhất cho asset
      final imageId = _generateAssetId(_imageFolder, targetName);

      // Tạo asset model cho image
      final imageAsset = AssetModel.image(
        id: imageId,
        name: displayName,
        url: result.url!,
        filePath: '$_imageFolder/$targetName',
        folderPath: _imageFolder,
        bucket: 'monkeymedia2020',
        dimensions: dimensions,
        isSvg: isSvg,
      );

      // Lưu vào database
      await addAsset(imageAsset);

      return imageAsset;
    } catch (e) {
      print('Error uploading image asset: $e');
      return null;
    }
  }

  /// Upload spine asset lên server từ bytes (cho web)
  Future<AssetModel?> uploadSpineAssetWeb(Map<String, Uint8List> files,
      {String? customName}) async {
    try {
      if (files.isEmpty) {
        throw Exception('Không có file nào được cung cấp');
      }

      // Xác định tên cho thư mục Spine dựa vào file skeleton.json
      String spineFolderName = customName ?? 'unknown_spine';

      // Tìm file JSON
      final jsonFileName = files.keys.firstWhere(
        (key) => key.toLowerCase().endsWith('.json'),
        orElse: () => files.keys.first,
      );

      if (jsonFileName.toLowerCase() == 'skeleton.json' && customName == null) {
        // Nếu là skeleton.json và không có custom name,
        // dùng tên thư mục mặc định
        spineFolderName = 'spine_animation';
      } else if (customName == null) {
        // Nếu không phải skeleton.json và không có custom name,
        // dùng tên file không có extension
        spineFolderName = path.basenameWithoutExtension(jsonFileName);
      }

      String skeletonPath = '';
      String atlasPath = '';

      // Upload từng file lên server
      for (var entry in files.entries) {
        final fileName = entry.key;
        final fileBytes = entry.value;
        final targetFolder = '$_spineFolder/$spineFolderName';

        // Sử dụng API để upload file bytes
        final result = await _uploadFileBytes(
          bytes: fileBytes,
          fileName: fileName,
          folderPath: targetFolder,
          description: 'Spine asset: $fileName',
        );

        if (!result.success) {
          throw Exception(
              'Upload failed for file $fileName: ${result.message}');
        }

        // Lưu đường dẫn của file skeleton và atlas
        if (fileName.toLowerCase().endsWith('.json')) {
          skeletonPath = result.url!;
        } else if (fileName.toLowerCase().endsWith('.atlas') ||
            fileName.toLowerCase().endsWith('.atlas.txt')) {
          atlasPath = result.url!;
        }
      }

      if (skeletonPath.isEmpty) {
        throw Exception('No skeleton file was uploaded');
      }

      // Tạo asset model cho spine
      final assetId = _generateAssetId(_spineFolder, spineFolderName);
      final assetUrl = skeletonPath; // Sử dụng skeleton path làm URL chính

      final spineAsset = AssetModel.spine(
        id: assetId,
        name: spineFolderName,
        url: assetUrl,
        skeletonPath: skeletonPath,
        atlasPath: atlasPath,
        folderPath: '$_spineFolder/$spineFolderName',
        bucket: 'monkeymedia2020',
      );

      // Lưu vào database
      await addAsset(spineAsset);

      return spineAsset;
    } catch (e) {
      print('Error uploading spine asset from web: $e');
      return null;
    }
  }

  /// Upload audio file lên server từ bytes (cho web)
  Future<AssetModel?> uploadAudioAssetWeb(Uint8List bytes, String fileName,
      {String? customName, bool isMusic = false}) async {
    try {
      // Lấy đuôi file
      final fileExt = path.extension(fileName);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Định danh theo quy tắc
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetFileName = isMusic ? sanitizedName : 'SFX_$sanitizedName';
      final targetName = '$targetFileName$fileExt';

      // Upload file lên server
      final result = await _uploadFileBytes(
        bytes: bytes,
        fileName: targetName,
        folderPath: _audioFolder,
        description: isMusic ? 'Background music' : 'Sound effect',
      );

      if (!result.success) {
        throw Exception('Upload failed: ${result.message}');
      }

      // Tạo ID duy nhất cho asset
      final audioId = _generateAssetId(_audioFolder, targetName);

      // Tạo asset model cho audio
      final audioAsset = AssetModel.audio(
        id: audioId,
        name: displayName,
        url: result.url!,
        filePath: '$_audioFolder/$targetName',
        folderPath: _audioFolder,
        bucket: 'monkeymedia2020',
        isMusic: isMusic,
      );

      // Lưu vào database
      await addAsset(audioAsset);

      return audioAsset;
    } catch (e) {
      print('Error uploading audio asset from web: $e');
      return null;
    }
  }

  /// Upload image file lên server từ bytes (cho web)
  Future<AssetModel?> uploadImageAssetWeb(Uint8List bytes, String fileName,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    try {
      // Lấy đuôi file
      final fileExt = path.extension(fileName);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Định danh theo quy tắc
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetName = '$sanitizedName$fileExt';

      // Kiểm tra có phải SVG không
      final isSvg = fileExt.toLowerCase() == '.svg';

      // Upload file lên server
      final result = await _uploadFileBytes(
        bytes: bytes,
        fileName: targetName,
        folderPath: _imageFolder,
        description: isSvg ? 'Vector image' : 'Raster image',
      );

      if (!result.success) {
        throw Exception('Upload failed: ${result.message}');
      }

      // Tạo ID duy nhất cho asset
      final imageId = _generateAssetId(_imageFolder, targetName);

      // Tạo asset model cho image
      final imageAsset = AssetModel.image(
        id: imageId,
        name: displayName,
        url: result.url!,
        filePath: '$_imageFolder/$targetName',
        folderPath: _imageFolder,
        bucket: 'monkeymedia2020',
        dimensions: dimensions,
        isSvg: isSvg,
      );

      // Lưu vào database
      await addAsset(imageAsset);

      return imageAsset;
    } catch (e) {
      print('Error uploading image asset from web: $e');
      return null;
    }
  }

  /// Upload file bytes lên server (hỗ trợ cho web)
  Future<UploadResult> _uploadFileBytes({
    required Uint8List bytes,
    required String fileName,
    required String folderPath,
    String? description,
  }) async {
    try {
      // Sử dụng phương thức upload của MediaApiService
      if (kIsWeb) {
        // Trên web, sử dụng uploadBytes trực tiếp
        return await _apiService.uploadBytes(
          bytes: bytes,
          fileName: fileName,
          folderPath: folderPath,
          description: description,
        );
      } else {
        // Tạo file tạm trên mobile/desktop
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(bytes);

        // Sử dụng phương thức upload thông thường
        return await _apiService.uploadFile(
          file: tempFile,
          folderPath: folderPath,
          description: description,
        );
      }
    } catch (e) {
      return UploadResult(
        success: false,
        message: 'Exception: $e',
      );
    }
  }
}
