import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../../data/models/onboarding_data.dart';
import '../../common/app_header.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/onboarding_progress_indicator.dart';

/// Màn hình chọn tuổi trong quy trình onboarding
/// Design base: 428x926px từ Figma
class SelectAgeScreen extends StatefulWidget {
  const SelectAgeScreen({Key? key}) : super(key: key);

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho content
  late AnimationController _contentController;

  /// Animation cho content fade in
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  /// Figma design base dimensions
  static const double _designWidth = 428.0;
  static const double _designHeight = 926.0;

  /// Selected year
  int? _selectedYear;

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
              currentStep: 2,
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
                    // Header section - Figma: Frame 1964
                    _buildHeader(context),

                    SizedBox(height: _scale(24, context)),

                    // Year selection grid - Figma: Frame 2120
                    _buildYearSelection(context),

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
            'Bé sinh vào năm nào?',
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

  /// Xây dựng year selection grid
  Widget _buildYearSelection(BuildContext context) {
    final years = YearOfBirth.getYearList();

    return Wrap(
      spacing: _scale(12, context),
      runSpacing: _scale(12, context),
      children: [
        // Year buttons
        ...years.map((year) => _buildYearButton(context, year)),

        // "Before year" button
        _buildBeforeYearButton(context),
      ],
    );
  }

  /// Xây dựng year button - Figma: 86x72px
  Widget _buildYearButton(BuildContext context, int year) {
    final isSelected = _selectedYear == year;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedYear = year;
        });
      },
      child: Container(
        width: _scale(86, context),
        height: _scale(72, context),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDF9FF) : Colors.white,
          borderRadius: BorderRadius.circular(_scale(12, context)),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF36BFFA) : const Color(0xFFE5E5E5),
            width: _scale(2, context),
          ),
        ),
        child: Center(
          child: Text(
            year.toString(),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              fontSize: _scale(20, context),
              color: isSelected
                  ? const Color(0xFF36BFFA)
                  : const Color(0xFF777777),
              height: 1.36,
            ),
          ),
        ),
      ),
    );
  }

  /// Xây dựng "before year" button - Figma: 380x72px
  Widget _buildBeforeYearButton(BuildContext context) {
    final isSelected = _selectedYear == -1; // Special value for "before year"

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedYear = -1;
        });
      },
      child: Container(
        width: double.infinity,
        height: _scale(72, context),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDF9FF) : Colors.white,
          borderRadius: BorderRadius.circular(_scale(12, context)),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF36BFFA) : const Color(0xFFE5E5E5),
            width: _scale(2, context),
          ),
        ),
        child: Center(
          child: Text(
            YearOfBirth.getBeforeYearText(),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              fontSize: _scale(20, context),
              color: isSelected
                  ? const Color(0xFF36BFFA)
                  : const Color(0xFF777777),
              height: 1.36,
            ),
          ),
        ),
      ),
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
        enabled: _selectedYear != null,
        onPressed: _selectedYear != null
            ? () {
                // Navigate to Select Level screen
                context.push('/onboarding/select-level');
              }
            : null,
      ),
    );
  }
}
