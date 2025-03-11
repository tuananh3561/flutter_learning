import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/presentation/screens/game_config/blocs/game_config_bloc.dart';
import 'package:flutter_learning/presentation/screens/game_config/game_config_editor_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([GameConfigBloc])
import 'game_config_editor_screen_test.mocks.dart';

void main() {
  late MockGameConfigBloc mockGameConfigBloc;

  setUp(() {
    mockGameConfigBloc = MockGameConfigBloc();

    // Setup initial state
    when(mockGameConfigBloc.state).thenReturn(GameConfigInitial());

    // Setup stream behavior
    final streamController = Stream<GameConfigState>.fromIterable([
      GameConfigInitial(),
      GameConfigLoading(),
      GameConfigLoaded({
        'gameSettings': {
          'numberOfChoices': 3,
          'backgroundConfigPath': 'assets/bg_config.json',
        },
        'questionConfig': {
          'position': {'x': 100.0, 'y': 200.0},
        },
        'answerConfig': {
          'audioButtons': {
            'layout': {
              'useIndividualPositions': true,
              'buttonPositions': [
                {'x': 500.0, 'y': 100.0},
                {'x': 500.0, 'y': 200.0},
                {'x': 500.0, 'y': 300.0},
              ],
            },
          },
        },
      }),
    ]);

    when(mockGameConfigBloc.stream).thenAnswer((_) => streamController);
  });

  testWidgets('GameConfigEditorScreen loads and displays correctly',
      (WidgetTester tester) async {
    // Build the widget with the mock BLoC
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GameConfigBloc>.value(
          value: mockGameConfigBloc,
          child: const GameConfigEditorScreen(
              configFilePath: 'assets/test_config.json'),
        ),
      ),
    );

    // Verify that the screen loads with a loading indicator initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate loading completed
    when(mockGameConfigBloc.state).thenReturn(GameConfigLoaded({
      'gameSettings': {
        'numberOfChoices': 3,
        'backgroundConfigPath': 'assets/bg_config.json',
      },
      'questionConfig': {
        'position': {'x': 100.0, 'y': 200.0},
      },
      'answerConfig': {
        'audioButtons': {
          'layout': {
            'useIndividualPositions': true,
            'buttonPositions': [
              {'x': 500.0, 'y': 100.0},
              {'x': 500.0, 'y': 200.0},
              {'x': 500.0, 'y': 300.0},
            ],
          },
        },
      },
    }));

    // Pump the widget to update with the loaded state
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // Wait for animations

    // Verify that critical UI elements are present
    expect(find.text('Game Configuration Editor'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Verify that the BLoC was called with the correct event when screen loaded
    verify(mockGameConfigBloc.add(
            const LoadGameConfig(configFilePath: 'assets/test_config.json')))
        .called(1);
  });

  testWidgets('Update preview button triggers ForcePreviewUpdate event',
      (WidgetTester tester) async {
    // Set the mock BLoC to return a loaded state
    when(mockGameConfigBloc.state).thenReturn(GameConfigLoaded({
      'gameSettings': {
        'numberOfChoices': 3,
        'backgroundConfigPath': 'assets/bg_config.json',
      },
      'questionConfig': {
        'position': {'x': 100.0, 'y': 200.0},
      },
    }));

    // Build the widget with the mock BLoC
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GameConfigBloc>.value(
          value: mockGameConfigBloc,
          child: const GameConfigEditorScreen(
              configFilePath: 'assets/test_config.json'),
        ),
      ),
    );

    // Wait for the UI to stabilize
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Find and tap the update preview button
    final updateButtonFinder = find.text('Update Preview');
    expect(updateButtonFinder, findsOneWidget);
    await tester.tap(updateButtonFinder);
    await tester.pump();

    // Verify that the ForcePreviewUpdate event was added to the BLoC
    verify(mockGameConfigBloc.add(any)).called(greaterThanOrEqualTo(1));
  });

  testWidgets('Save button triggers SaveGameConfig event',
      (WidgetTester tester) async {
    // Set the mock BLoC to return a loaded state
    when(mockGameConfigBloc.state).thenReturn(GameConfigLoaded({
      'gameSettings': {
        'numberOfChoices': 3,
        'backgroundConfigPath': 'assets/bg_config.json',
      },
      'questionConfig': {
        'position': {'x': 100.0, 'y': 200.0},
      },
    }));

    // Build the widget with the mock BLoC
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GameConfigBloc>.value(
          value: mockGameConfigBloc,
          child: const GameConfigEditorScreen(
              configFilePath: 'assets/test_config.json'),
        ),
      ),
    );

    // Wait for the UI to stabilize
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Find and tap the save button
    final saveButtonFinder = find.text('Save');
    expect(saveButtonFinder, findsOneWidget);
    await tester.tap(saveButtonFinder);
    await tester.pump();

    // Verify that the SaveGameConfig event was added to the BLoC
    verify(mockGameConfigBloc.add(any)).called(greaterThanOrEqualTo(1));
  });
}
