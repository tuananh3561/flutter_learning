import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../core/providers/language_provider.dart';
import '../../common/item/language_option_item.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/app_header.dart';

/// Màn hình chọn ngôn ngữ theo thiết kế Figma
/// Design base: 428x926px
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  /// Figma design base dimensions
  static const double _designWidth = 428.0;
  static const double _designHeight = 926.0;

  /// Selected language index
  int _selectedLanguageIndex = 0;

  /// Flag để track initial sync
  bool _hasInitialSynced = false;

  /// Language data models
  late final List<LanguageData> _languages;

  @override
  void initState() {
    super.initState();

    // Setup system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    // Initialize languages and current selection
    _initializeLanguages();
  }

  /// Khởi tạo danh sách ngôn ngữ và selected index hiện tại
  void _initializeLanguages() {
    _languages = [
      LanguageData(
        code: 'vi',
        displayText: 'Chọn ngôn ngữ hiển thị',
        languageName: 'Tiếng Việt',
      ),
      LanguageData(
        code: 'en',
        displayText: 'Select display language',
        languageName: 'English (US)',
      ),
      LanguageData(
        code: 'th',
        displayText: 'เลือกภาษาที่แสดง',
        languageName: 'ไทย',
      ),
      LanguageData(
        code: 'ms',
        displayText: 'Pilih bahasa paparan',
        languageName: 'Malaysia',
      ),
    ];

    // Set default selection to Vietnamese (index 0)
    // Note: Sẽ được update trong build() method từ LanguageProvider
    _selectedLanguageIndex = 0;
  }

  /// Tính toán scale factor dựa trên design width
  double _getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / _designWidth;
    return max(0.8, min(scaleFactor, 1.8));
  }

  /// Tính scaled value
  double _scale(double value, BuildContext context) {
    return value * _getScaleFactor(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        // Chỉ sync initial selection khi LanguageProvider đã load xong
        if (!_hasInitialSynced && languageProvider.isLoaded) {
          final currentLanguageCode =
              languageProvider.currentLocale.languageCode;
          final currentIndex = _languages.indexWhere(
            (lang) => lang.code == currentLanguageCode,
          );
          if (currentIndex != -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedLanguageIndex = currentIndex;
                _hasInitialSynced = true;
              });
            });
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: languageProvider.isLoaded
                ? Stack(
                    children: [
                      // Main content
                      _buildMainContent(context),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF36BFFA),
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Xây dựng main content
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header with back button and title
          AppHeader(
            title: 'Cài đặt ngôn ngữ',
            scaleFactor: _getScaleFactor(context),
          ),

          SizedBox(height: _scale(24, context)),

          // Language list
          Expanded(
            child: SingleChildScrollView(
              child: _buildLanguageList(context),
            ),
          ),

          // Continue button
          _buildContinueButton(context),

          SizedBox(height: _scale(24, context)),
        ],
      ),
    );
  }

  /// Xây dựng danh sách ngôn ngữ - Figma: x=24, y=111, gap=16px
  Widget _buildLanguageList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
      child: Column(
        children: List.generate(_languages.length, (index) {
          return Column(
            children: [
              _buildLanguageOption(context, index),
              if (index < _languages.length - 1)
                SizedBox(height: _scale(16, context)),
            ],
          );
        }),
      ),
    );
  }

  /// Xây dựng option ngôn ngữ - Figma: width=380px
  Widget _buildLanguageOption(BuildContext context, int index) {
    final language = _languages[index];
    final isSelected = index == _selectedLanguageIndex;

    return LanguageOptionItem(
      languageCode: language.code,
      displayText: language.displayText,
      languageName: language.languageName,
      isSelected: isSelected,
      scale: _getScaleFactor(context),
      onTap: () => setState(() => _selectedLanguageIndex = index),
    );
  }

  /// Xây dựng continue button - Figma: x=23, y=802, width=380px
  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(23, context)),
      child: CustomButton(
        text: 'Tiếp tục',
        type: ButtonType.primary,
        size: ButtonSize.xl,
        customScale: _getScaleFactor(context),
        onPressed: () async {
          // Lưu language được chọn
          final selectedLanguage = _languages[_selectedLanguageIndex];

          // Cập nhật language provider
          final languageProvider =
              Provider.of<LanguageProvider>(context, listen: false);

          await languageProvider.changeLanguage(Locale(selectedLanguage.code));

          // Safe navigation back to intro screen
          if (mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/intro');
            }
          }
        },
      ),
    );
  }
}

/// Model cho language data
class LanguageData {
  final String code;
  final String displayText;
  final String languageName;

  LanguageData({
    required this.code,
    required this.displayText,
    required this.languageName,
  });
}
