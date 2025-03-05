import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main router configuration for the Story Nighty Night app
class AppRouter {
  /// Creates the [GoRouter] for this app
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Main app shell route
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Placeholder(color: Colors.blue),
        routes: [
          // Onboarding flow
          GoRoute(
            path: 'onboarding',
            name: 'onboarding',
            builder: (context, state) => const Placeholder(color: Colors.green),
          ),
          
          // Story list (carousel)
          GoRoute(
            path: 'stories',
            name: 'stories',
            builder: (context, state) => const Placeholder(color: Colors.orange),
          ),
          
          // Story reader
          GoRoute(
            path: 'story/:id',
            name: 'story_reader',
            builder: (context, state) {
              final storyId = state.pathParameters['id'];
              return Placeholder(color: Colors.purple, child: Text('Story ID: $storyId'));
            },
          ),
          
          // Games
          GoRoute(
            path: 'games/:storyId',
            name: 'games',
            builder: (context, state) {
              final storyId = state.pathParameters['storyId'];
              return Placeholder(color: Colors.red, child: Text('Games for story: $storyId'));
            },
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
                builder: (context, state) => const Placeholder(color: Colors.amber),
              ),
              GoRoute(
                path: 'signup',
                name: 'signup',
                builder: (context, state) => const Placeholder(color: Colors.amber),
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
                builder: (context, state) => const Placeholder(color: Colors.teal),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const Placeholder(color: Colors.teal),
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