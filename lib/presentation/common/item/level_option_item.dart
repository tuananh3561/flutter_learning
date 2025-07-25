import 'package:flutter/material.dart';
import '../../../data/models/onboarding_data.dart';

/// Level Option Item component có thể tái sử dụng
/// Hiển thị level với progress bars và selection state
class LevelOptionItem extends StatelessWidget {
  /// Language level data
  final LanguageLevel level;

  /// Có được selected hay không
  final bool isSelected;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Callback khi item được tap
  final VoidCallback? onTap;

  const LevelOptionItem({
    Key? key,
    required this.level,
    required this.isSelected,
    this.scaleFactor = 1.0,
    this.onTap,
  }) : super(key: key);

  /// Tính scaled value
  double _scale(double value) {
    return value * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: _scale(72),
        padding: EdgeInsets.symmetric(
          horizontal: _scale(20),
          vertical: _scale(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FDFF) : Colors.white,
          borderRadius: BorderRadius.circular(_scale(12)),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF36BFFA) : const Color(0xFFE5E5E5),
            width: _scale(2),
          ),
        ),
        child: Row(
          children: [
            // Progress bars - Figma: Frame 1965
            _buildProgressBars(),

            SizedBox(width: _scale(24)),

            // Level text
            Expanded(
              child: Text(
                level.title,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: _scale(16),
                  color: isSelected
                      ? const Color(0xFF36BFFA)
                      : const Color(0xFF4B4B4B),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng progress bars cho level
  Widget _buildProgressBars() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < level.progressBars;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: _scale(2)),
          child: Container(
            width: _scale(28),
            height: _scale(10),
            decoration: BoxDecoration(
              color: isActive
                  ? (isSelected
                      ? const Color(0xFF36BFFA)
                      : const Color(0xFFD2F1FF))
                  : const Color(0xFFD2F1FF),
              borderRadius: BorderRadius.circular(_scale(3)),
            ),
          ),
        );
      }),
    );
  }
}
