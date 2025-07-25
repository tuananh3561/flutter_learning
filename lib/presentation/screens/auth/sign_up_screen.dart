import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'sign_up_phone_screen.dart';

/// Sign up screen - redirects to phone step
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to phone step immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/sign-up/phone');
    });

    return const SignUpPhoneScreen();
  }
}
