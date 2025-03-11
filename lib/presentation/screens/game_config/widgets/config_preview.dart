import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'draggable_component_preview.dart';

/// Widget to preview the game configuration
class ConfigPreview extends StatefulWidget {
  final Map<String, dynamic> configData;
  final Function(String, String?, String, Map<String, dynamic>)?
      onComponentMoved;

  const ConfigPreview({
    Key? key,
    required this.configData,
    this.onComponentMoved,
  }) : super(key: key);

  @override
  State<ConfigPreview> createState() => _ConfigPreviewState();
}

class _ConfigPreviewState extends State<ConfigPreview>
    with SingleTickerProviderStateMixin {
  late Size _previewSize;
  String? _errorMessage;
  bool _isLoadingBackground = false;
  Map<String, dynamic> _backgroundConfig = {};
  Map<String, dynamic> _lastConfigData = {};
  bool _showUpdateAnimation = false;
  late AnimationController _updateAnimationController;
  late Animation<double> _updateAnimation;

  // Tracks the active component being dragged
  String? _activeDragComponent;
  // Tracks the original position before drag to detect actual changes
  Map<String, Offset> _originalPositions = {};

  @override
  void initState() {
    super.initState();
    _previewSize = const Size(800, 450); // 16:9 aspect ratio for preview
    _lastConfigData = Map.from(widget.configData);
    _loadBackgroundConfig();

    // Thiết lập animation cho hiệu ứng cập nhật
    _updateAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _updateAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _updateAnimationController,
      curve: Curves.easeInOut,
    ));

    _updateAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showUpdateAnimation = false;
            });
            _updateAnimationController.reset();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTooltip();
    _updateAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ConfigPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra có thay đổi cấu hình không
    bool configChanged = _isConfigChanged(oldWidget.configData);

    // Tải lại cấu hình background nếu đường dẫn thay đổi
    if (oldWidget.configData['gameSettings']?['backgroundConfigPath'] !=
        widget.configData['gameSettings']?['backgroundConfigPath']) {
      _loadBackgroundConfig();
    }

    // Hiển thị animation cập nhật nếu có thay đổi
    if (configChanged) {
      _showUpdateEffect();
      _lastConfigData = Map.from(widget.configData);

      // Cập nhật lại originalPositions khi có thay đổi cấu hình từ bên ngoài
      _updateOriginalPositions();
    }
  }

  // Cập nhật vị trí gốc của các phần tử khi cấu hình thay đổi
  void _updateOriginalPositions() {
    _originalPositions.clear();

    try {
      // Airplane
      if (widget.configData['airplaneComponent'] != null) {
        _originalPositions['airplane'] =
            _getPositionFromConfig('airplaneComponent', null, 'position');
      }

      // Question
      if (widget.configData['questionConfig'] != null) {
        _originalPositions['questionBox'] =
            _getPositionFromConfig('questionConfig', null, 'position');

        // Target image if exists
        if (widget.configData['questionConfig']['showTargetImage'] == true) {
          _originalPositions['targetImage'] = _getPositionFromConfig(
              'questionConfig', null, 'targetImagePosition');
        }
      }

      // Answer buttons
      if (widget.configData['answerConfig']?['audioButtons'] != null) {
        final dynamic audioButtons =
            widget.configData['answerConfig']['audioButtons'];
        if (audioButtons is List) {
          for (int i = 0; i < audioButtons.length; i++) {
            try {
              _originalPositions['audioButton_$i'] = _getPositionFromConfig(
                  'answerConfig', 'audioButtons', '$i/position');
            } catch (e) {
              print('Error getting position for audioButton_$i: $e');
            }
          }
        }
      }

      // Drop zones
      if (widget.configData['dropZoneConfig']?['zones'] != null) {
        final dynamic zones = widget.configData['dropZoneConfig']['zones'];
        if (zones is List) {
          for (int i = 0; i < zones.length; i++) {
            try {
              _originalPositions['dropZone_$i'] = _getPositionFromConfig(
                  'dropZoneConfig', 'zones', '$i/position');
            } catch (e) {
              print('Error getting position for dropZone_$i: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error updating original positions: $e');
    }
  }

  // Kiểm tra xem config có thay đổi không bằng cách so sánh JSON
  bool _isConfigChanged(Map<String, dynamic> oldConfig) {
    String oldJson = jsonEncode(oldConfig);
    String newJson = jsonEncode(widget.configData);
    return oldJson != newJson;
  }

  // Hiển thị hiệu ứng cập nhật
  void _showUpdateEffect() {
    setState(() {
      _showUpdateAnimation = true;
    });
    _updateAnimationController.forward();
  }

  Future<void> _loadBackgroundConfig() async {
    final backgroundPath =
        widget.configData['gameSettings']?['backgroundConfigPath'];
    if (backgroundPath == null || backgroundPath.isEmpty) {
      setState(() {
        _backgroundConfig = {
          'type': 'Color',
          'color': '#87CEEB', // Sky blue default
        };
      });
      return;
    }

    setState(() {
      _isLoadingBackground = true;
      _errorMessage = null;
    });

    try {
      final String jsonString = await rootBundle.loadString(backgroundPath);
      setState(() {
        _backgroundConfig = json.decode(jsonString);
        _isLoadingBackground = false;
      });
    } catch (e) {
      print('Lỗi khi tải file cấu hình background: $e');
      setState(() {
        _backgroundConfig = {
          'type': 'Color',
          'color': '#87CEEB', // Sky blue default
        };
        _errorMessage = 'Không thể tải background: $e';
        _isLoadingBackground = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header với trạng thái cập nhật
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _showUpdateAnimation
                ? Colors.green.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Preview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (_showUpdateAnimation) ...[
                const SizedBox(width: 10),
                AnimatedBuilder(
                    animation: _updateAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green
                              .withOpacity(_updateAnimation.value * 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16 + (_updateAnimation.value * 4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Đã cập nhật',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12 + (_updateAnimation.value * 2),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ],
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate a size that fits within the constraints while maintaining aspect ratio
              final double maxWidth = constraints.maxWidth - 32; // Padding
              final double maxHeight =
                  constraints.maxHeight - 64; // Padding and header

              double width = _previewSize.width;
              double height = _previewSize.height;

              if (width > maxWidth) {
                width = maxWidth;
                height = width * (_previewSize.height / _previewSize.width);
              }

              if (height > maxHeight) {
                height = maxHeight;
                width = height * (_previewSize.width / _previewSize.height);
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background based on configuration
                        Positioned.fill(
                          child: _isLoadingBackground
                              ? const Center(child: CircularProgressIndicator())
                              : _buildBackgroundPreview(),
                        ),

                        // Question box
                        _buildDraggableComponent(
                          key: 'questionBox',
                          initialPosition: _getPositionFromConfig(
                              'questionConfig', 'boxQuestion', 'position'),
                          size: _getSizeFromConfig(
                              'questionConfig', 'boxQuestion', 'size'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        // Target image
                        _buildDraggableComponent(
                          key: 'targetImage',
                          initialPosition: _getPositionFromConfig(
                              'questionConfig', 'targetImage', 'position'),
                          size: _getSizeFromConfig(
                              'questionConfig', 'targetImage', 'size'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image,
                                size: 40, color: Colors.grey),
                          ),
                        ),

                        // Audio buttons
                        ..._buildAudioButtonPreviews(),

                        // Drop zones if enabled
                        if (widget.configData['dropZoneConfig']?['enabled'] ==
                            true)
                          ..._buildDropZonePreviews(),

                        // Airplane component
                        _buildDraggableComponent(
                          key: 'airplane',
                          initialPosition: _getPositionFromConfig(
                              'airplaneComponent', null, 'position'),
                          size: const Size(100, 100), // Fixed size for preview
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.airplanemode_active,
                                size: 40, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundPreview() {
    // Mặc định nếu không có cấu hình
    if (_backgroundConfig.isEmpty) {
      return Container(
        color: Colors.lightBlue.shade100,
        child: const Center(
          child: Text('Game Background'),
        ),
      );
    }

    final backgroundType = _backgroundConfig['type'] ?? 'Color';

    switch (backgroundType) {
      case 'Image':
        final imagePath = _backgroundConfig['imagePath'] ?? '';
        final fit = _getFitFromString(_backgroundConfig['fit'] ?? 'cover');

        if (imagePath.isEmpty) {
          return Container(
            color: Colors.lightBlue.shade100,
            child: const Center(
              child: Text('No image path specified'),
            ),
          );
        }

        try {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: fit,
              ),
            ),
          );
        } catch (e) {
          return Container(
            color: Colors.red.shade100,
            child: Center(
              child: Text(
                'Error loading image: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

      case 'Color':
        final colorString = _backgroundConfig['color'] ?? '#87CEEB';
        final color = _getColorFromHex(colorString);

        return Container(color: color);

      case 'Gradient':
        final startColorString = _backgroundConfig['startColor'] ?? '#4B79A1';
        final endColorString = _backgroundConfig['endColor'] ?? '#283E51';
        final startColor = _getColorFromHex(startColorString);
        final endColor = _getColorFromHex(endColorString);
        final gradientType = _backgroundConfig['gradientType'] ?? 'linear';
        final direction = _backgroundConfig['direction'] ?? 'topToBottom';

        if (gradientType == 'linear') {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _getGradientBegin(direction),
                end: _getGradientEnd(direction),
                colors: [startColor, endColor],
              ),
            ),
          );
        } else {
          // radial
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [startColor, endColor],
              ),
            ),
          );
        }

      default:
        return Container(
          color: Colors.lightBlue.shade100,
          child: Center(
            child: Text('Unsupported background type: $backgroundType'),
          ),
        );
    }
  }

  BoxFit _getFitFromString(String fit) {
    switch (fit) {
      case 'cover':
        return BoxFit.cover;
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'none':
        return BoxFit.none;
      default:
        return BoxFit.cover;
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.lightBlue.shade100;
    }
  }

  Alignment _getGradientBegin(String direction) {
    switch (direction) {
      case 'topToBottom':
        return Alignment.topCenter;
      case 'bottomToTop':
        return Alignment.bottomCenter;
      case 'leftToRight':
        return Alignment.centerLeft;
      case 'rightToLeft':
        return Alignment.centerRight;
      case 'topLeftToBottomRight':
        return Alignment.topLeft;
      case 'bottomRightToTopLeft':
        return Alignment.bottomRight;
      default:
        return Alignment.topCenter;
    }
  }

  Alignment _getGradientEnd(String direction) {
    switch (direction) {
      case 'topToBottom':
        return Alignment.bottomCenter;
      case 'bottomToTop':
        return Alignment.topCenter;
      case 'leftToRight':
        return Alignment.centerRight;
      case 'rightToLeft':
        return Alignment.centerLeft;
      case 'topLeftToBottomRight':
        return Alignment.bottomRight;
      case 'bottomRightToTopLeft':
        return Alignment.topLeft;
      default:
        return Alignment.bottomCenter;
    }
  }

  Widget _buildDraggableComponent({
    required String key,
    required Offset initialPosition,
    required Size size,
    required Widget child,
    String? section,
    String? subsection,
    String? positionKey,
  }) {
    // Extract section, subsection and positionKey from component key if not provided
    // Ensure section and positionKey are not null
    final String sectionValue = section ?? _getSectionFromKey(key);
    final String positionKeyValue = positionKey ?? 'position';

    // Lưu vị trí ban đầu để có thể so sánh khi kéo thả
    if (!_originalPositions.containsKey(key)) {
      _originalPositions[key] = initialPosition;
    }

    return DraggableComponentPreview(
      key: ValueKey('$key-${widget.configData.hashCode}'),
      initialPosition: initialPosition,
      size: size,
      isActive: _activeDragComponent == key,
      onPositionChanged: (Offset newPosition) {
        // Convert offset to position map
        final Map<String, dynamic> positionMap = {
          'x': newPosition.dx.round().toDouble(),
          'y': newPosition.dy.round().toDouble(),
        };

        // Hiển thị tooltip với vị trí hiện tại
        _showPositionTooltip(key, positionMap);

        // Chỉ cập nhật nếu vị trí thực sự thay đổi và có callback
        final originalPosition = _originalPositions[key];
        if (widget.onComponentMoved != null &&
            (originalPosition == null ||
                originalPosition.dx.round() != newPosition.dx.round() ||
                originalPosition.dy.round() != newPosition.dy.round())) {
          // Lưu vị trí mới vào originalPositions để tránh cập nhật liên tục
          _originalPositions[key] = newPosition;

          // Gọi callback để cập nhật cấu hình
          widget.onComponentMoved!(
              sectionValue, subsection, positionKeyValue, positionMap);
        }
      },
      onDragStart: () {
        setState(() {
          _activeDragComponent = key;
        });
      },
      onDragEnd: () {
        setState(() {
          _activeDragComponent = null;

          // Giữ tooltip thêm 1 giây rồi ẩn
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _hideTooltip();
            }
          });
        });
      },
      child: child,
    );
  }

  // Tooltip để hiển thị vị trí khi di chuyển
  OverlayEntry? _tooltipOverlay;
  void _showPositionTooltip(
      String componentKey, Map<String, dynamic> position) {
    _hideTooltip();

    _tooltipOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        right: 20,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Di chuyển: ${_getDisplayNameFromKey(componentKey)}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'X: ${position['x']}, Y: ${position['y']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_tooltipOverlay!);
  }

  // Lấy tên hiển thị đẹp hơn từ key
  String _getDisplayNameFromKey(String key) {
    if (key.startsWith('questionBox')) {
      return 'Hộp câu hỏi';
    } else if (key.startsWith('targetImage')) {
      return 'Hình ảnh mục tiêu';
    } else if (key.startsWith('audioButton')) {
      final index = int.tryParse(key.split('_').last) ?? 0;
      return 'Nút âm thanh ${index + 1}';
    } else if (key.startsWith('dropZone')) {
      final index = int.tryParse(key.split('_').last) ?? 0;
      return 'Khu vực thả ${index + 1}';
    } else if (key.startsWith('airplane')) {
      return 'Máy bay';
    } else {
      return key;
    }
  }

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  // Xác định section dựa trên key của component
  String _getSectionFromKey(String key) {
    if (key.startsWith('questionBox') || key.startsWith('targetImage')) {
      return 'questionConfig';
    } else if (key.startsWith('audioButton')) {
      return 'answerConfig';
    } else if (key.startsWith('dropZone')) {
      return 'dropZoneConfig';
    } else if (key.startsWith('airplane')) {
      return 'airplaneComponent';
    } else {
      // Trả về một giá trị mặc định thay vì null
      return 'otherComponents';
    }
  }

  List<Widget> _buildAudioButtonPreviews() {
    final List<Widget> buttons = [];
    final int numberOfButtons =
        widget.configData['gameSettings']?['numberOfChoices'] ?? 3;

    try {
      final answerConfig = widget.configData['answerConfig'];
      final List positions = _getButtonPositions(numberOfButtons);

      for (int i = 0; i < numberOfButtons; i++) {
        if (i < positions.length) {
          final position = positions[i];
          final size = _getSizeFromConfig(
              'answerConfig', 'audioButtons', 'layout/buttonSize');

          // Handle position values that might be expressions
          double xPos, yPos;

          try {
            if (position['x'] is String &&
                position['x'].toString().contains('gameSize')) {
              xPos = _parseConfigValue(position['x'].toString());
            } else {
              xPos = position['x'].toDouble();
            }

            if (position['y'] is String &&
                position['y'].toString().contains('gameSize')) {
              yPos = _parseConfigValue(position['y'].toString());
            } else {
              yPos = position['y'].toDouble();
            }
          } catch (e) {
            print('Error parsing button position: $e');
            // Fallback position
            xPos = 720.0;
            yPos = 200.0 + i * 120.0;
          }

          buttons.add(
            _buildDraggableComponent(
              key: 'audioButton_$i',
              initialPosition: Offset(xPos, yPos),
              size: size,
              section: 'answerConfig',
              subsection: 'audioButtons',
              positionKey: 'layout/buttonPositions/$i',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.volume_up, color: Colors.blue),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error building audio buttons: $e');
    }

    return buttons;
  }

  List<Widget> _buildDropZonePreviews() {
    final List<Widget> zones = [];

    try {
      final dropConfig = widget.configData['dropZoneConfig'];
      final List<dynamic>? zonesList = dropConfig?['zones'];

      if (zonesList != null) {
        for (int i = 0; i < zonesList.length; i++) {
          final zone = zonesList[i];
          final position = _getOffsetFromMap(zone['position']);
          final size = _getSizeFromMap(zone['size']);

          zones.add(
            _buildDraggableComponent(
              key: 'dropZone_$i',
              initialPosition: position,
              size: size,
              section: 'dropZoneConfig',
              subsection: 'zones',
              positionKey: '$i/position',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error building drop zones: $e');
    }

    return zones;
  }

  // Helper methods for accessing config values

  Offset _getPositionFromConfig(
      String section, String? subsection, String positionKey) {
    try {
      dynamic position;

      if (positionKey.contains('/')) {
        // Handle complex paths like '0/position' or 'layout/buttonPositions/0'
        final parts = positionKey.split('/');
        dynamic current = subsection != null
            ? widget.configData[section][subsection]
            : widget.configData[section];

        // Navigate through the path
        for (int i = 0; i < parts.length - 1; i++) {
          final part = parts[i];

          // If it's an array index
          if (int.tryParse(part) != null) {
            final index = int.parse(part);
            if (current is List && index < current.length) {
              current = current[index];
            } else {
              print(
                  'Invalid path at index $part: $current is not a List or index out of bounds');
              return Offset.zero;
            }
          } else {
            // If it's a map key
            if (current is Map) {
              if (!current.containsKey(part)) {
                print('Key not found: $part in $current');
                return Offset.zero;
              }
              current = current[part];
            } else {
              print('Invalid path at key $part: $current is not a Map');
              return Offset.zero;
            }
          }
        }

        // Get the final position
        final lastKey = parts.last;
        if (int.tryParse(lastKey) != null) {
          final index = int.parse(lastKey);
          if (current is List && index < current.length) {
            position = current[index];
          } else {
            print(
                'Invalid final index $lastKey: $current is not a List or index out of bounds');
            return Offset.zero;
          }
        } else {
          if (current is Map) {
            if (!current.containsKey(lastKey)) {
              print('Final key not found: $lastKey in $current');
              return Offset.zero;
            }
            position = current[lastKey];
          } else {
            print('Invalid final key $lastKey: $current is not a Map');
            return Offset.zero;
          }
        }
      } else {
        // Simple path
        if (subsection != null) {
          position = widget.configData[section][subsection][positionKey];
        } else {
          position = widget.configData[section][positionKey];
        }
      }

      return _getOffsetFromMap(position);
    } catch (e) {
      print('Error getting position from config: $e');
      return Offset.zero;
    }
  }

  Size _getSizeFromConfig(String section, String? subsection, String sizeKey) {
    try {
      Map<String, dynamic> size;
      if (subsection != null) {
        if (sizeKey.contains('/')) {
          // Handle nested paths like 'layout/buttonSize'
          final parts = sizeKey.split('/');
          size = widget.configData[section][subsection][parts[0]][parts[1]];
        } else {
          size = widget.configData[section][subsection][sizeKey];
        }
      } else {
        size = widget.configData[section][sizeKey];
      }

      return _getSizeFromMap(size);
    } catch (e) {
      print('Error getting size from config: $e');
      return const Size(50, 50); // Default fallback size
    }
  }

  Offset _getOffsetFromMap(dynamic positionData) {
    try {
      // Handle null case
      if (positionData == null) {
        print('Position data is null');
        return Offset.zero;
      }

      // Handle Map case
      if (positionData is Map) {
        final x = positionData['x'];
        final y = positionData['y'];

        if (x == null || y == null) {
          print('Position data missing x or y: $positionData');
          return Offset.zero;
        }

        return Offset(
            _parseConfigValue(x.toString()), _parseConfigValue(y.toString()));
      }

      // Handle List case (some configs might use arrays)
      if (positionData is List && positionData.length >= 2) {
        return Offset(_parseConfigValue(positionData[0].toString()),
            _parseConfigValue(positionData[1].toString()));
      }

      // Handle string case (might be formatted as "x,y")
      if (positionData is String && positionData.contains(',')) {
        final parts = positionData.split(',');
        if (parts.length >= 2) {
          return Offset(
              _parseConfigValue(parts[0]), _parseConfigValue(parts[1]));
        }
      }

      print('Unsupported position data format: $positionData');
      return Offset.zero;
    } catch (e) {
      print('Error parsing position data: $e');
      return Offset.zero;
    }
  }

  Size _getSizeFromMap(dynamic sizeData) {
    try {
      // Handle null case
      if (sizeData == null) {
        print('Size data is null');
        return const Size(50, 50); // Default size
      }

      // Handle Map case
      if (sizeData is Map) {
        // Some configs use width/height, others use x/y for size
        final width = sizeData['width'] ?? sizeData['x'];
        final height = sizeData['height'] ?? sizeData['y'];

        if (width == null || height == null) {
          print('Size data missing width/height or x/y: $sizeData');
          return const Size(50, 50);
        }

        return Size(_parseConfigValue(width.toString()),
            _parseConfigValue(height.toString()));
      }

      // Handle List case (some configs might use arrays)
      if (sizeData is List && sizeData.length >= 2) {
        return Size(_parseConfigValue(sizeData[0].toString()),
            _parseConfigValue(sizeData[1].toString()));
      }

      // Handle string case (might be formatted as "width,height")
      if (sizeData is String && sizeData.contains(',')) {
        final parts = sizeData.split(',');
        if (parts.length >= 2) {
          return Size(_parseConfigValue(parts[0]), _parseConfigValue(parts[1]));
        }
      }

      print('Unsupported size data format: $sizeData');
      return const Size(50, 50);
    } catch (e) {
      print('Error parsing size data: $e');
      return const Size(50, 50);
    }
  }

  double _parseConfigValue(String value) {
    try {
      // Handle empty or null values
      if (value.isEmpty) {
        return 0.0;
      }

      // Handle percentage values
      if (value.endsWith('%')) {
        final percentage = double.parse(value.substring(0, value.length - 1));
        return _previewSize.width * (percentage / 100);
      }

      // Simple expression parsing for "gameSize.x / 2 - 180" type expressions
      if (value.contains('gameSize')) {
        // Extract the dimension (x or y)
        final dimension = value.contains('gameSize.x') ? 'x' : 'y';
        final baseSize =
            dimension == 'x' ? _previewSize.width : _previewSize.height;

        // Handle division
        if (value.contains('/')) {
          final divisionParts = value.split('/');
          if (divisionParts.length >= 2) {
            final divisor =
                double.tryParse(divisionParts[1].trim().split(' ')[0]) ?? 2.0;
            double result = baseSize / divisor;

            // Handle subtraction after division
            if (value.contains('-')) {
              final subtractionParts = value.split('-');
              if (subtractionParts.length >= 2) {
                final subtrahend =
                    double.tryParse(subtractionParts[1].trim()) ?? 0.0;
                result -= subtrahend;
              }
            }

            // Handle addition after division
            if (value.contains('+')) {
              final additionParts = value.split('+');
              if (additionParts.length >= 2) {
                final addend = double.tryParse(additionParts[1].trim()) ?? 0.0;
                result += addend;
              }
            }

            return result;
          }
        }

        // Handle multiplication
        if (value.contains('*')) {
          final multiplicationParts = value.split('*');
          if (multiplicationParts.length >= 2) {
            final multiplier =
                double.tryParse(multiplicationParts[1].trim().split(' ')[0]) ??
                    1.0;
            return baseSize * multiplier;
          }
        }

        // Default case for gameSize references
        return baseSize * 0.5;
      }

      // Try to parse as a simple number
      return double.parse(value);
    } catch (e) {
      print('Error parsing config value "$value": $e');
      return 100; // Default fallback value
    }
  }

  List _getButtonPositions(int numberOfButtons) {
    try {
      final answerConfig = widget.configData['answerConfig'];
      final layout = answerConfig['audioButtons']['layout'];
      final useIndividualPositions = layout['useIndividualPositions'] ?? false;

      if (useIndividualPositions && layout['buttonPositions'] != null) {
        final positions = List.from(layout['buttonPositions']);
        if (positions.length >= numberOfButtons) {
          return positions.sublist(0, numberOfButtons);
        }
        return positions;
      } else {
        // Generate positions based on spacing
        final startPosition = layout['startPosition'];
        final spacing = layout['spacing'] ?? 20.0;
        final buttonSize = layout['buttonSize'];

        // Get x and y values, handling expressions
        dynamic xValue = startPosition['x'];
        dynamic yValue = startPosition['y'];

        // Keep the original values for the positions list
        // The actual parsing will happen in _buildAudioButtonPreviews

        List<Map<String, dynamic>> positions = [];
        for (int i = 0; i < numberOfButtons; i++) {
          // For y position, if it's a string expression, keep it as is
          // Otherwise, calculate the offset based on index
          dynamic yPos;
          if (yValue is String && yValue.contains('gameSize')) {
            // For expressions like "gameSize.y / 2 - 170.0", "gameSize.y / 2", "gameSize.y / 2 + 170.0"
            if (i == 0) {
              yPos = yValue; // First button uses the original expression
            } else if (i == 1) {
              // Middle button - remove any offset
              if (yValue.contains('-')) {
                yPos =
                    yValue.split('-')[0].trim(); // Keep just "gameSize.y / 2"
              } else if (yValue.contains('+')) {
                yPos =
                    yValue.split('+')[0].trim(); // Keep just "gameSize.y / 2"
              } else {
                yPos = yValue; // No offset to remove
              }
            } else {
              // Last button - use opposite offset
              if (yValue.contains('-')) {
                final parts = yValue.split('-');
                if (parts.length >= 2) {
                  yPos =
                      "${parts[0].trim()} + ${parts[1].trim()}"; // Change - to +
                } else {
                  yPos = yValue;
                }
              } else if (yValue.contains('+')) {
                final parts = yValue.split('+');
                if (parts.length >= 2) {
                  yPos =
                      "${parts[0].trim()} - ${parts[1].trim()}"; // Change + to -
                } else {
                  yPos = yValue;
                }
              } else {
                // If no offset, add a default one
                yPos = "$yValue + 170.0";
              }
            }
          } else {
            // Numeric value - calculate based on index and spacing
            double baseY = (yValue is num) ? yValue.toDouble() : 200.0;
            yPos = baseY +
                i *
                    ((buttonSize['y'] is num
                            ? buttonSize['y'].toDouble()
                            : 100.0) +
                        spacing);
          }

          positions.add({
            'x': xValue,
            'y': yPos,
          });
        }
        return positions;
      }
    } catch (e) {
      print('Error getting button positions: $e');
      // Fallback positions
      return List.generate(
          numberOfButtons,
          (index) => {
                'x': 720.0,
                'y': 200.0 + index * 120.0,
              });
    }
  }
}
