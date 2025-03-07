import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_learning/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_learning/presentation/screens/home/home_screen.dart';
import 'package:flutter_learning/presentation/screens/story_reader/story_reader_screen.dart';
import 'package:flutter_learning/games/games/feed_the_shark/feed_the_shark_screen.dart';

/// Main router configuration for the Story Nighty Night app
class AppRouter {
  /// Creates the [GoRouter] for this app
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      // Main app shell route
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Onboarding flow
          GoRoute(
            path: 'onboarding',
            name: 'onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),

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

          // Games
          GoRoute(
            path: 'games/:storyId',
            name: 'games',
            builder: (context, state) {
              final storyId = state.pathParameters['storyId'];
              return Placeholder(
                  color: Colors.red, child: Text('Games for story: $storyId'));
            },
            routes: [
              GoRoute(
                path: 'feed-the-shark',
                name: 'feed_the_shark',
                builder: (context, state) => const FeedTheSharkGameScreen(),
              ),
            ],
          ),

          // Direct game routes
          GoRoute(
            path: 'feed-the-shark',
            name: 'feed_the_shark_direct',
            builder: (context, state) => const FeedTheSharkGameScreen(),
          ),

          // Authentication
          GoRoute(
            path: 'auth',
            name: 'auth',
            builder: (context, state) => const Placeholder(color: Colors.amber),
            routes: [
              GoRoute(
                path: 'login',
                name: 'login',
                builder: (context, state) =>
                    const Placeholder(color: Colors.amber),
              ),
              GoRoute(
                path: 'signup',
                name: 'signup',
                builder: (context, state) =>
                    const Placeholder(color: Colors.amber),
              ),
            ],
          ),

          // Parent dashboard
          GoRoute(
            path: 'parent',
            name: 'parent_dashboard',
            builder: (context, state) => const Placeholder(color: Colors.teal),
            routes: [
              GoRoute(
                path: 'reports',
                name: 'reports',
                builder: (context, state) =>
                    const Placeholder(color: Colors.teal),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) =>
                    const Placeholder(color: Colors.teal),
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
