import 'package:flutter/material.dart';
import 'sections/game_settings_section.dart';
import 'sections/question_section.dart';
import 'sections/answer_section.dart';
import 'sections/drop_zone_section.dart';
import 'sections/sound_section.dart';
import 'sections/vocabulary_section.dart';
import 'sections/background_section.dart';
import 'sections/anim_spine_section.dart';
import 'sections/asset_manager_section.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/common/color_picker_dialog.dart';

/// Widget to edit the game configuration
class ConfigEditorPanel extends StatefulWidget {
  final Map<String, dynamic> configData;
  final Function(Map<String, dynamic>) onConfigChanged;

  const ConfigEditorPanel({
    Key? key,
    required this.configData,
    required this.onConfigChanged,
  }) : super(key: key);

  @override
  State<ConfigEditorPanel> createState() => _ConfigEditorPanelState();
}

class _ConfigEditorPanelState extends State<ConfigEditorPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _editedData;
  Map<String, dynamic> _backgroundConfig = {};
  Map<String, dynamic> _animSpineConfig = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _editedData = Map<String, dynamic>.from(widget.configData);

    // Khởi tạo cấu hình background hoặc dùng giá trị mặc định
    _backgroundConfig = {
      'type': 'Image',
      'imagePath': '',
      'fit': 'cover',
      'color': '#FFFFFF',
      'startColor': '#4B79A1',
      'endColor': '#283E51',
      'gradientType': 'linear',
      'direction': 'topToBottom'
    };

    // Khởi tạo cấu hình AnimSpine
    _animSpineConfig = {'spine_animations': []};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateConfigData() {
    widget.onConfigChanged(_editedData);
  }

  // Cải thiện xử lý cập nhật để đảm bảo preview được cập nhật
  void _updateConfigWithForceRefresh() {
    // Thêm trường lastUpdated để đảm bảo preview phát hiện thay đổi
    _editedData['_lastUpdated'] = DateTime.now().millisecondsSinceEpoch;
    widget.onConfigChanged(_editedData);
  }

  void _updateSection(String section, Map<String, dynamic> data) {
    setState(() {
      _editedData[section] = data;
      _updateConfigData();
    });
  }

  // Cập nhật section với dấu hiệu refresh rõ ràng
  void _updateSectionWithRefresh(String section, Map<String, dynamic> data) {
    setState(() {
      _editedData[section] = data;
      _updateConfigWithForceRefresh();

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật Preview'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _updateBackgroundConfigPath(String path) {
    setState(() {
      _editedData['gameSettings']['backgroundConfigPath'] = path;
      _updateConfigData();
    });
  }

  void _updateAnimSpineConfigPath(String path) {
    setState(() {
      _editedData['gameSettings']['animSpineConfigPath'] = path;
      _updateConfigData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar for different configuration sections
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Game Settings'),
            Tab(text: 'Background'),
            Tab(text: 'Spine Animation'),
            Tab(text: 'Question'),
            Tab(text: 'Answer'),
            Tab(text: 'Drop Zones'),
            Tab(text: 'Sound'),
            Tab(text: 'Vocabulary'),
            Tab(text: 'Asset Manager'),
          ],
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Game Settings
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GameSettingsSection(
                    gameSettings: _editedData['gameSettings'],
                    gameInfo: _editedData['gameInfo'],
                    onGameSettingsChanged: (data) =>
                        _updateSection('gameSettings', data),
                    onGameInfoChanged: (data) =>
                        _updateSection('gameInfo', data),
                  ),
                ),
              ),

              // Background Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BackgroundSection(
                    backgroundConfig: _backgroundConfig,
                    backgroundConfigPath: _editedData['gameSettings']
                            ?['backgroundConfigPath'] ??
                        '',
                    onBackgroundConfigChanged: (data) {
                      setState(() {
                        _backgroundConfig = data;
                      });
                    },
                    onBackgroundPathChanged: _updateBackgroundConfigPath,
                  ),
                ),
              ),

              // Spine Animation Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimSpineSection(
                    animSpineConfig: _animSpineConfig,
                    animSpineConfigPath: _editedData['gameSettings']
                            ?['animSpineConfigPath'] ??
                        '',
                    onAnimSpineConfigChanged: (data) {
                      setState(() {
                        _animSpineConfig = data;
                      });
                    },
                    onAnimSpinePathChanged: _updateAnimSpineConfigPath,
                  ),
                ),
              ),

              // Question Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QuestionSection(
                    questionConfig: _editedData['questionConfig'],
                    onQuestionConfigChanged: (data) =>
                        _updateSectionWithRefresh('questionConfig', data),
                  ),
                ),
              ),

              // Answer Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnswerSection(
                    answerConfig: _editedData['answerConfig'],
                    onAnswerConfigChanged: (data) =>
                        _updateSectionWithRefresh('answerConfig', data),
                  ),
                ),
              ),

              // Drop Zone Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropZoneSection(
                    dropZoneConfig: _editedData['dropZoneConfig'],
                    onDropZoneConfigChanged: (data) =>
                        _updateSectionWithRefresh('dropZoneConfig', data),
                  ),
                ),
              ),

              // Sound Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SoundSection(
                    soundConfig: _editedData['soundConfig'],
                    onSoundConfigChanged: (data) =>
                        _updateSectionWithRefresh('soundConfig', data),
                  ),
                ),
              ),

              // Vocabulary Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: VocabularySection(
                    vocabularyConfig: _editedData['vocabulary'],
                    onVocabularyConfigChanged: (data) =>
                        _updateSectionWithRefresh('vocabulary', data),
                  ),
                ),
              ),

              // Asset Manager Section
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AssetManagerSection(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Common widgets for editing

/// Widget for editing a text field
class ConfigTextField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final String? helperText;

  const ConfigTextField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
        onChanged: onChanged,
      ),
    );
  }
}

/// Widget for editing a number field
class ConfigNumberField extends StatelessWidget {
  final String label;
  final num value;
  final Function(num) onChanged;
  final String? helperText;

  const ConfigNumberField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value.toString()),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          try {
            if (value.contains('.')) {
              onChanged(double.parse(value));
            } else {
              onChanged(int.parse(value));
            }
          } catch (e) {
            // Invalid number, don't update
          }
        },
      ),
    );
  }
}

/// Widget for editing a boolean field
class ConfigSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final String? helperText;

  const ConfigSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (helperText != null)
                  Text(
                    helperText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Widget for editing a dropdown field
class ConfigDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final Function(T) onChanged;
  final String? helperText;

  const ConfigDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                helperText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          DropdownButtonFormField<T>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            items: items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(item.toString()),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Widget for editing a color
class ConfigColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final Function(Color) onChanged;
  final String? helperText;

  const ConfigColorPicker({
    Key? key,
    required this.label,
    required this.color,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (helperText != null)
                  Text(
                    helperText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ColorPickerDialog.show(
                context,
                color,
                (newColor) => onChanged(newColor),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for editing a position with drag support
class ConfigPositionEditor extends StatelessWidget {
  final String label;
  final Map<String, dynamic> position;
  final Function(Map<String, dynamic>) onChanged;
  final String? helperText;

  const ConfigPositionEditor({
    Key? key,
    required this.label,
    required this.position,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                helperText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'X',
                    border: OutlineInputBorder(),
                  ),
                  controller:
                      TextEditingController(text: position['x'].toString()),
                  onChanged: (value) {
                    final updated = Map<String, dynamic>.from(position);
                    updated['x'] = value;
                    onChanged(updated);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Y',
                    border: OutlineInputBorder(),
                  ),
                  controller:
                      TextEditingController(text: position['y'].toString()),
                  onChanged: (value) {
                    final updated = Map<String, dynamic>.from(position);
                    updated['y'] = value;
                    onChanged(updated);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
