import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../config_editor_panel.dart';
import '../../../../../../domain/repositories/asset_repository.dart';
import '../../../../../../data/models/asset_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Dialog chỉnh sửa hoặc thêm mới spine animation
class SpineAnimationEditorDialog extends StatefulWidget {
  final int editingIndex;
  final String? id;
  final String? skeletonPath;
  final String? atlasPath;
  final String? selectedAnimation;
  final String? selectedSkin;
  final String? scaleX;
  final String? scaleY;
  final String? positionX;
  final String? positionY;

  const SpineAnimationEditorDialog({
    Key? key,
    required this.editingIndex,
    this.id,
    this.skeletonPath,
    this.atlasPath,
    this.selectedAnimation,
    this.selectedSkin,
    this.scaleX,
    this.scaleY,
    this.positionX,
    this.positionY,
  }) : super(key: key);

  @override
  State<SpineAnimationEditorDialog> createState() =>
      _SpineAnimationEditorDialogState();

  /// Hiển thị dialog chỉnh sửa spine animation
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required int editingIndex,
    String? id,
    String? skeletonPath,
    String? atlasPath,
    String? selectedAnimation,
    String? selectedSkin,
    String? scaleX = '0.25',
    String? scaleY = '0.25',
    String? positionX = '0',
    String? positionY = '0',
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SpineAnimationEditorDialog(
          editingIndex: editingIndex,
          id: id,
          skeletonPath: skeletonPath,
          atlasPath: atlasPath,
          selectedAnimation: selectedAnimation,
          selectedSkin: selectedSkin,
          scaleX: scaleX,
          scaleY: scaleY,
          positionX: positionX,
          positionY: positionY,
        );
      },
    );
  }
}

class _SpineAnimationEditorDialogState
    extends State<SpineAnimationEditorDialog> {
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  List<AssetModel> _spineAssets = [];
  AssetModel? _selectedSpineAsset;
  String? _uploadStatusMessage;

  // Form values
  late TextEditingController _idController;
  late TextEditingController _skeletonPathController;
  late TextEditingController _atlasPathController;
  late TextEditingController _scaleXController;
  late TextEditingController _scaleYController;
  late TextEditingController _positionXController;
  late TextEditingController _positionYController;

  String _selectedAnimationValue = '';
  String _selectedSkinValue = '';

  // Available animations and skins from skeleton file
  List<String> _availableAnimations = [];
  List<String> _availableSkins = [];

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.id ?? '');
    _skeletonPathController =
        TextEditingController(text: widget.skeletonPath ?? '');
    _atlasPathController = TextEditingController(text: widget.atlasPath ?? '');
    _scaleXController = TextEditingController(text: widget.scaleX ?? '0.25');
    _scaleYController = TextEditingController(text: widget.scaleY ?? '0.25');
    _positionXController = TextEditingController(text: widget.positionX ?? '0');
    _positionYController = TextEditingController(text: widget.positionY ?? '0');

    _selectedAnimationValue = widget.selectedAnimation ?? '';
    _selectedSkinValue = widget.selectedSkin ?? '';

    // Tải danh sách spine assets từ repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSpineAssets();
    });

    // Nếu đã có skeleton path, phân tích animations và skins
    if (widget.skeletonPath != null && widget.skeletonPath!.isNotEmpty) {
      _extractAnimationsAndSkins(widget.skeletonPath!);
    }
  }

  /// Tải danh sách spine assets từ repository
  Future<void> _loadSpineAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      final assets = await assetRepository.getAssetsByType(AssetType.spine);

      setState(() {
        _spineAssets = assets;

        // Kiểm tra nếu đang edit, tìm asset tương ứng
        if (widget.skeletonPath != null && widget.skeletonPath!.isNotEmpty) {
          for (var asset in _spineAssets) {
            if (asset.metadata['skeleton'] == widget.skeletonPath) {
              _selectedSpineAsset = asset;
              break;
            }
          }

          // Nếu không tìm thấy asset phù hợp nhưng có assets khác, chọn asset đầu tiên
          if (_selectedSpineAsset == null && _spineAssets.isNotEmpty) {
            _selectedSpineAsset = _spineAssets.first;
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách spine assets: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _skeletonPathController.dispose();
    _atlasPathController.dispose();
    _scaleXController.dispose();
    _scaleYController.dispose();
    _positionXController.dispose();
    _positionYController.dispose();
    super.dispose();
  }

  /// Chọn spine asset từ danh sách đã có
  void _selectSpineAsset(AssetModel asset) {
    setState(() {
      _selectedSpineAsset = asset;

      // Cập nhật các trường thông tin
      if (asset.id.isNotEmpty) {
        _idController.text = asset.name;
      }

      final Map<String, dynamic> metadata = asset.metadata;
      final String skeletonPath = metadata['skeleton'] ?? '';
      final String atlasPath = metadata['atlas'] ?? '';

      _skeletonPathController.text = skeletonPath;
      _atlasPathController.text = atlasPath;

      // Phân tích animations và skins từ skeleton
      if (skeletonPath.isNotEmpty) {
        _extractAnimationsAndSkins(skeletonPath);
      }
    });
  }

  // Phân tích file skeleton.json để lấy danh sách animations và skins
  Future<void> _extractAnimationsAndSkins(String skeletonPath) async {
    try {
      // Đọc file skeleton
      final String skeletonContent = await rootBundle.loadString(skeletonPath);
      final Map<String, dynamic> skeletonData = json.decode(skeletonContent);

      // Lấy danh sách animations
      final List<String> animations = [];
      if (skeletonData.containsKey('animations')) {
        animations.addAll(skeletonData['animations'].keys.cast<String>());
      }

      // Lấy danh sách skins
      final List<String> skins = [];
      if (skeletonData.containsKey('skins')) {
        if (skeletonData['skins'] is List) {
          // Spine 4.0+ format
          for (var skin in skeletonData['skins']) {
            if (skin is Map && skin.containsKey('name')) {
              skins.add(skin['name']);
            }
          }
        } else if (skeletonData['skins'] is Map) {
          // Spine 3.8 format
          skins.addAll(skeletonData['skins'].keys.cast<String>());
        }
      }

      setState(() {
        _availableAnimations = animations;
        _availableSkins = skins;

        // Set default values if available
        if (_availableAnimations.isNotEmpty &&
            _selectedAnimationValue.isEmpty) {
          _selectedAnimationValue = _availableAnimations.first;
        }

        if (_availableSkins.isNotEmpty && _selectedSkinValue.isEmpty) {
          _selectedSkinValue = _availableSkins.first;
        }
      });

      print('Detected animations: $_availableAnimations');
      print('Detected skins: $_availableSkins');
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể phân tích file skeleton: $e';
      });
    }
  }

  /// Hiển thị dialog chọn spine asset
  Future<void> _showSpineAssetSelector() async {
    final AssetModel? selected = await showDialog<AssetModel>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn Spine Animation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Upload button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Spine mới'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close selector first
                        _uploadSpineAsset();
                      },
                    ),
                  ],
                ),

                const Divider(),
                const SizedBox(height: 8),

                // Search field
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm spine animation...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onChanged: (value) {
                    // Filter spines on search (would be implemented here)
                  },
                ),

                const SizedBox(height: 16),

                // Danh sách spine assets
                Expanded(
                  child: _spineAssets.isEmpty
                      ? const Center(
                          child: Text(
                            'Không có spine animation nào. Hãy upload trước trong Asset Manager.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _spineAssets.length,
                          itemBuilder: (context, index) {
                            final asset = _spineAssets[index];
                            final isSelected =
                                _selectedSpineAsset?.id == asset.id;

                            return Card(
                              color: isSelected ? Colors.blue.shade50 : null,
                              child: ListTile(
                                leading: const Icon(Icons.animation),
                                title: Text(asset.name),
                                subtitle: Text('ID: ${asset.id}'),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.blue)
                                    : null,
                                onTap: () {
                                  Navigator.of(context).pop(asset);
                                },
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      _selectSpineAsset(selected);
    }
  }

  /// Upload spine asset mới
  Future<void> _uploadSpineAsset() async {
    // 1. Hiển thị dialog để lấy tên cho spine animation
    final String? customName = await _showNameInputDialog();
    if (customName == null || customName.trim().isEmpty) return;

    // 2. Mở file picker để chọn các file spine (JSON và atlas)
    try {
      setState(() {
        _isUploading = true;
        _uploadStatusMessage = 'Đang chọn files...';
      });

      // Chọn các file spine (thường là .json, .atlas, .atlas.txt)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'atlas', 'txt', 'png'],
        allowMultiple: true,
        withData: kIsWeb, // Cần cho web
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isUploading = false;
          _uploadStatusMessage = null;
        });
        return;
      }

      setState(() {
        _uploadStatusMessage = 'Đang xử lý và tải lên files...';
      });

      // 3. Kiểm tra xem có đủ các file cần thiết không
      final hasJson =
          result.files.any((file) => file.extension?.toLowerCase() == 'json');

      final hasAtlas = result.files.any((file) =>
          file.extension?.toLowerCase() == 'atlas' ||
          (file.extension?.toLowerCase() == 'txt' &&
              file.name.toLowerCase().contains('atlas')));

      if (!hasJson || !hasAtlas) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cần chọn cả file skeleton.json và file atlas!'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isUploading = false;
          _uploadStatusMessage = null;
        });
        return;
      }

      // 4. Upload các file qua AssetRepository
      final assetRepository =
          Provider.of<AssetRepository>(context, listen: false);
      AssetModel? uploadedAsset;

      if (kIsWeb) {
        // Xử lý cho Web: chuyển đổi files thành Map<String, Uint8List>
        Map<String, Uint8List> fileMap = {};

        for (var file in result.files) {
          if (file.bytes != null) {
            fileMap[file.name] = file.bytes!;
          }
        }

        if (fileMap.isNotEmpty) {
          uploadedAsset = await assetRepository.uploadSpineAssetWeb(
            fileMap,
            customName: customName,
          );
        }
      } else {
        // Xử lý cho Mobile/Desktop: chuyển đổi thành List<File>
        List<File> files = [];

        for (var file in result.files) {
          if (file.path != null) {
            files.add(File(file.path!));
          }
        }

        if (files.isNotEmpty) {
          uploadedAsset = await assetRepository.uploadSpineAsset(
            files,
            customName: customName,
          );
        }
      }

      // 5. Refresh danh sách spine assets và chọn asset mới tải lên
      if (uploadedAsset != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Tải lên spine animation "${uploadedAsset.name}" thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Tải lại danh sách và chọn spine animation mới
        await _loadSpineAssets();
        _selectSpineAsset(uploadedAsset);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra khi tải lên spine animation!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _uploadStatusMessage = null;
      });
    }
  }

  /// Hiển thị dialog để nhập tên cho spine animation
  Future<String?> _showNameInputDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tên Spine Animation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nhập tên cho Spine Animation này:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên...',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập tên!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                Navigator.pop(context, nameController.text);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  // Xử lý khi nhấn nút lưu
  void _handleSave() {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID không được để trống')),
      );
      return;
    }

    if (_skeletonPathController.text.isEmpty ||
        _atlasPathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đường dẫn skeleton và atlas không được để trống')),
      );
      return;
    }

    if (_selectedAnimationValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn animation')),
      );
      return;
    }

    // Tạo kết quả spine item
    final Map<String, dynamic> result = {
      'id': _idController.text,
      'skeleton': _skeletonPathController.text,
      'atlas': _atlasPathController.text,
      'animation': _selectedAnimationValue,
      'scale': {
        'x': double.tryParse(_scaleXController.text) ?? 0.25,
        'y': double.tryParse(_scaleYController.text) ?? 0.25
      },
      'position': {
        'x': double.tryParse(_positionXController.text) ?? 0,
        'y': double.tryParse(_positionYController.text) ?? 0
      },
    };

    // Thêm skin nếu đã chọn
    if (_selectedSkinValue.isNotEmpty) {
      result['skins'] = _selectedSkinValue;
    }

    // Trả kết quả về và đóng dialog
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 700),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.editingIndex >= 0
                  ? 'Chỉnh sửa Spine Animation'
                  : 'Thêm Spine Animation mới',
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Đóng',
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_errorMessage != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          // Chọn spine asset từ Asset Manager
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chọn Spine Asset từ Asset Manager',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _selectedSpineAsset != null
                                          ? Text(
                                              'Đã chọn: ${_selectedSpineAsset!.name}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const Text(
                                              'Chưa chọn asset nào',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                    ),
                                    Row(
                                      children: [
                                        // Upload new button (new)
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.upload_file),
                                          label: const Text('Upload mới'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          onPressed: _uploadSpineAsset,
                                        ),
                                        const SizedBox(width: 8),
                                        // Choose existing button
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.folder_open),
                                          label: const Text('Chọn có sẵn'),
                                          onPressed: _showSpineAssetSelector,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Hiển thị thông tin asset đã chọn
                                if (_selectedSpineAsset != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Avatar/Icon
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.animation,
                                          size: 36,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Thông tin
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ID: ${_selectedSpineAsset!.id}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Skeleton: ${_selectedSpineAsset!.metadata['skeleton'] ?? 'N/A'}',
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Atlas: ${_selectedSpineAsset!.metadata['atlas'] ?? 'N/A'}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Text(
                            'Thông tin cấu hình Spine Animation:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ID
                          ConfigTextField(
                            label: 'ID',
                            value: _idController.text,
                            onChanged: (value) {
                              _idController.text = value;
                            },
                            helperText:
                                'Định danh duy nhất cho spine animation',
                          ),

                          // Skeleton file
                          Row(
                            children: [
                              Expanded(
                                child: ConfigTextField(
                                  label: 'File skeleton',
                                  value: _skeletonPathController.text,
                                  onChanged: (value) {
                                    _skeletonPathController.text = value;
                                  },
                                  helperText:
                                      'Đường dẫn đến file skeleton.json',
                                ),
                              ),
                            ],
                          ),

                          // Atlas file
                          Row(
                            children: [
                              Expanded(
                                child: ConfigTextField(
                                  label: 'File atlas',
                                  value: _atlasPathController.text,
                                  onChanged: (value) {
                                    _atlasPathController.text = value;
                                  },
                                  helperText: 'Đường dẫn đến file atlas',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          // Animation selection
                          if (_availableAnimations.isNotEmpty)
                            ConfigDropdown<String>(
                              label: 'Animation',
                              value: _selectedAnimationValue.isEmpty
                                  ? _availableAnimations.first
                                  : _selectedAnimationValue,
                              items: _availableAnimations,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAnimationValue = value;
                                });
                              },
                              helperText: 'Chọn animation để hiển thị',
                            )
                          else
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Chưa phát hiện animations. Vui lòng chọn file skeleton.',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),

                          // Skin selection
                          if (_availableSkins.isNotEmpty)
                            ConfigDropdown<String>(
                              label: 'Skin',
                              value: _selectedSkinValue.isEmpty
                                  ? _availableSkins.first
                                  : _selectedSkinValue,
                              items: _availableSkins,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSkinValue = value;
                                });
                              },
                              helperText: 'Chọn skin cho spine animation',
                            ),

                          const SizedBox(height: 16),
                          Text('Vị trí và kích thước:',
                              style: Theme.of(context).textTheme.titleSmall),

                          // Scale
                          Row(
                            children: [
                              Expanded(
                                child: ConfigTextField(
                                  label: 'Scale X',
                                  value: _scaleXController.text,
                                  onChanged: (value) {
                                    _scaleXController.text = value;
                                  },
                                  helperText: 'Tỷ lệ theo chiều ngang',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ConfigTextField(
                                  label: 'Scale Y',
                                  value: _scaleYController.text,
                                  onChanged: (value) {
                                    _scaleYController.text = value;
                                  },
                                  helperText: 'Tỷ lệ theo chiều dọc',
                                ),
                              ),
                            ],
                          ),

                          // Position
                          Row(
                            children: [
                              Expanded(
                                child: ConfigTextField(
                                  label: 'Position X',
                                  value: _positionXController.text,
                                  onChanged: (value) {
                                    _positionXController.text = value;
                                  },
                                  helperText: 'Vị trí theo chiều ngang',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ConfigTextField(
                                  label: 'Position Y',
                                  value: _positionYController.text,
                                  onChanged: (value) {
                                    _positionYController.text = value;
                                  },
                                  helperText: 'Vị trí theo chiều dọc',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),

              // Loading overlay for upload
              if (_isUploading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              _uploadStatusMessage ?? 'Đang tải lên...',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.editingIndex >= 0 ? Colors.orange : Colors.blue,
                  ),
                  child:
                      Text(widget.editingIndex >= 0 ? 'Cập nhật' : 'Thêm mới'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
