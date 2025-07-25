import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget dropdown field có thể tái sử dụng
/// Bao gồm label với icon và dropdown field
class DropdownField<T> extends StatelessWidget {
  /// Text label hiển thị
  final String label;

  /// Path đến icon SVG
  final String iconPath;

  /// Màu icon
  final Color iconColor;

  /// Giá trị hiện tại được chọn
  final T? selectedValue;

  /// Text hiển thị cho giá trị được chọn
  final String selectedText;

  /// Placeholder text khi chưa chọn
  final String placeholder;

  /// Callback khi user tap vào dropdown
  final VoidCallback onTap;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Background color (optional)
  final Color? backgroundColor;

  /// Border color (optional)
  final Color? borderColor;

  /// Text color (optional)
  final Color? textColor;

  const DropdownField({
    super.key,
    required this.label,
    required this.iconPath,
    required this.iconColor,
    this.selectedValue,
    required this.selectedText,
    this.placeholder = 'Chọn...',
    required this.onTap,
    this.scaleFactor = 1.0,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label với icon
        Row(
          children: [
            // Icon
            Container(
              width: 24 * scaleFactor,
              height: 24 * scaleFactor,
              child: SvgPicture.asset(
                iconPath,
                width: 24 * scaleFactor,
                height: 24 * scaleFactor,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(width: 8 * scaleFactor),

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

        SizedBox(height: 12 * scaleFactor),

        // Dropdown field
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              border: Border.all(
                color: borderColor ?? const Color(0xFFAFAFAF),
                width: 1 * scaleFactor,
              ),
              borderRadius: BorderRadius.circular(8 * scaleFactor),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scaleFactor,
              vertical: 16 * scaleFactor,
            ),
            child: Row(
              children: [
                // Selected value text
                Expanded(
                  child: Text(
                    selectedValue != null ? selectedText : placeholder,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 16 * scaleFactor,
                      height: 1.5,
                      color: textColor ?? const Color(0xFFAFAFAF),
                    ),
                  ),
                ),

                SizedBox(width: 8 * scaleFactor),

                // Arrow down icon
                SvgPicture.asset(
                  'assets/images/parent/arrow_down_icon.svg',
                  width: 24 * scaleFactor,
                  height: 24 * scaleFactor,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF777777),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
