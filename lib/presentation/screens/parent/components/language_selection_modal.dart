import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_learning/data/models/app_settings_data.dart';

/// Language Selection Modal Bottom Sheet
class LanguageSelectionModal extends StatefulWidget {
  final String selectedLanguageCode;
  final List<LanguageOption> availableLanguages;
  final Function(LanguageOption) onLanguageSelected;

  const LanguageSelectionModal({
    super.key,
    required this.selectedLanguageCode,
    required this.availableLanguages,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageSelectionModal> createState() => _LanguageSelectionModalState();
}

class _LanguageSelectionModalState extends State<LanguageSelectionModal> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.selectedLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x464px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Container(
      width: 428 * scale,
      height: 464 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20 * scale),
          topRight: Radius.circular(20 * scale),
        ),
      ),
      child: Column(
        children: [
          // Title
          _buildTitle(scale),

          // Divider
          _buildDivider(scale),

          // Language list
          _buildLanguageList(scale),

          // Bottom home indicator
          _buildBottomHomeIndicator(scale),
        ],
      ),
    );
  }

  /// Build title
  Widget _buildTitle(double scale) {
    return Container(
      width: 248 * scale,
      height: 36 * scale,
      margin: EdgeInsets.only(top: 32 * scale),
      child: Text(
        'NGÔN NGỮ HIỂN THỊ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          fontSize: 24 * scale,
          height: 1.5,
          color: Color(0xFF4B4B4B),
        ),
      ),
    );
  }

  /// Build divider
  Widget _buildDivider(double scale) {
    return Container(
      width: 428 * scale,
      height: 1 * scale,
      margin: EdgeInsets.only(top: 16 * scale),
      color: Color(0xFFE5E5E5),
    );
  }

  /// Build language list
  Widget _buildLanguageList(double scale) {
    return Container(
      width: 378 * scale,
      margin: EdgeInsets.only(
        top: 24 * scale,
        left: 25 * scale,
        right: 25 * scale,
      ),
      child: Column(
        children: widget.availableLanguages.map((language) {
          return Container(
            margin: EdgeInsets.only(bottom: 12 * scale),
            child: _buildLanguageItem(scale, language),
          );
        }).toList(),
      ),
    );
  }

  /// Build individual language item
  Widget _buildLanguageItem(double scale, LanguageOption language) {
    final isSelected = _selectedLanguageCode == language.code;

    return GestureDetector(
      onTap: () => _onLanguageSelected(language),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE5E5E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(4 * scale),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 12 * scale,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flag and name
            Row(
              children: [
                // Flag
                Container(
                  width: 45 * scale,
                  height: 32 * scale,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2 * scale,
                    ),
                    borderRadius: BorderRadius.circular(4 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 4 * scale),
                        blurRadius: 16 * scale,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4 * scale),
                    child: Image.asset(
                      language.flagAsset,
                      width: 45 * scale,
                      height: 32 * scale,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 16 * scale),

                // Language name
                Text(
                  language.name,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16 * scale,
                    height: 1.5,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),

            // Check icon
            Container(
              width: 24 * scale,
              height: 24 * scale,
              child: isSelected
                  ? SvgPicture.asset(
                      'assets/images/parent/check_icon.svg',
                      width: 24 * scale,
                      height: 24 * scale,
                      colorFilter: ColorFilter.mode(
                        Color(0xFF92C73D),
                        BlendMode.srcIn,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFAFAFAF),
                          width: 1 * scale,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom home indicator
  Widget _buildBottomHomeIndicator(double scale) {
    return Container(
      width: 428 * scale,
      height: 34 * scale,
      margin: EdgeInsets.only(top: 24 * scale),
      child: Center(
        child: Container(
          width: 134 * scale,
          height: 5 * scale,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100 * scale),
          ),
        ),
      ),
    );
  }

  /// Handle language selection
  void _onLanguageSelected(LanguageOption language) {
    setState(() {
      _selectedLanguageCode = language.code;
    });

    // Call callback with selected language
    widget.onLanguageSelected(language);

    // Close modal after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}

/// Show language selection modal
void showLanguageSelectionModal(
  BuildContext context, {
  required String selectedLanguageCode,
  required List<LanguageOption> availableLanguages,
  required Function(LanguageOption) onLanguageSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => LanguageSelectionModal(
      selectedLanguageCode: selectedLanguageCode,
      availableLanguages: availableLanguages,
      onLanguageSelected: onLanguageSelected,
    ),
  );
}
