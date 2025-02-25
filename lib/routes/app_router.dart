// import 'package:flutter/material.dart';
// //route
// import 'route_constants.dart';
// //screen
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../features/onboarding/presentation/screens/onboarding_screen.dart';

// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case RouteConstants.splash:
//         return MaterialPageRoute(
//           builder: (_) => const SplashScreen(),
//         );
//       case RouteConstants.onboarding:
//         // TODO: Implement onboarding screen
//         return MaterialPageRoute(
//           builder: (_) => const OnboardingScreen(),
//         );
//       case RouteConstants.login:
//         // TODO: Implement login screen
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(body: Center(child: Text('Login'))),
//         );
//       case RouteConstants.home:
//         // TODO: Implement home screen
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(body: Center(child: Text('Home'))),
//         );
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }
// }

import 'package:auto_route/auto_route.dart';
//route
import 'route_constants.dart';
//screen
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: RouteConstants.splash,
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: RouteConstants.onboarding,
          page: OnboardingRoute.page,
        ),
        AutoRoute(
          path: RouteConstants.login,
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: RouteConstants.registration,
          page: RegistrationRoute.page,
        ),
        AutoRoute(
          path: RouteConstants.phoneVerification,
          page: PhoneVerificationRoute.page,
        ),
        AutoRoute(
          path: RouteConstants.profileCreation,
          page: PhoneVerificationRoute.page,
        ),
        AutoRoute(
          path: RouteConstants.home,
          page: HomeRoute.page,
        ),
      ];
}
