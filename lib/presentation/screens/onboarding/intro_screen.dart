import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:math';
import '../../common/buttom/language_button.dart';
import '../../common/buttom/custom_button.dart';
import '../../common/buttom/custom_link.dart';

/// Màn hình Intro theo thiết kế Figma cho ứng dụng Story Nighty Night
/// Design base: 428x926px
class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  /// Animation controller cho background
  late AnimationController _backgroundController;

  /// Animation controller cho content
  late AnimationController _contentController;

  /// Animation cho background fade
  late Animation<double> _backgroundFadeAnimation;

  /// Animation cho content slide up
  late Animation<Offset> _contentSlideAnimation;

  /// Animation cho content fade
  late Animation<double> _contentFadeAnimation;

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
    _backgroundController.dispose();
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
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeInOut,
    ));
  }

  /// Bắt đầu chuỗi animations
  void _startAnimationSequence() async {
    // Bắt đầu background animation
    _backgroundController.forward();

    // Đợi 400ms rồi bắt đầu content animation
    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scaleFactor = _getScaleFactor(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background mosaic - full screen
            _buildBackgroundMosaic(context),

            // Main responsive content
            _buildMainContent(context),

            // Language button - positioned absolute
            PositionedLanguageButton(
              scale: _getScaleFactor(context),
              rightPosition: 24,
              topPadding: 65,
              onTap: () => context.go('/language-selection'),
            )
          ],
        ),
      ),
    );
  }

  /// Xây dựng background mosaic toàn màn hình
  Widget _buildBackgroundMosaic(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundFadeAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Opacity(
            opacity: _backgroundFadeAnimation.value,
            child: Stack(
              children: [
                // Background blur overlay - dựa theo Figma positioning
                Positioned(
                  left: _scale(-289, context),
                  top: _scale(-23, context),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 330),
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.87,
                        child: Image.asset(
                          'assets/images/intro_header.png',
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng main content responsive
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _contentController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _contentFadeAnimation,
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    // Figma padding: x=24, từ frame 341.83px từ top
                    padding: EdgeInsets.fromLTRB(
                      _scale(24, context),
                      _scale(341.83 - 341.83 * 0.6, context), // Điều chỉnh top
                      _scale(24, context),
                      _scale(24, context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        _buildTitle(context),

                        SizedBox(height: _scale(12, context)),

                        // Description
                        _buildDescription(context),

                        SizedBox(height: _scale(24, context)),

                        // Statistics box
                        _buildStatisticsBox(context),

                        SizedBox(height: _scale(24, context)),

                        // Buttons
                        _buildButtons(context),

                        // Bottom spacing
                        SizedBox(height: _scale(40, context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng title - Figma: fontSize 32, Nunito-ExtraBold
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Top 1 ứng dụng giúp con giỏi tiếng Anh chuẩn Mỹ trước 10 tuổi',
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w800,
        fontSize: _scale(32, context),
        color: const Color(0xFF00BBFF),
        height: 1.1875, // Figma line height
      ),
    );
  }

  /// Xây dựng description - Figma: fontSize 16, Nunito-Bold
  Widget _buildDescription(BuildContext context) {
    return SizedBox(
      height: _scale(48, context), // Figma fixed height
      child: Text(
        'Học qua 1300+ truyện tranh tương tác, 200+ sách nói – Nghe, nói, đọc, viết toàn diện.',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
          fontSize: _scale(16, context),
          color: const Color(0xFF63676A),
          height: 1.5, // Figma line height
        ),
      ),
    );
  }

  /// Xây dựng statistics box - Figma padding: 12.77px, gap: 22.7px
  Widget _buildStatisticsBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_scale(12.77, context)),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FCFF),
        borderRadius: BorderRadius.circular(_scale(12, context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Statistics icons - Figma: 29.58 x 60.58px each
          Row(
            children: [
              _buildStatIcon(context),
              SizedBox(width: _scale(22.7, context)),
              _buildStatIcon(context),
            ],
          ),

          SizedBox(width: _scale(22.7, context)),

          // Statistics text - Figma: Montserrat-SemiBold, 12px
          Flexible(
            child: Text(
              '10 triệu phụ huynh\ntin dùng',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: _scale(12, context),
                color: const Color(0xFF1DC7F4),
                height: 1.67, // Figma line height
                letterSpacing: _scale(-0.13, context),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(width: _scale(22.7, context)),

          // Testimonial image - Figma: 147.38 x 49.6px
          Flexible(
            child: Container(
              width: _scale(147.38, context),
              height: _scale(49.6, context),
              constraints: BoxConstraints(
                maxWidth: _scale(147.38, context),
                minWidth: _scale(100, context),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_scale(8, context)),
                image: const DecorationImage(
                  image:
                      AssetImage('assets/images/intro/testimonial_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng statistics icon - Figma: 29.58 x 60.58px
  Widget _buildStatIcon(BuildContext context) {
    return Container(
      width: _scale(29.58, context),
      height: _scale(60.58, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(4, context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Star pattern theo Figma design
          Icon(
            Icons.star,
            size: _scale(8, context),
            color: const Color(0xFFA7ECFF),
          ),
          SizedBox(height: _scale(2, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: _scale(6, context),
                color: const Color(0xFFA7ECFF),
              ),
              SizedBox(width: _scale(2, context)),
              Icon(
                Icons.star,
                size: _scale(6, context),
                color: const Color(0xFFA7ECFF),
              ),
            ],
          ),
          SizedBox(height: _scale(2, context)),
          Icon(
            Icons.star,
            size: _scale(8, context),
            color: const Color(0xFFA7ECFF),
          ),
        ],
      ),
    );
  }

  /// Xây dựng buttons - Figma: padding 14x24, gap 12, fontSize 20
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Primary button - Figma specifications
        CustomButton(
          text: 'Bắt đầu học thử',
          onPressed: () => context.go('/onboarding-start'),
          type: ButtonType.primary,
          size: ButtonSize.xl,
          customScale: _getScaleFactor(context),
        ),

        SizedBox(height: _scale(16, context)),

        // Secondary button - Figma specifications
        CustomButton(
          text: 'Đăng nhập',
          onPressed: () => context.go('/sign-in'),
          type: ButtonType.secondary,
          size: ButtonSize.xl,
          customScale: _getScaleFactor(context),
        ),

        SizedBox(height: _scale(16, context)),

        // Activation code link - Figma: fontSize 18, Nunito-ExtraBold
        CustomLink(
          text: 'Nhập mã kích hoạt',
          scale: _getScaleFactor(context),
          onTap: () => _showActivationCodeDialog(),
        ),
      ],
    );
  }

  /// Navigate đến màn hình activation
  void _showActivationCodeDialog() {
    context.go('/activation?source=intro');
  }
}

// Type alias for ImageFilter
typedef ImageFilter = ui.ImageFilter;
