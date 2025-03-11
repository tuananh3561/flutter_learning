import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for the Story Nighty Night app
/// Provides helper methods for navigation throughout the app
class NavigationService {
  /// Navigate to the home screen
  static void navigateToHome(BuildContext context) {
    GoRouter.of(context).go('/');
  }

  /// Navigate to the onboarding screen
  static void navigateToOnboarding(BuildContext context) {
    GoRouter.of(context).go('/onboarding');
  }

  /// Navigate to the stories list screen
  static void navigateToStories(BuildContext context) {
    GoRouter.of(context).goNamed('stories');
  }

  /// Navigate to a specific story reader screen
  static void navigateToStoryReader(BuildContext context, String storyId) {
    GoRouter.of(context).go('/story/$storyId');
  }

  /// Navigate to games for a specific story
  static void navigateToGames(BuildContext context, String storyId) {
    GoRouter.of(context).goNamed('games', pathParameters: {'storyId': storyId});
  }

  /// Navigate to the login screen
  static void navigateToLogin(BuildContext context) {
    GoRouter.of(context).go('/auth/login');
  }

  /// Navigate to the signup screen
  static void navigateToSignup(BuildContext context) {
    GoRouter.of(context).go('/auth/signup');
  }

  /// Navigate to the parent dashboard
  static void navigateToParentDashboard(BuildContext context) {
    GoRouter.of(context).go('/parent');
  }

  /// Navigate to the reports screen
  static void navigateToReports(BuildContext context) {
    GoRouter.of(context).goNamed('reports');
  }

  /// Navigate to the settings screen
  static void navigateToSettings(BuildContext context) {
    GoRouter.of(context).goNamed('settings');
  }

  /// Navigate to the game config editor
  static void navigateToGameConfigEditor(BuildContext context,
      {String? configPath}) {
    if (configPath != null) {
      GoRouter.of(context).go('/game-config?configPath=$configPath');
    } else {
      GoRouter.of(context).go('/game-config');
    }
  }

  /// Navigate back to the previous screen
  static void goBack(BuildContext context) {
    GoRouter.of(context).pop();
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return GoRouter.of(context).canPop();
  }
}
