import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../common/buttom/custom_button.dart';

/// Màn hình bắt đầu onboarding với AI Max character
/// Design base: 428x926px từ Figma
class OnboardingStartScreen extends StatefulWidget {
  const OnboardingStartScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingStartScreen> createState() => _OnboardingStartScreenState();
}

class _OnboardingStartScreenState extends State<OnboardingStartScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho character
  late AnimationController _characterController;

  /// Animation controller cho speech bubble
  late AnimationController _speechController;

  /// Animation cho character entrance
  late Animation<double> _characterScaleAnimation;
  late Animation<Offset> _characterSlideAnimation;

  /// Animation cho speech bubble
  late Animation<double> _speechFadeAnimation;
  late Animation<double> _speechScaleAnimation;

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
    _characterController.dispose();
    _speechController.dispose();
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
    _characterController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _speechController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _characterScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.elasticOut,
    ));

    _characterSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeOutCubic,
    ));

    _speechFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _speechController,
      curve: Curves.easeInOut,
    ));

    _speechScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _speechController,
      curve: Curves.easeOutBack,
    ));
  }

  /// Bắt đầu chuỗi animations
  void _startAnimationSequence() async {
    // Bắt đầu character animation
    _characterController.forward();

    // Đợi 600ms rồi bắt đầu speech animation
    await Future.delayed(const Duration(milliseconds: 600));
    _speechController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Main content
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  /// Xây dựng main content
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _scale(24, context)),
        child: Column(
          children: [
            // Top spacing
            SizedBox(height: _scale(40, context)),

            // Speech bubble - Figma: Frame 48097291 at (24, 252)
            _buildSpeechBubble(context),

            // Spacing between speech and character
            SizedBox(height: _scale(16, context)),

            // AI Max character - Figma: Asset 111@3x-8 at (138, 376)
            Expanded(
              child: _buildCharacter(context),
            ),

            // Continue button - Figma: Button at (24, 802)
            _buildContinueButton(context),

            // Bottom spacing
            SizedBox(height: _scale(40, context)),
          ],
        ),
      ),
    );
  }

  /// Xây dựng speech bubble - Figma: 379x108px
  Widget _buildSpeechBubble(BuildContext context) {
    return AnimatedBuilder(
      animation: _speechController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _speechFadeAnimation,
          child: ScaleTransition(
            scale: _speechScaleAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(_scale(12, context)),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(_scale(12, context)),
                border: Border.all(
                  color: const Color(0xFFECECED),
                  width: _scale(1, context),
                ),
              ),
              child: Stack(
                children: [
                  // Speech bubble content
                  Padding(
                    padding: EdgeInsets.only(bottom: _scale(8, context)),
                    child: Text(
                      'AI Max đã sẵn sàng đồng hành cùng bé trên hành trình chinh phục tiếng Anh!',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: _scale(18, context),
                        color: const Color(0xFF333741),
                        height: 1.67,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Speech bubble tail - Figma: Polygon at bottom
                  Positioned(
                    bottom: _scale(-8, context),
                    left: _scale(24, context),
                    child: CustomPaint(
                      size:
                          Size(_scale(21.65, context), _scale(18.75, context)),
                      painter: SpeechBubbleTailPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng AI Max character - Figma: 152x174px
  Widget _buildCharacter(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterController,
      builder: (context, child) {
        return SlideTransition(
          position: _characterSlideAnimation,
          child: ScaleTransition(
            scale: _characterScaleAnimation,
            child: Center(
              child: Container(
                width: _scale(152, context),
                height: _scale(174, context),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/onboarding/ai_max_character.png'),
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

  /// Xây dựng continue button - Figma: 380x60px
  Widget _buildContinueButton(BuildContext context) {
    return CustomButton(
      text: 'Tiếp tục',
      type: ButtonType.primary,
      size: ButtonSize.xl,
      customScale: _getScaleFactor(context),
      onPressed: () {
        // Navigate to Select Age screen
        context.push('/onboarding/select-age');
      },
    );
  }
}

/// Custom painter cho speech bubble tail
class SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Tạo hình tam giác cho tail của speech bubble
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
