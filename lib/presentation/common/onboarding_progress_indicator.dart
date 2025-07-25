import 'package:flutter/material.dart';

/// Onboarding Progress Indicator component có thể tái sử dụng
/// Hiển thị progress steps cho onboarding flow
class OnboardingProgressIndicator extends StatelessWidget {
  /// Step hiện tại (1-based index)
  final int currentStep;

  /// Tổng số steps (default: 4)
  final int totalSteps;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Active color cho completed steps
  final Color activeColor;

  /// Inactive color cho uncompleted steps
  final Color inactiveColor;

  const OnboardingProgressIndicator({
    Key? key,
    required this.currentStep,
    this.totalSteps = 4,
    this.scaleFactor = 1.0,
    this.activeColor = const Color(0xFF36BFFA),
    this.inactiveColor = const Color(0xFF36BFFA),
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24)),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final stepNumber = index + 1;
          final isActive = stepNumber <= currentStep;

          return Expanded(
            child: Row(
              children: [
                // Progress step
                Expanded(
                  child: Container(
                    height: _scale(4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? activeColor
                          : inactiveColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(_scale(24)),
                    ),
                  ),
                ),

                // Spacing between steps (except last)
                if (index < totalSteps - 1) SizedBox(width: _scale(4)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
