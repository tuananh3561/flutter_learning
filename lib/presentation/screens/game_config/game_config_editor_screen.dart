import 'package:flutter/material.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/config_preview.dart';
import 'package:flutter_learning/presentation/screens/game_config/widgets/config_editor_panel.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameConfigEditorScreen extends StatefulWidget {
  final String? configFilePath;

  const GameConfigEditorScreen({
    Key? key,
    this.configFilePath,
  }) : super(key: key);

  @override
  State<GameConfigEditorScreen> createState() => _GameConfigEditorScreenState();
}

class _GameConfigEditorScreenState extends State<GameConfigEditorScreen> {
  Map<String, dynamic>? _configData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConfigFile();
  }

  Future<void> _loadConfigFile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final String configPath =
          widget.configFilePath ?? 'assets/Multiple Choice/game_config.json';
      final String jsonString = await rootBundle.loadString(configPath);

      setState(() {
        _configData = json.decode(jsonString);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading configuration: $e';
        _isLoading = false;
      });
    }
  }

  void _updateConfigData(Map<String, dynamic> newConfigData) {
    setState(() {
      _configData = newConfigData;
    });
    // In a real app, we would save the file to disk or server here
  }

  Future<void> _saveConfigFile() async {
    // In a real implementation, this would save to a file or API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration saved successfully')),
    );
  }

  // Helper để buộc cập nhật lại Preview
  void _forcePreviewUpdate() {
    if (_configData != null) {
      // Tạo bản sao của dữ liệu hiện tại để kích hoạt cập nhật
      final updatedData = Map<String, dynamic>.from(_configData!);

      // Thêm timestamp để đảm bảo rằng widget sẽ nhận ra sự thay đổi
      updatedData['_lastUpdated'] = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        _configData = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Config Editor'),
        actions: [
          // Thêm nút cập nhật Preview
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Cập nhật Preview',
            onPressed:
                _isLoading || _configData == null ? null : _forcePreviewUpdate,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                _isLoading || _configData == null ? null : _saveConfigFile,
            tooltip: 'Save Configuration',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child:
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : Row(
                  children: [
                    // Editor panel (left side)
                    Expanded(
                      flex: 1,
                      child: ConfigEditorPanel(
                        configData: _configData!,
                        onConfigChanged: _updateConfigData,
                      ),
                    ),

                    // Vertical divider
                    const VerticalDivider(width: 1, thickness: 1),

                    // Preview panel (right side)
                    Expanded(
                      flex: 1,
                      child: ConfigPreview(
                        configData: _configData!,
                      ),
                    ),
                  ],
                ),
    );
  }
}
