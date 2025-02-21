import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../routes/route_constants.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_state.dart';
import '../bloc/splash_event.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SplashBloc>()..add(const SplashEvent.started()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        print("SplashState: $state");
        state.whenOrNull(
          navigateToOnboarding: () {
            Navigator.of(context)
                .pushReplacementNamed(RouteConstants.onboarding);
          },
          navigateToLogin: () {
            Navigator.of(context).pushReplacementNamed(RouteConstants.login);
          },
          navigateToHome: () {
            Navigator.of(context).pushReplacementNamed(RouteConstants.home);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const FlutterLogo(size: 100),
              const SizedBox(height: 24),
              // Loading indicator
              BlocBuilder<SplashBloc, SplashState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () =>
                        const CircularProgressIndicator(color: Colors.white),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
