import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/presentation/screens/game_config/blocs/game_config_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';

@GenerateMocks([TestAssetBundle])
import 'game_config_bloc_test.mocks.dart';

class TestAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockTestAssetBundle mockAssetBundle;
  const testConfigPath = 'assets/test_config.json';
  final testConfigData = {
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
  };

  setUp(() {
    mockAssetBundle = MockTestAssetBundle();

    // Setup test asset loading
    when(mockAssetBundle.loadString(testConfigPath))
        .thenAnswer((_) async => json.encode(testConfigData));

    // Setup Asset bundle mock for testing
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter/assets'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getAsset') {
          final String key = methodCall.arguments as String;
          try {
            String asset = await mockAssetBundle.loadString(key);
            return Uint8List.fromList(asset.codeUnits).buffer.asByteData();
          } catch (e) {
            return null;
          }
        }
        return null;
      },
    );
  });

  group('GameConfigBloc', () {
    test('initial state is GameConfigInitial', () {
      final bloc = GameConfigBloc();
      expect(bloc.state, isA<GameConfigInitial>());
    });

    blocTest<GameConfigBloc, GameConfigState>(
      'emits [GameConfigLoading, GameConfigLoaded] when LoadGameConfig is added',
      build: () => GameConfigBloc(),
      act: (bloc) =>
          bloc.add(const LoadGameConfig(configFilePath: testConfigPath)),
      expect: () => [
        isA<GameConfigLoading>(),
        isA<GameConfigLoaded>(),
      ],
    );

    blocTest<GameConfigBloc, GameConfigState>(
      'emits GameConfigLoaded with updated data when UpdateGameConfig is added',
      build: () => GameConfigBloc(),
      seed: () => GameConfigLoaded(testConfigData),
      act: (bloc) {
        final updatedConfigData = Map<String, dynamic>.from(testConfigData);
        updatedConfigData['questionConfig']
            ['position'] = {'x': 150.0, 'y': 250.0};

        bloc.add(UpdateGameConfig(updatedConfigData));
      },
      expect: () => [
        isA<GameConfigLoaded>().having(
          (state) => state.configData['questionConfig']['position']['x'],
          'updated x position',
          150.0,
        ),
      ],
    );

    blocTest<GameConfigBloc, GameConfigState>(
      'emits [ComponentMoved, GameConfigLoaded] when MoveComponent is added',
      build: () => GameConfigBloc(),
      seed: () => GameConfigLoaded(testConfigData),
      act: (bloc) => bloc.add(
        const MoveComponent(
          section: 'questionConfig',
          subsection: null,
          positionKey: 'position',
          newPosition: {'x': 200.0, 'y': 300.0},
        ),
      ),
      expect: () => [
        isA<ComponentMoved>(),
        isA<GameConfigLoaded>().having(
          (state) => state.configData['questionConfig']['position']['x'],
          'updated x position',
          200.0,
        ),
      ],
    );

    blocTest<GameConfigBloc, GameConfigState>(
      'emits GameConfigLoaded with updated timestamp when ForcePreviewUpdate is added',
      build: () => GameConfigBloc(),
      seed: () => GameConfigLoaded(testConfigData),
      act: (bloc) => bloc.add(ForcePreviewUpdate()),
      verify: (bloc) {
        expect(bloc.state, isA<GameConfigLoaded>());
        final GameConfigLoaded state = bloc.state as GameConfigLoaded;
        expect(state.configData['_lastUpdated'], isNotNull);
      },
    );

    blocTest<GameConfigBloc, GameConfigState>(
      'emits [GameConfigSaved, GameConfigLoaded] when SaveGameConfig is added',
      build: () => GameConfigBloc(),
      seed: () => GameConfigLoaded(testConfigData),
      act: (bloc) => bloc.add(SaveGameConfig()),
      expect: () => [
        isA<GameConfigSaved>(),
        isA<GameConfigLoaded>(),
      ],
    );
  });
}
