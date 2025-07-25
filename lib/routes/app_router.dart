import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_learning/presentation/screens/splash/splash_screen.dart';
import 'package:flutter_learning/presentation/screens/onboarding/onboarding.dart';
import 'package:flutter_learning/presentation/screens/home/home_screen.dart';
import 'package:flutter_learning/presentation/screens/story_reader/story_reader_screen.dart';
import 'package:flutter_learning/games/games/feed_the_shark/feed_the_shark_screen.dart';
import 'package:flutter_learning/games/games/multiple_choice /multiple_choice_game_screen.dart';
import 'package:flutter_learning/presentation/screens/games/games_menu_screen.dart';
import 'package:flutter_learning/presentation/screens/game_config/game_config_editor_screen.dart';
import 'package:flutter_learning/presentation/screens/auth/auth.dart';
import 'package:flutter_learning/presentation/screens/auth/sign_up_phone_screen.dart';
import 'package:flutter_learning/presentation/screens/auth/sign_up_password_screen.dart';
import 'package:flutter_learning/presentation/screens/auth/welcome_screen.dart';
import 'package:flutter_learning/presentation/screens/activation/activation_screen.dart';
import 'package:flutter_learning/data/models/auth_data.dart';
import 'package:flutter_learning/data/models/forgot_password_data.dart';
import 'package:flutter_learning/presentation/screens/profile/profile.dart';
import 'package:flutter_learning/presentation/screens/parent/parent.dart';

/// Main router configuration for the Story Nighty Night app
class AppRouter {
  /// Creates the [GoRouter] for this app
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Intro screen route
      GoRoute(
        path: '/intro',
        name: 'intro',
        builder: (context, state) => const IntroScreen(),
      ),

      // Language selection screen route
      GoRoute(
        path: '/language-selection',
        name: 'language_selection',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),

      // Onboarding flow
      GoRoute(
        path: '/onboarding-loading',
        name: 'onboarding_loading',
        builder: (context, state) => const OnboardingLoadingScreen(),
      ),
      GoRoute(
        path: '/onboarding-start',
        name: 'onboarding_start',
        builder: (context, state) => const OnboardingStartScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding_deprecated',
        builder: (context, state) => const OnboardingStartScreen(),
      ),
      GoRoute(
        path: '/onboarding/select-age',
        name: 'onboarding_select_age',
        builder: (context, state) => const SelectAgeScreen(),
      ),
      GoRoute(
        path: '/onboarding/select-level',
        name: 'onboarding_select_level',
        builder: (context, state) => const SelectLevelScreen(),
      ),
      GoRoute(
        path: '/onboarding/confirm-route',
        name: 'onboarding_confirm_route',
        builder: (context, state) => const ConfirmRouteScreen(),
      ),

      // Authentication screens
      GoRoute(
        path: '/sign-in',
        name: 'sign_in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign_up',
        builder: (context, state) => const SignUpPhoneScreen(),
        routes: [
          GoRoute(
            path: 'phone',
            name: 'sign_up_phone',
            builder: (context, state) => const SignUpPhoneScreen(),
          ),
          GoRoute(
            path: 'password',
            name: 'sign_up_password',
            builder: (context, state) {
              final signUpData = state.extra as SignUpData?;
              return SignUpPasswordScreen(signUpData: signUpData);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Activation screen
      GoRoute(
        path: '/activation',
        name: 'activation',
        builder: (context, state) {
          final source = state.uri.queryParameters['source'];
          return ActivationScreen(source: source);
        },
      ),

      // Forgot password flow
      GoRoute(
        path: '/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordScreen(),
        routes: [
          GoRoute(
            path: 'phone',
            name: 'forgot_password_phone',
            builder: (context, state) {
              final forgotPasswordData = state.extra as ForgotPasswordData?;
              return ForgotPasswordPhoneScreen(
                  forgotPasswordData: forgotPasswordData);
            },
          ),
          GoRoute(
            path: 'email',
            name: 'forgot_password_email',
            builder: (context, state) {
              final forgotPasswordData = state.extra as ForgotPasswordData?;
              return ForgotPasswordEmailScreen(
                  forgotPasswordData: forgotPasswordData);
            },
          ),
          GoRoute(
            path: 'otp',
            name: 'forgot_password_otp',
            builder: (context, state) {
              final forgotPasswordData = state.extra as ForgotPasswordData?;
              return ForgotPasswordOTPScreen(
                  forgotPasswordData: forgotPasswordData);
            },
          ),
          GoRoute(
            path: 'update-password',
            name: 'update_password',
            builder: (context, state) {
              final forgotPasswordData = state.extra as ForgotPasswordData?;
              return UpdatePasswordScreen(
                  forgotPasswordData: forgotPasswordData);
            },
          ),
        ],
      ),

      // Main app shell route
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Story list (carousel)
          GoRoute(
            path: 'stories',
            name: 'stories',
            builder: (context, state) =>
                const Placeholder(color: Colors.orange),
          ),

          // Story reader
          GoRoute(
            path: 'story/:id',
            name: 'story_reader',
            builder: (context, state) {
              final storyId = state.pathParameters['id']!;
              return StoryReaderScreen(storyId: storyId);
            },
          ),

          // Games menu
          GoRoute(
            path: 'games/:storyId',
            name: 'games',
            builder: (context, state) {
              final storyId = state.pathParameters['storyId']!;
              return GamesMenuScreen(storyId: storyId);
            },
            routes: [
              GoRoute(
                path: 'feed-the-shark',
                name: 'feed_the_shark',
                builder: (context, state) => const FeedTheSharkGameScreen(),
              ),
              GoRoute(
                path: 'multiple-choice',
                name: 'multiple_choice',
                builder: (context, state) => const MultipleChoiceGameScreen(),
              ),
            ],
          ),

          // Direct game routes
          GoRoute(
            path: 'feed-the-shark',
            name: 'feed_the_shark_direct',
            builder: (context, state) => const FeedTheSharkGameScreen(),
          ),

          GoRoute(
            path: 'multiple-choice',
            name: 'multiple_choice_direct',
            builder: (context, state) => const MultipleChoiceGameScreen(),
          ),

          // Game Config Editor
          GoRoute(
            path: 'game-config',
            name: 'game_config_editor',
            builder: (context, state) {
              final configPath = state.uri.queryParameters['configPath'];
              return GameConfigEditorScreen(configFilePath: configPath);
            },
          ),

          // Authentication
          GoRoute(
            path: 'auth',
            name: 'auth',
            builder: (context, state) => const SignInScreen(),
            routes: [
              GoRoute(
                path: 'login',
                name: 'login',
                builder: (context, state) => const SignInScreen(),
              ),
              GoRoute(
                path: 'signup',
                name: 'signup',
                builder: (context, state) => const SignUpPhoneScreen(),
              ),
              GoRoute(
                path: 'forgot-password',
                name: 'forgot_password_old',
                builder: (context, state) => const ForgotPasswordScreen(),
              ),
            ],
          ),

          // Profile management
          GoRoute(
            path: 'profile',
            name: 'list_profile',
            builder: (context, state) => const ListProfileScreen(),
          ),

          // Parent dashboard
          GoRoute(
            path: 'parent',
            name: 'parent_dashboard',
            builder: (context, state) => const ParentMainScreen(),
            routes: [
              GoRoute(
                path: 'vip-purchased',
                name: 'parent_vip_purchased',
                builder: (context, state) =>
                    const ParentMainScreen(showVipPurchased: true),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
