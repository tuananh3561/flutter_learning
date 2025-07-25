import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/parent_data.dart';
import 'package:flutter_learning/data/models/parent_user_info.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_user_info_screen.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_change_password_screen.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_app_settings_screen.dart';
import 'package:flutter_learning/presentation/screens/profile/list_profile_screen.dart';
import 'package:flutter_learning/presentation/common/app_header.dart';
import 'package:flutter_learning/presentation/common/settings_item.dart'
    as CommonSettings;
import 'package:flutter_learning/presentation/common/dialog/logout_dialog.dart';

/// Màn hình cài đặt cho phụ huynh
class ParentSettingsScreen extends StatefulWidget {
  final ParentSettingsData settingsData;

  const ParentSettingsScreen({
    super.key,
    required this.settingsData,
  });

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  /// Handle settings item tap
  void _handleSettingsItemTap(SettingsItem item) {
    switch (item.id) {
      case 'parent_info':
        _navigateToUserInfo();
        break;
      case 'learning_profile':
        _navigateToLearningProfile();
        break;
      case 'change_password':
        _navigateToChangePassword();
        break;
      case 'general_settings':
        _navigateToAppSettings();
        break;
      default:
        showLogoutDialog(context);
        // Call the original onTap if it exists
        if (item.onTap != null) {
          item.onTap!();
        }
        break;
    }
  }

  /// Navigate to user info screen
  void _navigateToUserInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParentUserInfoScreen(
          userInfo: ParentUserInfo.getSampleData(),
          onUserInfoChanged: (userInfo) {
            // TODO: Handle user info update
            print('User info updated: ${userInfo.name}');
          },
        ),
      ),
    );
  }

  /// Navigate to learning profile screen
  void _navigateToLearningProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ListProfileScreen(
          isFromParentSettings: true,
        ),
      ),
    );
  }

  /// Navigate to change password screen
  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParentChangePasswordScreen(
          onPasswordChanged: (passwordData) {
            // TODO: Handle password change
            print('Password changed successfully');
          },
        ),
      ),
    );
  }

  /// Navigate to app settings screen
  void _navigateToAppSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParentAppSettingsScreen(
          onSettingsChanged: (settingsData) {
            // TODO: Handle app settings change
            print('App settings changed: ${settingsData.selectedLanguage}');
          },
        ),
      ),
    );
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25 * scale),
            child: Column(
              children: [
                SizedBox(height: 68 * scale),

                // Header using AppHeader (without back button for main screen)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25 * scale),
                  child: Text(
                    'Dành cho phụ huynh',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 20 * scale,
                      height: 1.5,
                      color: Color(0xFF333741),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 24 * scale),

                // Settings sections
                _buildSettingsSections(scale),

                SizedBox(height: 48 * scale),

                // Bottom logos
                _buildBottomLogos(scale),

                SizedBox(height: 100 * scale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build all settings sections
  Widget _buildSettingsSections(double scale) {
    return Column(
      children: widget.settingsData.sections.map((section) {
        return Padding(
          padding: EdgeInsets.only(bottom: 32 * scale),
          child: _buildSettingsSection(scale, section),
        );
      }).toList(),
    );
  }

  /// Build individual settings section
  Widget _buildSettingsSection(double scale, SettingsSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          section.title,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16 * scale,
            height: 1.5,
            color: Color(0xFFAFAFAF),
          ),
        ),

        SizedBox(height: 16 * scale),

        // Section items
        Column(
          children: section.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                _buildSettingsItem(scale, item),
                if (index < section.items.length - 1) _buildDivider(scale),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build individual settings item using CommonSettings.SettingsItem
  Widget _buildSettingsItem(double scale, SettingsItem item) {
    final iconMapping = _getIconAndColor(item.icon);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12 * scale),
      child: CommonSettings.SettingsItem(
        label: item.title,
        iconData: iconMapping['icon'] as IconData,
        iconColor: iconMapping['color'] as Color,
        type: item.showArrow
            ? CommonSettings.SettingsItemType.navigation
            : CommonSettings.SettingsItemType.display,
        subtitle: item.showArrow ? item.subtitle : null,
        displayText: !item.showArrow ? item.subtitle : null,
        showArrow: item.showArrow,
        scaleFactor: scale,
        onTap: () => _handleSettingsItemTap(item),
      ),
    );
  }

  /// Build divider between settings items
  Widget _buildDivider(double scale) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8 * scale),
      height: 1 * scale,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFE5E5E5), Colors.transparent],
        ),
      ),
    );
  }

  /// Build bottom logos section
  Widget _buildBottomLogos(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App store logo
        Container(
          width: 83 * scale,
          height: 79 * scale,
          child: Image.asset(
            'assets/images/parent/app_store_logo.png',
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(width: 40 * scale),

        // KidSafe logo
        Container(
          width: 172 * scale,
          height: 78 * scale,
          child: Image.asset(
            'assets/images/parent/kidsafe_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  /// Get icon and color mapping for SettingsIcon enum
  Map<String, dynamic> _getIconAndColor(SettingsIcon iconType) {
    switch (iconType) {
      case SettingsIcon.profile:
        return {'icon': Icons.person_outline, 'color': Color(0xFF92C73D)};
      case SettingsIcon.mobile:
        return {
          'icon': Icons.phone_android_outlined,
          'color': Color(0xFF03C7BB)
        };
      case SettingsIcon.userCircle:
        return {
          'icon': Icons.account_circle_outlined,
          'color': Color(0xFFFF8AD1)
        };
      case SettingsIcon.student:
        return {'icon': Icons.school_outlined, 'color': Color(0xFFFF8AD1)};
      case SettingsIcon.unlock:
        return {'icon': Icons.lock_open_outlined, 'color': Color(0xFF92C73D)};
      case SettingsIcon.password:
        return {'icon': Icons.password_outlined, 'color': Color(0xFFC08EFF)};
      case SettingsIcon.setting:
        return {'icon': Icons.settings_outlined, 'color': Color(0xFFFFB61C)};
      case SettingsIcon.trash:
        return {'icon': Icons.delete_outline, 'color': Color(0xFFF14D57)};
      case SettingsIcon.alarm:
        return {'icon': Icons.alarm_outlined, 'color': Color(0xFFC08EFF)};
      case SettingsIcon.dangerCircle:
        return {'icon': Icons.error_outline, 'color': Color(0xFF68AFFF)};
      case SettingsIcon.paper:
        return {'icon': Icons.description_outlined, 'color': Color(0xFFFF8AD1)};
      case SettingsIcon.shieldDone:
        return {
          'icon': Icons.verified_user_outlined,
          'color': Color(0xFF03C7BB)
        };
      case SettingsIcon.chat:
        return {'icon': Icons.chat_bubble_outline, 'color': Color(0xFFC08EFF)};
      case SettingsIcon.calling:
        return {'icon': Icons.phone_outlined, 'color': Color(0xFF92C73D)};
      case SettingsIcon.logout:
        return {'icon': Icons.logout, 'color': Color(0xFFF14D58)};
    }
  }
}
