/// Asset Local DataSource - Quản lý lưu trữ và truy xuất thông tin asset từ local storage
/// Sử dụng Hive để lưu trữ dữ liệu asset

import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import '../../../data/models/asset_model.dart';

/// Class quản lý lưu trữ asset trên local storage
class AssetLocalDataSource {
  static const String _assetBoxName = 'asset_box';
  static const String _spineDir = 'assets/Spine/';
  static const String _audioDir = 'assets/Audio/';
  static const String _imageDir = 'assets/Images/';

  late Box<AssetModel> _assetBox;
  bool _isInitialized = false;

  /// Khởi tạo Hive và mở box để lưu trữ
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
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

  /// Scan tất cả asset trong assets folder để lập catalog
  Future<List<AssetModel>> scanAllAssets() async {
    List<AssetModel> discoveredAssets = [];

    // Scan spine animations
    discoveredAssets.addAll(await _scanSpineAssets());

    // Scan audio files
    discoveredAssets.addAll(await _scanAudioAssets());

    // Scan image files
    discoveredAssets.addAll(await _scanImageAssets());

    // Lưu vào database
    for (var asset in discoveredAssets) {
      await addAsset(asset);
    }

    return discoveredAssets;
  }

  /// Scan tất cả Spine animations từ thư mục assets
  Future<List<AssetModel>> _scanSpineAssets() async {
    List<AssetModel> spineAssets = [];

    try {
      // Quét tất cả thư mục trong thư mục Spine
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Tìm các file skeleton.json
      final spineJsonFiles = manifestMap.keys
          .where((String key) =>
              key.startsWith(_spineDir) && key.endsWith('skeleton.json'))
          .toList();

      for (var skeletonPath in spineJsonFiles) {
        // Parse để lấy thông tin
        final folderPath = path.dirname(skeletonPath);
        final folderName = path.basename(folderPath);
        final atlasPath = '$folderPath/skeleton_hdr.atlas.txt';

        // Tạo asset model cho spine
        final spineId = folderName.replaceAll(' ', '_').toLowerCase();

        spineAssets.add(AssetModel.spine(
          id: spineId,
          name: folderName,
          skeletonPath: skeletonPath,
          atlasPath: atlasPath,
        ));
      }
    } catch (e) {
      print('Error scanning spine assets: $e');
    }

    return spineAssets;
  }

  /// Scan tất cả audio files từ thư mục assets
  Future<List<AssetModel>> _scanAudioAssets() async {
    List<AssetModel> audioAssets = [];

    try {
      // Quét tất cả file audio trong thư mục Audio
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Các định dạng audio hỗ trợ
      final audioExtensions = ['.mp3', '.wav', '.ogg'];

      // Tìm các file audio
      final audioFiles = manifestMap.keys
          .where((String key) =>
              key.startsWith(_audioDir) &&
              audioExtensions.any((ext) => key.toLowerCase().endsWith(ext)))
          .toList();

      for (var audioPath in audioFiles) {
        // Parse để lấy thông tin
        final fileName = path.basename(audioPath);
        final fileNameWithoutExt = path.basenameWithoutExtension(fileName);
        final isMusic = !fileName.startsWith('SFX');

        // Tạo asset model cho audio
        final audioId =
            'audio_${fileNameWithoutExt.replaceAll(' ', '_').toLowerCase()}';

        audioAssets.add(AssetModel.audio(
          id: audioId,
          name: fileNameWithoutExt,
          filePath: audioPath,
          isMusic: isMusic,
        ));
      }
    } catch (e) {
      print('Error scanning audio assets: $e');
    }

    return audioAssets;
  }

  /// Scan tất cả image files từ thư mục assets
  Future<List<AssetModel>> _scanImageAssets() async {
    List<AssetModel> imageAssets = [];

    try {
      // Quét tất cả file image trong thư mục Images
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Các định dạng image hỗ trợ
      final imageExtensions = ['.png', '.jpg', '.jpeg', '.svg', '.webp'];

      // Tìm các file image
      final imageFiles = manifestMap.keys
          .where((String key) =>
              key.startsWith(_imageDir) &&
              imageExtensions.any((ext) => key.toLowerCase().endsWith(ext)))
          .toList();

      for (var imagePath in imageFiles) {
        // Parse để lấy thông tin
        final fileName = path.basename(imagePath);
        final fileNameWithoutExt = path.basenameWithoutExtension(fileName);
        final isSvg = imagePath.toLowerCase().endsWith('.svg');

        // Tạo asset model cho image
        final imageId =
            'image_${fileNameWithoutExt.replaceAll(' ', '_').toLowerCase()}';

        imageAssets.add(AssetModel.image(
          id: imageId,
          name: fileNameWithoutExt,
          filePath: imagePath,
          isSvg: isSvg,
        ));
      }
    } catch (e) {
      print('Error scanning image assets: $e');
    }

    return imageAssets;
  }

  /// Upload file Spine từ local vào assets
  Future<AssetModel?> uploadSpineAsset(List<File> files, String targetDir,
      {String? customName}) async {
    try {
      // Xác định thư mục Spine dựa vào file skeleton.json
      String spineFolderName = customName ?? 'unknown_spine';

      final jsonFile = files.firstWhere(
        (file) => path.basename(file.path).toLowerCase().endsWith('.json'),
        orElse: () => files.first,
      );

      if (path.basename(jsonFile.path).toLowerCase() == 'skeleton.json') {
        // Nếu là skeleton.json, lấy tên thư mục cha
        final directory = path.dirname(jsonFile.path);
        spineFolderName = customName ?? path.basename(directory);
      } else if (customName == null) {
        // Nếu không phải skeleton.json và không có custom name,
        // dùng tên file không có extension
        spineFolderName =
            path.basenameWithoutExtension(path.basename(jsonFile.path));
      }

      // Đường dẫn đích trong assets
      final spineDir = '$targetDir${spineFolderName.replaceAll(' ', '_')}/';

      // TODO: Copy các file vào assets folder
      // Trong thực tế, cần implement cơ chế copy file vào assets
      // Đây là giả lập thành công

      // Tạo ID duy nhất cho asset
      final spineId =
          'spine_${spineFolderName.replaceAll(' ', '_').toLowerCase()}';

      // Tạo đường dẫn giả định
      final skeletonPath = '$spineDir/skeleton.json';
      final atlasPath = '$spineDir/skeleton_hdr.atlas.txt';

      // Tạo asset model cho spine
      final spineAsset = AssetModel.spine(
        id: spineId,
        name: spineFolderName,
        skeletonPath: skeletonPath,
        atlasPath: atlasPath,
      );

      // Lưu vào database
      await addAsset(spineAsset);

      return spineAsset;
    } catch (e) {
      print('Error uploading spine asset: $e');
      return null;
    }
  }

  /// Upload file audio từ local vào assets
  Future<AssetModel?> uploadAudioAsset(File file, String targetDir,
      {String? customName, bool isMusic = false}) async {
    try {
      // Lấy tên file và đuôi
      final fileName = path.basename(file.path);
      final fileExt = path.extension(file.path);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Đường dẫn đích trong assets
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetFileName = isMusic ? sanitizedName : 'SFX_$sanitizedName';
      final targetPath = '$targetDir$targetFileName$fileExt';

      // TODO: Copy file vào assets folder
      // Trong thực tế, cần implement cơ chế copy file vào assets
      // Đây là giả lập thành công

      // Tạo ID duy nhất cho asset
      final audioId = 'audio_$sanitizedName';

      // Tạo asset model cho audio
      final audioAsset = AssetModel.audio(
        id: audioId,
        name: displayName,
        filePath: targetPath,
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

  /// Upload file image từ local vào assets
  Future<AssetModel?> uploadImageAsset(File file, String targetDir,
      {String? customName, Map<String, dynamic>? dimensions}) async {
    try {
      // Lấy tên file và đuôi
      final fileName = path.basename(file.path);
      final fileExt = path.extension(file.path);
      final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

      // Tên hiển thị
      final displayName = customName ?? fileNameWithoutExt;

      // Đường dẫn đích trong assets
      final sanitizedName = displayName.replaceAll(' ', '_').toLowerCase();
      final targetPath = '$targetDir$sanitizedName$fileExt';

      // Kiểm tra có phải SVG không
      final isSvg = fileExt.toLowerCase() == '.svg';

      // TODO: Copy file vào assets folder
      // Trong thực tế, cần implement cơ chế copy file vào assets
      // Đây là giả lập thành công

      // Tạo ID duy nhất cho asset
      final imageId = 'image_$sanitizedName';

      // Tạo asset model cho image
      final imageAsset = AssetModel.image(
        id: imageId,
        name: displayName,
        filePath: targetPath,
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
}
