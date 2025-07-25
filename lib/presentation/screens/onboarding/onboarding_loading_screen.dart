import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

/// Màn hình loading onboarding theo thiết kế Figma
/// Kích thước base: 428x926px
class OnboardingLoadingScreen extends StatefulWidget {
  const OnboardingLoadingScreen({super.key});

  @override
  State<OnboardingLoadingScreen> createState() =>
      _OnboardingLoadingScreenState();
}

class _OnboardingLoadingScreenState extends State<OnboardingLoadingScreen>
    with TickerProviderStateMixin {
  // Thiết kế base từ Figma
  static const double _designWidth = 428.0;
  static const double _designHeight = 926.0;

  // Animation controllers
  late AnimationController _progressController;
  late AnimationController _checkItemsController;
  late Animation<double> _progressAnimation;
  late Animation<double> _checkItemsAnimation;

  // Loading progress
  double _currentProgress = 0.0;
  int _completedItems = 0;

  @override
  void initState() {
    super.initState();

    // Khởi tạo animation controllers
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _checkItemsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Khởi tạo animations
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _checkItemsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkItemsController,
      curve: Curves.easeInOut,
    ));

    // Bắt đầu loading animation
    _startLoadingAnimation();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _checkItemsController.dispose();
    super.dispose();
  }

  /// Bắt đầu animation loading
  void _startLoadingAnimation() {
    // Animate progress bar
    _progressController.addListener(() {
      setState(() {
        _currentProgress = _progressAnimation.value;
      });

      // Animate check items dựa trên progress
      final expectedCompletedItems = (_currentProgress * 3).floor();
      if (expectedCompletedItems != _completedItems) {
        _completedItems = expectedCompletedItems;
        _checkItemsController.forward();
      }
    });

    // Khi hoàn thành, chuyển sang màn hình tiếp theo
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // Complete onboarding and navigate to home
            context.go('/');
          }
        });
      }
    });

    // Bắt đầu animation sau 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive scaling
    final scaleX = screenWidth / _designWidth;
    final scaleY = screenHeight / _designHeight;
    final scale = math.min(scaleX, scaleY).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 43 * scale,
            vertical: 108 * scale,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tiêu đề
              _buildTitle(scale),

              SizedBox(height: 80 * scale),

              // Hình ảnh và progress bar
              _buildImageWithProgress(scale),

              SizedBox(height: 80 * scale),

              // Check items
              _buildCheckItems(scale),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng tiêu đề
  Widget _buildTitle(double scale) {
    return Text(
      'Monkey đang hoàn thiện hành trình học tập cho bé',
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w900,
        fontSize: 28 * scale,
        height: 1.2857142857142858,
        color: const Color(0xFF00AAFF),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Xây dựng hình ảnh với progress bar
  Widget _buildImageWithProgress(double scale) {
    return SizedBox(
      width: 308.02 * scale,
      height: 360 * scale,
      child: Stack(
        children: [
          // Hình ảnh character
          Positioned(
            left: 0,
            top: 0,
            child: Image.asset(
              'assets/images/onboarding/onboarding_loading_character.png',
              width: 308.02 * scale,
              height: 360 * scale,
              fit: BoxFit.cover,
            ),
          ),

          // Progress bar
          Positioned(
            left: 28.33 * scale,
            bottom: 18.85 * scale,
            child: _buildProgressBar(scale),
          ),
        ],
      ),
    );
  }

  /// Xây dựng progress bar
  Widget _buildProgressBar(double scale) {
    return Column(
      children: [
        // Progress bar background
        Container(
          width: 252.68 * scale,
          height: 11.62 * scale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.688995361328125 * scale),
          ),
          child: Stack(
            children: [
              // Progress fill
              Container(
                width: (252.68 * _currentProgress) * scale,
                height: 11.62 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF82D9FF),
                  borderRadius:
                      BorderRadius.circular(24.688995361328125 * scale),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 17.43 * scale),

        // Progress text
        Text(
          '${(_currentProgress * 100).toInt()}%',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 17.427526473999023 * scale,
            height: 1.4999999452777009,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Xây dựng check items
  Widget _buildCheckItems(double scale) {
    final checkItems = [
      '1300+ truyện tranh tương tác',
      '2400+ trò chơi, video vui nhộn',
      '200+ sách nói chuẩn Anh-Mỹ',
    ];

    return Column(
      children: checkItems.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final isCompleted = index < _completedItems;

        return AnimatedBuilder(
          animation: _checkItemsAnimation,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: isCompleted ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.749999046325684 * scale),
                child: Row(
                  children: [
                    // Check icon
                    _buildCheckIcon(scale, isCompleted),

                    SizedBox(width: 12 * scale),

                    // Text
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 16 * scale,
                          height: 1.5,
                          color: const Color(0xFF36BFFA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// Xây dựng check icon
  Widget _buildCheckIcon(double scale, bool isCompleted) {
    return Container(
      width: 24 * scale,
      height: 24 * scale,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: AnimatedScale(
        scale: isCompleted ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isCompleted ? Icons.check : Icons.radio_button_unchecked,
          color: const Color(0xFF36BFFA),
          size: 16 * scale,
        ),
      ),
    );
  }
}
