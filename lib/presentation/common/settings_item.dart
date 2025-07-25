import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum cho loại settings item
enum SettingsItemType {
  toggle,
  display,
  navigation,
}

/// Widget settings item có thể tái sử dụng
/// Hỗ trợ toggle switch, text display, và navigation
class SettingsItem extends StatelessWidget {
  /// Text label hiển thị
  final String label;

  /// Path đến icon SVG (optional nếu có iconData)
  final String? iconPath;

  /// IconData Material icon (alternative to iconPath)
  final IconData? iconData;

  /// Màu icon
  final Color iconColor;

  /// Loại settings item
  final SettingsItemType type;

  /// Giá trị toggle (cho type = toggle)
  final bool? isEnabled;

  /// Callback khi toggle thay đổi (cho type = toggle)
  final Function(bool)? onToggleChanged;

  /// Text hiển thị bên phải (cho type = display)
  final String? displayText;

  /// Subtitle text (cho type = navigation)
  final String? subtitle;

  /// Hiển thị arrow (cho type = navigation)
  final bool showArrow;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Callback khi item được tap (optional)
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.label,
    this.iconPath,
    this.iconData,
    required this.iconColor,
    required this.type,
    this.isEnabled,
    this.onToggleChanged,
    this.displayText,
    this.subtitle,
    this.showArrow = true,
    this.scaleFactor = 1.0,
    this.onTap,
  })  : assert(
          (iconPath != null || iconData != null),
          'Either iconPath or iconData must be provided',
        ),
        assert(
          (type == SettingsItemType.toggle &&
                  isEnabled != null &&
                  onToggleChanged != null) ||
              (type == SettingsItemType.display && displayText != null) ||
              (type == SettingsItemType.navigation),
          'Toggle items require isEnabled and onToggleChanged, display items require displayText',
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          (type == SettingsItemType.toggle
              ? () => onToggleChanged?.call(!(isEnabled ?? false))
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and label
          Row(
            children: [
              // Icon
              Container(
                width: 24 * scaleFactor,
                height: 24 * scaleFactor,
                child: _buildIcon(),
              ),

              SizedBox(width: 24 * scaleFactor),

              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 16 * scaleFactor,
                  height: 1.5,
                  color: const Color(0xFF777777),
                ),
              ),
            ],
          ),

          // Right side content
          if (type == SettingsItemType.toggle)
            _buildToggleSwitch()
          else if (type == SettingsItemType.display)
            _buildDisplayText()
          else if (type == SettingsItemType.navigation)
            _buildNavigationContent(),
        ],
      ),
    );
  }

  /// Build toggle switch
  Widget _buildToggleSwitch() {
    final enabled = isEnabled ?? false;

    return GestureDetector(
      onTap: () => onToggleChanged?.call(!enabled),
      child: Container(
        width: 51 * scaleFactor,
        height: 31 * scaleFactor,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF92C73D) : const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(15.5 * scaleFactor),
        ),
        child: AnimatedAlign(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 27 * scaleFactor,
            height: 27 * scaleFactor,
            margin: EdgeInsets.all(2 * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.5 * scaleFactor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: Offset(0, 3 * scaleFactor),
                  blurRadius: 1 * scaleFactor,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: Offset(0, 3 * scaleFactor),
                  blurRadius: 8 * scaleFactor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build display text
  Widget _buildDisplayText() {
    return Text(
      displayText ?? '',
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w800,
        fontSize: 16 * scaleFactor,
        height: 1.5,
        color: const Color(0xFFAFAFAF),
      ),
    );
  }

  /// Build icon (SVG or Material icon)
  Widget _buildIcon() {
    if (iconPath != null) {
      return SvgPicture.asset(
        iconPath!,
        width: 24 * scaleFactor,
        height: 24 * scaleFactor,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      );
    } else if (iconData != null) {
      return Icon(
        iconData!,
        size: 24 * scaleFactor,
        color: iconColor,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Build navigation content (subtitle and arrow)
  Widget _buildNavigationContent() {
    if (subtitle != null && !showArrow) {
      // Display subtitle without arrow
      return Text(
        subtitle!,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          fontSize: 16 * scaleFactor,
          height: 1.5,
          color: const Color(0xFFAFAFAF),
        ),
      );
    } else if (showArrow) {
      // Show arrow with optional subtitle
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 16 * scaleFactor,
                height: 1.5,
                color: const Color(0xFFAFAFAF),
              ),
            ),
            SizedBox(width: 8 * scaleFactor),
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: 16 * scaleFactor,
            color: const Color(0xFF333741),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
