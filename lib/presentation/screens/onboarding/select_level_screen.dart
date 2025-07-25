import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../../data/models/onboarding_data.dart';
import '../../common/app_header.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/item/level_option_item.dart';
import '../../common/onboarding_progress_indicator.dart';

/// Màn hình chọn cấp độ tiếng Anh trong quy trình onboarding
/// Design base: 428x926px từ Figma
class SelectLevelScreen extends StatefulWidget {
  const SelectLevelScreen({Key? key}) : super(key: key);

  @override
  State<SelectLevelScreen> createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho content
  late AnimationController _contentController;

  /// Animation cho content fade in
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  /// Figma design base dimensions
  static const double _designWidth = 428.0;
  static const double _designHeight = 926.0;

  /// Selected level
  LanguageLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();

    // Khôi phục system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    _initializeAnimations();
    _startAnimationSequence();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  /// Tính toán scale factor dựa trên design width
  double _getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / _designWidth;

    // Giới hạn scale factor trong khoảng hợp lý
    return max(0.8, min(scaleFactor, 1.8));
  }

  /// Tính scaled value
  double _scale(double value, BuildContext context) {
    return value * _getScaleFactor(context);
  }

  /// Khởi tạo các animations
  void _initializeAnimations() {
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeInOut,
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
  }

  /// Bắt đầu chuỗi animations
  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _contentController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            AppHeader(
              title: '', // No title for this screen
              scaleFactor: _getScaleFactor(context),
              height: 52, // Reduced height since no title
            ),

            SizedBox(height: _scale(16, context)),

            // Progress indicators
            OnboardingProgressIndicator(
              currentStep: 3,
              scaleFactor: _getScaleFactor(context),
            ),

            SizedBox(height: _scale(16, context)),

            // Main content
            Expanded(
              child: _buildMainContent(context),
            ),

            // Continue button
            _buildContinueButton(context),

            SizedBox(height: _scale(40, context)),
          ],
        ),
      ),
    );
  }

  /// Xây dựng main content
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
      child: AnimatedBuilder(
        animation: _contentController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _contentFadeAnimation,
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeader(context),

                    SizedBox(height: _scale(24, context)),

                    // Level selection
                    _buildLevelSelection(context),

                    SizedBox(height: _scale(24, context)),

                    // Note text
                    _buildNoteText(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng header section
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Monkey character - Figma: Asset 3@4x, 148x168px
        Container(
          width: _scale(148, context),
          height: _scale(168, context),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/onboarding/monkey_age_character.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(width: _scale(23, context)),

        // Title text
        Expanded(
          child: Text(
            'Khả năng tiếng Anh hiện tại của bé?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: _scale(24, context),
              color: const Color(0xFF4B4B4B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Xây dựng level selection
  Widget _buildLevelSelection(BuildContext context) {
    return Column(
      children: LanguageLevel.values
          .map(
            (level) => Padding(
              padding: EdgeInsets.only(bottom: _scale(12, context)),
              child: LevelOptionItem(
                level: level,
                isSelected: _selectedLevel == level,
                scaleFactor: _getScaleFactor(context),
                onTap: () {
                  setState(() {
                    _selectedLevel = level;
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }

  /// Xây dựng note text
  Widget _buildNoteText(BuildContext context) {
    return Center(
      child: Text(
        '*Cá nhân hóa Monkey Stories để phù hợp\nvới độ tuổi của bé',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: _scale(14, context),
          color: const Color(0xFF63676A),
          height: 1.57,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Xây dựng continue button
  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(23, context)),
      child: CustomButton(
        text: 'Tiếp tục',
        type: ButtonType.primary,
        size: ButtonSize.xl,
        customScale: _getScaleFactor(context),
        enabled: _selectedLevel != null,
        onPressed: _selectedLevel != null
            ? () {
                // Navigate to Confirm Route screen
                context.push('/onboarding/confirm-route');
              }
            : null,
      ),
    );
  }
}
