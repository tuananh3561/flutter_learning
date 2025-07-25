import 'package:flutter/material.dart';

/// Widget item cho language option trong language selection screen
/// Hiển thị flag image, display text, language name và checkmark (nếu selected)
class LanguageOptionItem extends StatelessWidget {
  /// Language code (vi, en, th, ms)
  final String languageCode;

  /// Display text (ví dụ: "Chọn ngôn ngữ hiển thị")
  final String displayText;

  /// Language name (ví dụ: "Tiếng Việt")
  final String languageName;

  /// Có được chọn hay không
  final bool isSelected;

  /// Callback khi tap
  final VoidCallback? onTap;

  /// Scale factor cho responsive design
  final double scale;

  const LanguageOptionItem({
    Key? key,
    required this.languageCode,
    required this.displayText,
    required this.languageName,
    this.isSelected = false,
    this.onTap,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _scale(380),
        padding: EdgeInsets.fromLTRB(
          _scale(16),
          _scale(12),
          _scale(isSelected ? 20 : 16), // Selected có padding khác
          _scale(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FDFF) : Colors.white,
          border: Border.all(
            color:
                isSelected ? const Color(0xFF36BFFA) : const Color(0xFFE5E5E5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(_scale(12)),
        ),
        child: Row(
          children: [
            // Flag image - Figma: 70x50px
            Container(
              width: _scale(70),
              height: _scale(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_scale(4)),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_scale(2)),
                child: Image.asset(
                  _getFlagAssetPath(languageCode),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback nếu image không load được
                    return Container(
                      color: const Color(0xFFE5E5E5),
                      child: Icon(
                        Icons.flag,
                        size: _scale(24),
                        color: const Color(0xFFAFAFAF),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: _scale(20)),

            // Language text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display text - Figma: fontSize 14, Nunito-ExtraBold
                  Text(
                    displayText,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: _scale(14),
                      color: const Color(0xFFAFAFAF),
                      height: 1.5,
                    ),
                  ),

                  // Language name - Figma: fontSize 22, Nunito-Black
                  Text(
                    languageName,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: _scale(22),
                      color: const Color(0xFF4B4B4B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark - Figma: 24x24px, chỉ hiển thị khi selected
            if (isSelected) ...[
              SizedBox(width: _scale(8)),
              Container(
                width: _scale(24),
                height: _scale(24),
                child: Icon(
                  Icons.check,
                  size: _scale(16),
                  color: const Color(0xFF36BFFA),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Tính scaled value
  double _scale(double value) {
    return value * scale;
  }

  /// Lấy đường dẫn flag asset theo language code
  String _getFlagAssetPath(String code) {
    switch (code) {
      case 'vi':
        return 'assets/images/flags/flag_vietnam.png';
      case 'en':
        return 'assets/images/flags/flag_usa.png';
      case 'th':
        return 'assets/images/flags/flag_thailand.png';
      case 'ms':
        return 'assets/images/flags/flag_malaysia.png';
      default:
        return 'assets/images/flags/flag_vietnam.png';
    }
  }
}
