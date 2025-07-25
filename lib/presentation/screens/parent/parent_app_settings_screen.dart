import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_learning/data/models/app_settings_data.dart';
import 'package:flutter_learning/presentation/screens/parent/components/language_selection_modal.dart';
import 'package:flutter_learning/presentation/common/app_header.dart';
import 'package:flutter_learning/presentation/common/dropdown_field.dart';
import 'package:flutter_learning/presentation/common/settings_item.dart'
    as CommonSettings;

/// Application Settings Screen
class ParentAppSettingsScreen extends StatefulWidget {
  final Function(AppSettingsData)? onSettingsChanged;

  const ParentAppSettingsScreen({
    super.key,
    this.onSettingsChanged,
  });

  @override
  State<ParentAppSettingsScreen> createState() =>
      _ParentAppSettingsScreenState();
}

class _ParentAppSettingsScreenState extends State<ParentAppSettingsScreen> {
  late AppSettingsData _settingsData;

  @override
  void initState() {
    super.initState();
    _settingsData = AppSettingsData.getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header using AppHeader
            AppHeader(
              title: 'Cài đặt chung',
              scaleFactor: scale,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25 * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 32 * scale),

                      // Language selection using DropdownField
                      DropdownField<String>(
                        label: 'Ngôn ngữ hiển thị',
                        iconPath: 'assets/images/parent/language_icon.svg',
                        iconColor: Color(0xFFFFB61C),
                        selectedValue: _settingsData.selectedLanguage,
                        selectedText:
                            _settingsData.selectedLanguageOption?.name ??
                                'Chọn ngôn ngữ',
                        placeholder: 'Chọn ngôn ngữ',
                        onTap: _onLanguageSelectionTapped,
                        scaleFactor: scale,
                      ),

                      _buildDivider(scale),

                      // Background music toggle using SettingsItem
                      CommonSettings.SettingsItem(
                        label: 'Nhạc nền',
                        iconPath: 'assets/images/parent/volume_up_icon.svg',
                        iconColor: Color(0xFF68AFFF),
                        type: CommonSettings.SettingsItemType.toggle,
                        isEnabled: _settingsData.backgroundMusicEnabled,
                        onToggleChanged: (value) {
                          setState(() {
                            _settingsData = _settingsData.copyWith(
                                backgroundMusicEnabled: value);
                          });
                          _notifySettingsChanged();
                        },
                        scaleFactor: scale,
                      ),

                      _buildDivider(scale),

                      // Notification toggle using SettingsItem
                      CommonSettings.SettingsItem(
                        label: 'Thông báo',
                        iconPath: 'assets/images/parent/notification_icon.svg',
                        iconColor: Color(0xFFFF8AD1),
                        type: CommonSettings.SettingsItemType.toggle,
                        isEnabled: _settingsData.notificationEnabled,
                        onToggleChanged: (value) {
                          setState(() {
                            _settingsData = _settingsData.copyWith(
                                notificationEnabled: value);
                          });
                          _notifySettingsChanged();
                        },
                        scaleFactor: scale,
                      ),

                      _buildDivider(scale),

                      // Version display using SettingsItem
                      CommonSettings.SettingsItem(
                        label: 'Phiên bản',
                        iconPath: 'assets/images/parent/device_icon.svg',
                        iconColor: Color(0xFFC08EFF),
                        type: CommonSettings.SettingsItemType.display,
                        displayText: _settingsData.appVersion,
                        scaleFactor: scale,
                      ),

                      _buildDivider(scale),

                      SizedBox(height: 32 * scale),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build divider
  Widget _buildDivider(double scale) {
    return Container(
      width: double.infinity,
      height: 1 * scale,
      margin: EdgeInsets.symmetric(vertical: 12 * scale),
      color: Color(0xFFE5E5E5),
    );
  }

  /// Handle language selection tap
  void _onLanguageSelectionTapped() {
    showLanguageSelectionModal(
      context,
      selectedLanguageCode: _settingsData.selectedLanguage,
      availableLanguages: _settingsData.availableLanguages,
      onLanguageSelected: (language) {
        setState(() {
          _settingsData =
              _settingsData.copyWith(selectedLanguage: language.code);
        });
        _notifySettingsChanged();
      },
    );
  }

  /// Notify settings changed
  void _notifySettingsChanged() {
    if (widget.onSettingsChanged != null) {
      widget.onSettingsChanged!(_settingsData);
    }
  }
}
