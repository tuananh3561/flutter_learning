import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Màn hình Splash theo thiết kế Figma cho ứng dụng Story Nighty Night
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho logo
  late AnimationController _logoAnimationController;

  /// Animation controller cho dots
  late AnimationController _dotsAnimationController;

  /// Animation controller cho circles
  late AnimationController _circlesAnimationController;

  /// Animation cho logo fade in
  late Animation<double> _logoFadeAnimation;

  /// Animation cho logo scale
  late Animation<double> _logoScaleAnimation;

  /// Animation cho dots floating
  late Animation<double> _dotsFloatingAnimation;

  /// Animation cho circles rotation
  late Animation<double> _circlesRotationAnimation;

  @override
  void initState() {
    super.initState();

    // Thiết lập full screen cho splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _initializeAnimations();
    _startAnimationSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _dotsAnimationController.dispose();
    _circlesAnimationController.dispose();

    // Khôi phục system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  /// Khởi tạo các animations
  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Dots animation controller
    _dotsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Circles animation controller
    _circlesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    // Logo animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Dots floating animation
    _dotsFloatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsAnimationController,
      curve: Curves.easeInOut,
    ));

    // Circles rotation animation
    _circlesRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circlesAnimationController,
      curve: Curves.linear,
    ));
  }

  /// Bắt đầu chuỗi animations
  void _startAnimationSequence() async {
    // Bắt đầu circles animation
    _circlesAnimationController.repeat();

    // Bắt đầu dots animation
    _dotsAnimationController.repeat(reverse: true);

    // Đợi 300ms rồi bắt đầu logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoAnimationController.forward();

    // Đợi tổng cộng 3 giây rồi chuyển hướng
    await Future.delayed(const Duration(milliseconds: 2700));
    _navigateToNextScreen();
  }

  /// Chuyển hướng đến màn hình tiếp theo
  void _navigateToNextScreen() {
    if (mounted) {
      // Chuyển đến intro screen
      context.go('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background circles
            _buildBackgroundCircles(screenWidth, screenHeight),

            // Gradient dots
            _buildGradientDots(screenWidth, screenHeight),

            // Main logo
            _buildMainLogo(screenWidth, screenHeight),

            // Additional logos
            _buildAdditionalLogos(screenWidth, screenHeight),

            // Device ID text
            _buildDeviceIdText(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  /// Xây dựng background circles
  Widget _buildBackgroundCircles(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _circlesRotationAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Circle 1 - Outer
            Positioned(
              left: -screenWidth * 0.4,
              top: screenHeight * 0.05,
              child: Transform.rotate(
                angle: _circlesRotationAnimation.value * 2 * math.pi * 0.3,
                child: Container(
                  width: screenWidth * 1.8,
                  height: screenWidth * 1.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE6E8EC),
                      width: 1.w,
                    ),
                  ),
                ),
              ),
            ),

            // Circle 2 - Middle
            Positioned(
              left: -screenWidth * 0.2,
              top: screenHeight * 0.13,
              child: Transform.rotate(
                angle: -_circlesRotationAnimation.value * 2 * math.pi * 0.2,
                child: Container(
                  width: screenWidth * 1.4,
                  height: screenWidth * 1.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE6E8EC).withOpacity(0.5),
                      width: 1.w,
                    ),
                  ),
                ),
              ),
            ),

            // Circle 3 - Inner
            Positioned(
              left: screenWidth * 0.0,
              top: screenHeight * 0.21,
              child: Transform.rotate(
                angle: _circlesRotationAnimation.value * 2 * math.pi * 0.1,
                child: Container(
                  width: screenWidth * 1.0,
                  height: screenWidth * 1.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE6E8EC).withOpacity(0.5),
                      width: 1.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Xây dựng gradient dots
  Widget _buildGradientDots(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _dotsFloatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Gradient dot 1 - Orange
            Positioned(
              left: screenWidth * 0.78,
              top: screenHeight * 0.25 + (_dotsFloatingAnimation.value * 10.h),
              child: Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE2BC),
                      Color(0xFFFF965C),
                    ],
                  ),
                ),
              ),
            ),

            // Gradient dot 2 - Purple-Pink
            Positioned(
              left: screenWidth * 0.25,
              top: screenHeight * 0.13 + (_dotsFloatingAnimation.value * -5.h),
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8CDFF),
                      Color(0xFFFFB8BD),
                    ],
                  ),
                ),
              ),
            ),

            // Gradient dot 3 - Purple-Pink
            Positioned(
              left: screenWidth * 0.78,
              top: screenHeight * 0.73 + (_dotsFloatingAnimation.value * 8.h),
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8CDFF),
                      Color(0xFFFFB8BD),
                    ],
                  ),
                ),
              ),
            ),

            // Gradient dot 4 - Blue-Purple
            Positioned(
              left: screenWidth * 0.2,
              top: screenHeight * 0.64 + (_dotsFloatingAnimation.value * -12.h),
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFC3DBFF),
                      Color(0xFFA887EA),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Xây dựng logo chính
  Widget _buildMainLogo(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Positioned(
          left: screenWidth * 0.22,
          top: screenHeight * 0.35,
          child: FadeTransition(
            opacity: _logoFadeAnimation,
            child: ScaleTransition(
              scale: _logoScaleAnimation,
              child: Container(
                width: screenWidth * 0.57,
                height: screenHeight * 0.21,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash/main_logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng additional logos
  Widget _buildAdditionalLogos(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoFadeAnimation,
          child: Stack(
            children: [
              // KidSafe logo
              Positioned(
                left: screenWidth * 0.71,
                top: screenHeight * 0.086,
                child: Container(
                  width: screenWidth * 0.23,
                  height: screenHeight * 0.05,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/splash/kidsafe_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Secondary logo
              Positioned(
                left: screenWidth * 0.56,
                top: screenHeight * 0.085,
                child: Container(
                  width: screenWidth * 0.12,
                  height: screenHeight * 0.053,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/splash/secondary_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Xây dựng Device ID text
  Widget _buildDeviceIdText(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Positioned(
          left: screenWidth * 0.34,
          top: screenHeight * 0.92,
          child: FadeTransition(
            opacity: _logoFadeAnimation,
            child: SizedBox(
              width: screenWidth * 0.32,
              height: screenHeight * 0.026,
              child: Text(
                'Device ID: 100600',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                  color: const Color(0xFFAFAFAF),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
