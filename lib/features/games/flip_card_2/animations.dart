import 'package:flutter/animation.dart';

class GameAnimations {
  static const Duration cardFlipDuration = Duration(milliseconds: 300);
  static const Duration shuffleDuration = Duration(milliseconds: 1000);
  static const Duration matchDisplayDuration = Duration(milliseconds: 3000);

  static Curve get flipCurve => Curves.easeInOut;
  static Curve get shuffleCurve => Curves.elasticOut;
  static Curve get scaleCurve => Curves.bounceOut;

  static Animation<double> createFlipAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: flipCurve,
    ));
  }

  static Animation<Offset> createShuffleAnimation(
    AnimationController controller,
    Offset begin,
    Offset end,
  ) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: shuffleCurve,
    ));
  }

  static Animation<double> createScaleAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: scaleCurve,
    ));
  }
}
