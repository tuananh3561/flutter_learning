import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Enum cho loại button
enum ButtonType {
  primary,
  secondary,
}

/// Enum cho kích thước button
enum ButtonSize {
  small,
  medium,
  large,
  xl,
}

/// Custom Button Component theo thiết kế Figma
class CustomButton extends StatelessWidget {
  /// Text hiển thị trên button
  final String text;

  /// Callback khi button được nhấn
  final VoidCallback? onPressed;

  /// Loại button (primary hoặc secondary)
  final ButtonType type;

  /// Kích thước button
  final ButtonSize size;

  /// Icon leading (tuỳ chọn)
  final Widget? leadingIcon;

  /// Icon trailing (tuỳ chọn)
  final Widget? trailingIcon;

  /// Chiều rộng tối đa (full width nếu null)
  final double? maxWidth;

  /// Có disabled hay không
  final bool enabled;

  /// Custom scale factor (nếu null sẽ dùng flutter_screenutil)
  final double? customScale;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.large,
    this.leadingIcon,
    this.trailingIcon,
    this.maxWidth,
    this.enabled = true,
    this.customScale,
  }) : super(key: key);

  /// Helper method để scale values
  double _scale(double value) {
    return customScale != null ? value * customScale! : value;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final dimensions = _getDimensions();

    return Container(
      width: maxWidth ?? double.infinity,
      height: dimensions.height,
      decoration: BoxDecoration(
        color:
            enabled ? colors.backgroundColor : colors.disabledBackgroundColor,
        borderRadius: BorderRadius.circular(_scale(12)),
        border: colors.borderColor != null
            ? Border.all(color: colors.borderColor!, width: _scale(1))
            : null,
        boxShadow: enabled && colors.shadowColor != null
            ? [
                BoxShadow(
                  color: colors.shadowColor!,
                  offset: Offset(0, _scale(4)),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(_scale(12)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding,
              vertical: dimensions.verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  SizedBox(width: _scale(12)),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: dimensions.fontSize,
                      color:
                          enabled ? colors.textColor : colors.disabledTextColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: _scale(12)),
                  trailingIcon!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Lấy colors dựa trên type
  _ButtonColors _getColors() {
    switch (type) {
      case ButtonType.primary:
        return _ButtonColors(
          backgroundColor: const Color(0xFF36BFFA),
          textColor: Colors.white,
          shadowColor: const Color(0xFF00B2FF),
          disabledBackgroundColor: const Color(0xFFE5E5E5),
          disabledTextColor: const Color(0xFFAFAFAF),
        );
      case ButtonType.secondary:
        return _ButtonColors(
          backgroundColor: Colors.white,
          textColor: const Color(0xFF36BFFA),
          borderColor: const Color(0xFFE5E5E5),
          shadowColor: const Color(0xFFE5E5E5),
          disabledBackgroundColor: const Color(0xFFF5F5F5),
          disabledTextColor: const Color(0xFFAFAFAF),
        );
    }
  }

  /// Lấy dimensions dựa trên size
  _ButtonDimensions _getDimensions() {
    // Nếu có customScale thì dùng custom dimensions
    if (customScale != null) {
      switch (size) {
        case ButtonSize.small:
          return _ButtonDimensions(
            height: _scale(36),
            fontSize: _scale(14),
            horizontalPadding: _scale(16),
            verticalPadding: _scale(8),
          );
        case ButtonSize.medium:
          return _ButtonDimensions(
            height: _scale(44),
            fontSize: _scale(16),
            horizontalPadding: _scale(20),
            verticalPadding: _scale(12),
          );
        case ButtonSize.large:
          return _ButtonDimensions(
            height: _scale(52),
            fontSize: _scale(18),
            horizontalPadding: _scale(24),
            verticalPadding: _scale(14),
          );
        case ButtonSize.xl:
          return _ButtonDimensions(
            height: _scale(60),
            fontSize: _scale(20),
            horizontalPadding: _scale(24),
            verticalPadding: _scale(14),
          );
      }
    } else {
      // Sử dụng flutter_screenutil như cũ
      switch (size) {
        case ButtonSize.small:
          return _ButtonDimensions(
            height: 36.h,
            fontSize: 14.sp,
            horizontalPadding: 16.w,
            verticalPadding: 8.h,
          );
        case ButtonSize.medium:
          return _ButtonDimensions(
            height: 44.h,
            fontSize: 16.sp,
            horizontalPadding: 20.w,
            verticalPadding: 12.h,
          );
        case ButtonSize.large:
          return _ButtonDimensions(
            height: 52.h,
            fontSize: 18.sp,
            horizontalPadding: 24.w,
            verticalPadding: 14.h,
          );
        case ButtonSize.xl:
          return _ButtonDimensions(
            height: 60.h,
            fontSize: 20.sp,
            horizontalPadding: 24.w,
            verticalPadding: 18.h,
          );
      }
    }
  }
}

/// Helper class cho colors
class _ButtonColors {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.shadowColor,
    required this.disabledBackgroundColor,
    required this.disabledTextColor,
  });
}

/// Helper class cho dimensions
class _ButtonDimensions {
  final double height;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;

  _ButtonDimensions({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
  });
}
