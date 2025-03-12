import 'package:flutter/material.dart';
import '../../utils/config_constants.dart';

/// Widget container có tiêu đề để hiển thị các section trong GameConfigEditor
class LabeledContainer extends StatelessWidget {
  final String label;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final CrossAxisAlignment childAlignment;
  final Widget? trailing;

  const LabeledContainer({
    Key? key,
    required this.label,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.childAlignment = CrossAxisAlignment.start,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? ConfigConstants.sectionPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: borderRadius ??
            BorderRadius.circular(ConfigConstants.cardBorderRadius),
        boxShadow: boxShadow ?? ConfigConstants.defaultBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),

          // Divider
          const Divider(height: 24),

          // Content
          Padding(
            padding: padding ?? ConfigConstants.contentPadding,
            child: Column(
              crossAxisAlignment: childAlignment,
              children: [child],
            ),
          ),
        ],
      ),
    );
  }
}
