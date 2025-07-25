import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../../data/models/onboarding_data.dart';
import '../../common/app_header.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/onboarding_progress_indicator.dart';

/// Màn hình xác nhận đề xuất lộ trình học trong quy trình onboarding
/// Design base: 428x926px từ Figma
class ConfirmRouteScreen extends StatefulWidget {
  const ConfirmRouteScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmRouteScreen> createState() => _ConfirmRouteScreenState();
}

class _ConfirmRouteScreenState extends State<ConfirmRouteScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho content
  late AnimationController _contentController;

  /// Animation controller cho monkey
  late AnimationController _monkeyController;

  /// Animation cho content fade in
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  /// Animation cho monkey bounce
  late Animation<double> _monkeyBounceAnimation;

  /// Figma design base dimensions
  static const double _designWidth = 428.0;
  static const double _designHeight = 926.0;

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
    _monkeyController.dispose();
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

    _monkeyController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _monkeyBounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _monkeyController,
      curve: Curves.elasticInOut,
    ));
  }

  /// Bắt đầu chuỗi animations
  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _contentController.forward();

    // Repeat monkey animation
    _monkeyController.repeat(reverse: true);
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
              currentStep: 4,
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
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: SlideTransition(
            position: _contentSlideAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header text
                  _buildHeaderText(context),

                  SizedBox(height: _scale(12, context)),

                  // Description text
                  _buildDescriptionText(context),

                  SizedBox(height: _scale(40, context)),

                  // Route visualization
                  _buildRouteVisualization(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng header text
  Widget _buildHeaderText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
      child: Text(
        'Monkey đã chọn cho bé\nChặng 1 - Khởi động',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          fontSize: _scale(24, context),
          color: const Color(0xFF00AAFF),
          height: 1.33,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Xây dựng description text
  Widget _buildDescriptionText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
      child: Text(
        'Chặng 1 dành cho trẻ mới làm quen với tiếng Anh hoặc biết một số từ vựng cơ bản.',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
          fontSize: _scale(16, context),
          color: const Color(0xFF85888E),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Xây dựng route visualization
  Widget _buildRouteVisualization(BuildContext context) {
    return Stack(
      children: [
        // Route progress bars
        _buildRouteProgress(context),

        // Monkey character
        _buildMonkeyCharacter(context),
      ],
    );
  }

  /// Xây dựng route progress bars
  Widget _buildRouteProgress(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Stage 1 - Khởi động (Active)
          _buildStageColumn(context, LearningRoute.starter, true),

          SizedBox(width: _scale(12, context)),

          // Stage 2 - Tăng tốc (Inactive)
          _buildStageColumn(context, LearningRoute.accelerate, false),

          SizedBox(width: _scale(12, context)),

          // Stage 3 - Vững vàng (Inactive)
          _buildStageColumn(context, LearningRoute.strengthen, false),

          SizedBox(width: _scale(12, context)),

          // Stage 4 - Chinh phục (Inactive)
          _buildStageColumn(context, LearningRoute.conquer, false),
        ],
      ),
    );
  }

  /// Xây dựng stage column
  Widget _buildStageColumn(
      BuildContext context, LearningRoute route, bool isActive) {
    final height = _getStageHeight(route);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Stage number badge
        Container(
          width: _scale(24, context),
          height: _scale(24, context),
          decoration: BoxDecoration(
            color: isActive ? Color(route.color) : const Color(0xFF63D3FF),
            borderRadius: BorderRadius.circular(_scale(4, context)),
          ),
          child: Center(
            child: Text(
              _getStageNumber(route).toString(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: _scale(16, context),
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: _scale(12, context)),

        // Stage title
        Text(
          route.subtitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
            fontSize: _scale(isActive ? 16 : 12, context),
            color: isActive ? const Color(0xFFFFA614) : const Color(0xFF89DEFF),
            height: isActive ? 1.375 : 1.83,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: _scale(12, context)),

        // Progress bar
        Container(
          width: _scale(80, context),
          height: _scale(height, context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(route.color),
                Colors.white.withOpacity(0),
              ],
              stops: const [0.2, 1.0],
            ),
            borderRadius: BorderRadius.circular(_scale(4, context)),
          ),
        ),
      ],
    );
  }

  /// Lấy chiều cao cho từng stage
  double _getStageHeight(LearningRoute route) {
    switch (route) {
      case LearningRoute.starter:
        return 120.0; // Active stage
      case LearningRoute.accelerate:
        return 180.0;
      case LearningRoute.strengthen:
        return 240.0;
      case LearningRoute.conquer:
        return 300.0;
    }
  }

  /// Lấy số thứ tự stage
  int _getStageNumber(LearningRoute route) {
    switch (route) {
      case LearningRoute.starter:
        return 1;
      case LearningRoute.accelerate:
        return 2;
      case LearningRoute.strengthen:
        return 3;
      case LearningRoute.conquer:
        return 4;
    }
  }

  /// Xây dựng monkey character - sử dụng placeholder vì complex illustration
  Widget _buildMonkeyCharacter(BuildContext context) {
    return Positioned(
      right: _scale(24, context),
      bottom: _scale(60, context),
      child: AnimatedBuilder(
        animation: _monkeyBounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _monkeyBounceAnimation.value,
            child: Container(
              width: _scale(121, context),
              height: _scale(120, context),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA614).withOpacity(0.2),
                borderRadius: BorderRadius.circular(_scale(60, context)),
              ),
              child: Icon(
                Icons.emoji_emotions,
                size: _scale(60, context),
                color: const Color(0xFFFFA614),
              ),
            ),
          );
        },
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
        onPressed: () {
          // Navigate to onboarding loading screen
          context.go('/onboarding-loading');
        },
      ),
    );
  }
}
