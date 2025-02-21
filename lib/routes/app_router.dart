import 'package:flutter/material.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case RouteConstants.onboarding:
        // TODO: Implement onboarding screen
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Onboarding'))),
        );
      case RouteConstants.login:
        // TODO: Implement login screen
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Login'))),
        );
      case RouteConstants.home:
        // TODO: Implement home screen
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Home'))),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
