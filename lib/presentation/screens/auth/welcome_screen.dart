import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/auth/auth_screen_layout.dart';
import '../../common/auth/auth_title.dart';
import '../../common/buttom/custom_button.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/services/lottie_utils.dart';
import 'package:lottie/lottie.dart';

/// Welcome screen after successful sign up
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _characterController;
  late AnimationController _fireworkController;
  late Animation<double> _characterAnimation;
  late Animation<double> _fireworkAnimation;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();

    // Character animation
    _characterController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Firework animation
    _fireworkController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _characterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.elasticOut,
    ));

    _fireworkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fireworkController,
      curve: Curves.easeOut,
    ));

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _characterController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fireworkController.forward();
    });
  }

  @override
  void dispose() {
    _characterController.dispose();
    _fireworkController.dispose();
    super.dispose();
  }

  void _onContinue() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = AuthScreenLayout.getScaleFactor(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.lg,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chào mừng bạn đến Monkey Stories',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  // if (descriptionWidget != null) descriptionWidget!,
                  const SizedBox(height: 80),
                  Transform.scale(
                    scale: 1.3,
                    child: Lottie.asset(
                      'assets/lottie/monkey_toss_stars.lottie',
                      decoder: customDecoder,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24 * scaleFactor,
              top: 802 * scaleFactor,
              child: CustomButton(
                text: 'Tiếp tục',
                onPressed: _onContinue,
                size: ButtonSize.xl,
                maxWidth: 380 * scaleFactor,
                customScale: scaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
