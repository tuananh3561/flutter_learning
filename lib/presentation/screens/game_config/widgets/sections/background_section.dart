import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'background_section/index.dart';

/// Widget để cấu hình hình nền
class BackgroundSection extends StatefulWidget {
  final Map<String, dynamic> backgroundConfig;
  final String backgroundConfigPath;
  final Function(Map<String, dynamic>) onBackgroundConfigChanged;
  final Function(String) onBackgroundPathChanged;

  const BackgroundSection({
    Key? key,
    required this.backgroundConfig,
    required this.backgroundConfigPath,
    required this.onBackgroundConfigChanged,
    required this.onBackgroundPathChanged,
  }) : super(key: key);

  @override
  State<BackgroundSection> createState() => _BackgroundSectionState();
}

class _BackgroundSectionState extends State<BackgroundSection> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _loadedBackgroundConfig = {};

  @override
  void initState() {
    super.initState();
    _loadedBackgroundConfig =
        Map<String, dynamic>.from(widget.backgroundConfig);
  }

  Future<void> _loadBackgroundConfig() async {
    if (widget.backgroundConfigPath.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String jsonString =
          await rootBundle.loadString(widget.backgroundConfigPath);
      setState(() {
        _loadedBackgroundConfig = json.decode(jsonString);
        _isLoading = false;

        // Thông báo thay đổi cấu hình để cập nhật Preview
        _updateBackgroundConfig();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải file cấu hình background: $e';
        _isLoading = false;
      });
    }
  }

  void _updateBackgroundConfig() {
    // Gọi callback để cập nhật cấu hình và kích hoạt cập nhật Preview
    widget.onBackgroundConfigChanged(_loadedBackgroundConfig);

    // In ra log để debug
    print('Background config updated: ${json.encode(_loadedBackgroundConfig)}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cấu Hình Hình Nền',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          )
        else ...[
          // Phần cấu hình chung và hình nền
          BackgroundConfigSection(
            backgroundConfig: _loadedBackgroundConfig,
            backgroundConfigPath: widget.backgroundConfigPath,
            onBackgroundConfigChanged: (updatedConfig) {
              setState(() {
                _loadedBackgroundConfig = updatedConfig;
                _updateBackgroundConfig();
              });
            },
            onBackgroundPathChanged: widget.onBackgroundPathChanged,
            onLoadBackgroundConfig: _loadBackgroundConfig,
          ),

          // Phần Decoration (trang trí)
          if (_loadedBackgroundConfig.isNotEmpty)
            DecorationSection(
              backgroundConfig: _loadedBackgroundConfig,
              onBackgroundConfigChanged: (updatedConfig) {
                setState(() {
                  _loadedBackgroundConfig = updatedConfig;
                  _updateBackgroundConfig();
                });
              },
            ),
        ],
      ],
    );
  }
}
