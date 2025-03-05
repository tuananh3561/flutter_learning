import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for the Story Nighty Night app
/// Provides helper methods for navigation throughout the app
class NavigationService {
  /// Navigate to the home screen
  static void navigateToHome(BuildContext context) {
    GoRouter.of(context).goNamed('home');
  }

  /// Navigate to the onboarding screen
  static void navigateToOnboarding(BuildContext context) {
    GoRouter.of(context).goNamed('onboarding');
  }

  /// Navigate to the stories list screen
  static void navigateToStories(BuildContext context) {
    GoRouter.of(context).goNamed('stories');
  }

  /// Navigate to a specific story reader screen
  static void navigateToStoryReader(BuildContext context, String storyId) {
    GoRouter.of(context).goNamed('story_reader', pathParameters: {'id': storyId});
  }

  /// Navigate to games for a specific story
  static void navigateToGames(BuildContext context, String storyId) {
    GoRouter.of(context).goNamed('games', pathParameters: {'storyId': storyId});
  }

  /// Navigate to the login screen
  static void navigateToLogin(BuildContext context) {
    GoRouter.of(context).goNamed('login');
  }

  /// Navigate to the signup screen
  static void navigateToSignup(BuildContext context) {
    GoRouter.of(context).goNamed('signup');
  }

  /// Navigate to the parent dashboard
  static void navigateToParentDashboard(BuildContext context) {
    GoRouter.of(context).goNamed('parent_dashboard');
  }

  /// Navigate to the reports screen
  static void navigateToReports(BuildContext context) {
    GoRouter.of(context).goNamed('reports');
  }

  /// Navigate to the settings screen
  static void navigateToSettings(BuildContext context) {
    GoRouter.of(context).goNamed('settings');
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