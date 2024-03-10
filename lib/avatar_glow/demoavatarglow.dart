import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class DemoAvatarGlow extends StatelessWidget {
  const DemoAvatarGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: AvatarGlow(
          glowColor: Colors.deepPurple,
          duration: const Duration(milliseconds: 1000),
          startDelay: const Duration(milliseconds: 1000),
          glowRadiusFactor: 1.0,
          glowCount: 3,
          glowShape: BoxShape.rectangle,
          glowBorderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
