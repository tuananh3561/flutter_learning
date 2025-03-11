import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'draggable_component_preview.dart';

/// Widget to preview the game configuration
class ConfigPreview extends StatefulWidget {
  final Map<String, dynamic> configData;

  const ConfigPreview({
    Key? key,
    required this.configData,
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
  }) {
    return DraggableComponentPreview(
      key: ValueKey(key),
      initialPosition: initialPosition,
      size: size,
      isActive: _activeDragComponent == key,
      onPositionChanged: (Offset newPosition) {
        // Here we would update the config with the new position
        print('Position changed for $key: $newPosition');
      },
      onDragStart: () {
        setState(() {
          _activeDragComponent = key;
        });
      },
      onDragEnd: () {
        setState(() {
          _activeDragComponent = null;
        });
      },
      child: child,
    );
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

          buttons.add(
            _buildDraggableComponent(
              key: 'audioButton_$i',
              initialPosition:
                  Offset(position['x'].toDouble(), position['y'].toDouble()),
              size: size,
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
      Map<String, dynamic> position;
      if (subsection != null) {
        position = widget.configData[section][subsection][positionKey];
      } else {
        position = widget.configData[section][positionKey];
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

  Offset _getOffsetFromMap(Map<String, dynamic> map) {
    final x = _parseConfigValue(map['x'].toString());
    final y = _parseConfigValue(map['y'].toString());
    return Offset(x, y);
  }

  Size _getSizeFromMap(Map<String, dynamic> map) {
    final width = _parseConfigValue(map['x'].toString());
    final height = _parseConfigValue(map['y'].toString());
    return Size(width, height);
  }

  double _parseConfigValue(String value) {
    try {
      // Simple expression parsing for "gameSize.x / 2 - 180" type expressions
      if (value.contains('gameSize')) {
        // For preview, just return a reasonable value based on the expression
        if (value.contains('/') && value.contains('-')) {
          // Assuming it's something like "gameSize.x / 2 - 180"
          return _previewSize.width / 2 - 180;
        } else if (value.contains('/')) {
          // Assuming it's something like "gameSize.x / 2"
          return _previewSize.width / 2;
        } else {
          // Just return a proportion of the preview size
          return _previewSize.width * 0.5;
        }
      }

      return double.parse(value);
    } catch (e) {
      print('Error parsing config value: $e');
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

        List<Map<String, dynamic>> positions = [];
        for (int i = 0; i < numberOfButtons; i++) {
          positions.add({
            'x': startPosition['x'],
            'y': startPosition['y'] + i * (buttonSize['y'] + spacing),
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
