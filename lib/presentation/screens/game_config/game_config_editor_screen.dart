import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/config_preview.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/config_editor_panel.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/feedback_message.dart';
import 'blocs/game_config_bloc.dart';

/// Màn hình chỉnh sửa cấu hình game với UI được tối ưu hóa
/// Sử dụng BLoC pattern để quản lý state và FeedbackMessage để hiển thị thông báo
class GameConfigEditorScreen extends StatefulWidget {
  final String? configFilePath;

  const GameConfigEditorScreen({
    Key? key,
    this.configFilePath,
  }) : super(key: key);

  @override
  State<GameConfigEditorScreen> createState() => _GameConfigEditorScreenState();
}

class _GameConfigEditorScreenState extends State<GameConfigEditorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _feedbackAnimController;
  late Animation<double> _feedbackAnim;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OverlayEntry? _tooltipOverlay;

  @override
  void initState() {
    super.initState();

    // Thiết lập animation controller cho hiệu ứng phản hồi
    _feedbackAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _feedbackAnim = CurvedAnimation(
      parent: _feedbackAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _feedbackAnimController.dispose();
    _hideTooltip();
    super.dispose();
  }

  /// Hiển thị tooltip khi kéo thả các component
  void _showPositionTooltip(
      String componentName, Map<String, dynamic> position) {
    _hideTooltip();

    _tooltipOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 70,
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
                  'Di chuyển: $componentName',
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

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameConfigBloc()
        ..add(LoadGameConfig(configFilePath: widget.configFilePath)),
      child: Builder(builder: (context) {
        return BlocConsumer<GameConfigBloc, GameConfigState>(
          listener: (context, state) {
            if (state is ComponentMoved) {
              // Sử dụng FeedbackMessage để hiển thị thông báo tốt hơn
              FeedbackMessage.showSuccess(
                context,
                message:
                    'Đã cập nhật vị trí (${state.section}${state.subsection != null ? "/${state.subsection}" : ""})',
                displayDuration: const Duration(seconds: 1),
              );
              _feedbackAnimController.forward(from: 0.0);
            } else if (state is GameConfigError) {
              FeedbackMessage.showError(
                context,
                message: state.message,
              );
            } else if (state is GameConfigSaved) {
              FeedbackMessage.showSuccess(
                context,
                message: 'Cấu hình đã được lưu thành công',
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Row(
                  children: [
                    const Text('Game Config Editor'),
                    if (state is GameConfigLoaded) ...[
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Đã tải',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  // Animated button for "Update Preview"
                  BlocBuilder<GameConfigBloc, GameConfigState>(
                    buildWhen: (previous, current) =>
                        current is GameConfigLoaded && current.previewUpdated,
                    builder: (context, state) {
                      return AnimatedBuilder(
                        animation: _feedbackAnim,
                        builder: (context, child) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              color: state is GameConfigLoaded &&
                                      state.previewUpdated
                                  ? Colors.green
                                      .withOpacity(_feedbackAnim.value * 0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: child,
                          );
                        },
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Cập nhật Preview',
                          onPressed: state is GameConfigLoaded
                              ? () {
                                  context
                                      .read<GameConfigBloc>()
                                      .add(ForcePreviewUpdate());
                                  FeedbackMessage.showSuccess(
                                    context,
                                    message: 'Preview đã được cập nhật',
                                    displayDuration: const Duration(seconds: 1),
                                  );
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: 'Lưu cấu hình',
                    onPressed: state is GameConfigLoaded
                        ? () =>
                            context.read<GameConfigBloc>().add(SaveGameConfig())
                        : null,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: BlocBuilder<GameConfigBloc, GameConfigState>(
                builder: (context, state) {
                  if (state is GameConfigLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Đang tải cấu hình...'),
                        ],
                      ),
                    );
                  }

                  if (state is GameConfigError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.read<GameConfigBloc>().add(
                                LoadGameConfig(
                                    configFilePath: widget.configFilePath)),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is GameConfigLoaded) {
                    return Row(
                      children: [
                        // Editor panel (left side)
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ConfigEditorPanel(
                              configData: state.configData,
                              onConfigChanged: (newConfigData) => context
                                  .read<GameConfigBloc>()
                                  .add(UpdateGameConfig(newConfigData)),
                            ),
                          ),
                        ),

                        // Vertical divider with animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 1,
                          color: Colors.grey.withOpacity(0.3),
                          child: const VerticalDivider(width: 1, thickness: 1),
                        ),

                        // Preview panel (right side)
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ConfigPreview(
                              configData: state.configData,
                              onComponentMoved: (section, subsection,
                                  positionKey, newPosition) {
                                // Hiển thị tooltip khi di chuyển
                                _showPositionTooltip(
                                    _getDisplayNameForComponent(
                                        section, subsection, positionKey),
                                    newPosition);

                                // Dispatch event để cập nhật vị trí
                                context.read<GameConfigBloc>().add(
                                      MoveComponent(
                                        section: section,
                                        subsection: subsection,
                                        positionKey: positionKey,
                                        newPosition: newPosition,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // Default empty state
                  return const Center(
                    child: Text('Không có dữ liệu để hiển thị'),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  /// Lấy tên hiển thị thân thiện cho component
  String _getDisplayNameForComponent(
      String section, String? subsection, String positionKey) {
    switch (section) {
      case 'questionConfig':
        return positionKey.contains('targetImage')
            ? 'Hình ảnh mục tiêu'
            : 'Hộp câu hỏi';
      case 'answerConfig':
        if (subsection == 'audioButtons') {
          final index = _extractIndexFromPath(positionKey);
          return 'Nút âm thanh ${index + 1}';
        }
        return 'Phần trả lời';
      case 'dropZoneConfig':
        if (subsection == 'zones') {
          final index = _extractIndexFromPath(positionKey);
          return 'Khu vực thả ${index + 1}';
        }
        return 'Khu vực thả';
      case 'airplaneComponent':
        return 'Máy bay';
      default:
        return 'Phần tử';
    }
  }

  /// Trích xuất index từ positionKey dạng "0/position" hoặc "layout/buttonPositions/0"
  int _extractIndexFromPath(String positionKey) {
    if (positionKey.contains('/')) {
      final parts = positionKey.split('/');
      for (final part in parts) {
        final index = int.tryParse(part);
        if (index != null) {
          return index;
        }
      }
    }
    return 0;
  }
}
