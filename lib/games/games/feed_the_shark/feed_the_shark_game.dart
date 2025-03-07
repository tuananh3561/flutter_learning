import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

import '../../components/fish_component.dart';
import '../../components/shark_component.dart';
import '../../engine/game_engine.dart';
import '../../../core/services/audio_service.dart';
import '../../components/background_components.dart';

/// The Feed the Shark game
class FeedTheSharkGame extends BaseGame {
  /// Number of correct answers needed to win
  final int requiredCorrectAnswers;

  /// Current number of correct answers
  int _correctAnswersCount = 0;

  /// Random number generator
  final Random _random = Random();

  /// The fish currently displayed on screen
  final List<FishComponent> _activeFish = [];

  /// The shark component
  late SharkComponent _shark;

  /// Background and decorations component
  late BackgroundComponents _backgroundComponents;

  /// Spine data
  final Map<String, SpineComponent> _spineComponents = {};

  /// Whether the game is currently waiting for the shark animation to complete
  bool _isWaitingForShark = false;

  /// Whether the game has ended
  bool _gameEnded = false;

  /// Audio service instance
  final AudioService _audioService = AudioService();

  /// All possible words to use in the game
  final List<Map<String, dynamic>> _wordPool = [
    {'text': 'bird bird', 'audio': '../../assets/audio/word/bird.mp3'},
    {'text': 'cat', 'audio': '../../assets/audio/word/cat.mp3'},
    {'text': 'dog', 'audio': '../../assets/audio/word/dog.mp3'},
    // {'text': 'bird', 'audio': 'bird.mp3'},
    // {'text': 'duck', 'audio': 'duck.mp3'},
    // {'text': 'pig', 'audio': 'pig.mp3'},
    // {'text': 'cow', 'audio': 'cow.mp3'},
    // {'text': 'sheep', 'audio': 'sheep.mp3'},
    // {'text': 'horse', 'audio': 'horse.mp3'},
    // {'text': 'frog', 'audio': 'frog.mp3'},
  ];

  /// The current word that needs to be found
  String _currentTargetWord = '';

  /// Callback when game is completed
  final Function? onGameComplete;

  /// Callback được gọi khi chọn từ đúng
  final Function(String)? onCorrectWord;

  /// Callback được gọi khi chọn từ sai
  final Function(String)? onWrongWord;

  /// Callback được gọi khi đặt từ mục tiêu mới
  final Function(String)? onSetTargetWord;

  /// Path to the background config file
  final String backgroundConfigPath;

  /// Constructor
  FeedTheSharkGame({
    required Vector2 gameSize,
    this.requiredCorrectAnswers = 5,
    this.onGameComplete,
    this.onCorrectWord,
    this.onWrongWord,
    this.onSetTargetWord,
    this.backgroundConfigPath = 'assets/Feed the Shark/background_config.json',
  }) : super(gameSize: gameSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set camera viewport to be 3 times the game size for camera zoom
    camera.viewport = FixedResolutionViewport(resolution: gameSize);

    // Initialize background and decorations component
    _backgroundComponents = BackgroundComponents(
      configFilePath: backgroundConfigPath,
      gameSize: gameSize,
    );
    add(_backgroundComponents);

    // Initialize Spine - this is simulated for now since proper spine assets are required
    await _initializeSpineComponents();

    // Create shark (initially hidden)
    _shark = await _createSharkComponent();
    add(_shark);

    // Start background music
    _audioService
        .playBackgroundMusic('../../assets/Feed the Shark/Nhạc BG.mp3');

    // Set the first target word and spawn initial fish
    _setNewTargetWord();
    _spawnInitialFish();
  }

  /// Initialize Spine components for the game
  Future<void> _initializeSpineComponents() async {
    try {
      // In a real implementation, we would load Spine components here
      // But since we don't have the actual Spine assets, we'll create placeholders
      await _createPlaceholderSpineComponents();
    } catch (e) {
      print('Error initializing Spine components: $e');
    }
  }

  /// Create placeholder Spine components for testing
  Future<void> _createPlaceholderSpineComponents() async {
    // These are simple placeholders until real Spine assets are available

    // Create shark placeholder
    _spineComponents['shark'] = await SpineComponent.fromAssets(
      atlasFile: 'assets/Feed the Shark/shark/skeleton_hdr.atlas.txt',
      skeletonFile: 'assets/Feed the Shark/shark/skeleton.json',
      scale: Vector2(0.1, 0.1),
      anchor: Anchor.center,
      position: Vector2.zero(),
    );

    // // Create fish placeholders
    // for (int i = 1; i <= 3; i++) {
    //   _spineComponents['ca_nho_$i'] = await SpineComponent.fromAssets(
    //     atlasFile: 'assets/Feed the Shark/ca nho $i/skeleton_hdr.atlas.txt',
    //     skeletonFile: 'assets/Feed the Shark/ca nho $i/skeleton.json',
    //     scale: Vector2(0.1, 0.1),
    //     anchor: Anchor.center,
    //     position: Vector2.zero(),
    //   );

    //   _spineComponents['ca_to_$i'] = await SpineComponent.fromAssets(
    //     atlasFile: 'assets/Feed the Shark/ca to $i/skeleton_hdr.atlas.txt',
    //     skeletonFile: 'assets/Feed the Shark/ca to $i/skeleton.json',
    //     scale: Vector2(0.1, 0.1),
    //     anchor: Anchor.center,
    //     position: Vector2.zero(),
    //   );
    // }
  }

  /// Get a clone of a spine component
  SpineComponent _getSpineComponent(String type) {
    if (!_spineComponents.containsKey(type)) {
      throw Exception('Spine component not found for type: $type');
    }

    // Clone the component to avoid sharing the same component across multiple entities
    // return _spineComponents[type]!.clone();
    return _spineComponents[type]!;
  }

  /// Create the shark component
  Future<SharkComponent> _createSharkComponent() async {
    try {
      SpineComponent spineComponent;

      if (_spineComponents.containsKey('shark')) {
        spineComponent = _getSpineComponent('shark');
      } else {
        // Create a placeholder if spine component is not available
        spineComponent = await SpineComponent.fromAssets(
          atlasFile: 'assets/Feed the Shark/shark/skeleton_hdr.atlas.txt',
          skeletonFile: 'assets/Feed the Shark/shark/skeleton.json',
          scale: Vector2(0.1, 0.1),
          anchor: Anchor.center,
          position: Vector2.zero(),
        );
      }
      spineComponent.animationState.setAnimationByName(0, 'Idie', true);

      final sharkComponentFinished = SharkComponent(
        speed: 400,
        eatSoundEffect: '../../assets/Feed the Shark/SFX cá mập.mp3',
        eatingDuration: Duration(milliseconds: 800),
        swimmingDuration: Duration(milliseconds: 600),
        position: Vector2(-300, gameSize.y / 2),
        size: spineComponent.size * 0.25,
        spineComponent: spineComponent,
      )..onAnimationFinished = _onSharkAnimationFinished;

      spineComponent.position = sharkComponentFinished.size / 2;

      return sharkComponentFinished;
    } catch (e) {
      print('Error creating shark component: $e');

      // Return a placeholder shark component if Spine loading fails
      // final placeholderSpineComponent = await _createPlaceholderComponent();
      final placeholderSpineComponent = _getSpineComponent('shark');
      placeholderSpineComponent.scale = Vector2(0.25, 0.25);
      placeholderSpineComponent.animationState
          .setAnimationByName(0, 'Idie', true);

      final sharkComponentFinished = SharkComponent(
        speed: 400,
        eatSoundEffect: '../../assets/Feed the Shark/SFX cá mập.mp3',
        eatingDuration: Duration(milliseconds: 800),
        swimmingDuration: Duration(milliseconds: 600),
        position: Vector2(-300, gameSize.y / 2),
        size: placeholderSpineComponent.size * 0.25,
        spineComponent: placeholderSpineComponent,
      )..onAnimationFinished = _onSharkAnimationFinished;
      placeholderSpineComponent.position = sharkComponentFinished.size / 2;

      return sharkComponentFinished;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameEnded) return;

    // Check for fish that have gone off screen
    for (int i = _activeFish.length - 1; i >= 0; i--) {
      if (_activeFish[i].isOutOfBounds(gameSize)) {
        _replaceFish(_activeFish[i]);
      }
    }
  }

  /// Set a new target word
  void _setNewTargetWord() {
    final wordData = _wordPool[_random.nextInt(_wordPool.length)];
    _currentTargetWord = wordData['text'];

    // Gọi callback khi đặt từ mục tiêu mới
    if (onSetTargetWord != null) {
      onSetTargetWord!(_currentTargetWord);
    }

    // Play audio guiding
    _audioService
        .playSoundEffect('../../assets/Feed the Shark/SFX guiding.mp3')
        .then((_) {
      // After guiding sound, play the target word sound
      _audioService.playSoundEffect('${wordData['audio']}');
    });
  }

  /// Spawn the initial set of fish
  void _spawnInitialFish() async {
    // Create fish for each lane
    for (int lane = 0; lane < 4; lane++) {
      await _spawnFishInLane(lane);
    }
  }

  /// Spawn a fish in a specific lane
  Future<void> _spawnFishInLane(int lane) async {
    try {
      // Calculate lane Y position (divide screen height into 4 sections)
      final laneY = (lane + 0.5) * (gameSize.y / 4);

      // Randomly decide direction (left to right or right to left)
      final direction = _random.nextBool() ? 1 : -1;

      // Position based on direction (start offscreen)
      final startX = direction < 0 ? gameSize.x + 50.0 : -150.0;

      // Choose a random word from the pool
      final wordData = _wordPool[_random.nextInt(_wordPool.length)];

      // Decide if this fish should be correct answer (only one correct fish at a time)
      final bool isCorrect = wordData['text'] == _currentTargetWord &&
          !_activeFish.any((fish) => fish.isCorrectAnswer);

      // Select fish type randomly
      final fishType = _random.nextInt(3) + 1; // 1, 2, or 3

      // Chọn loại cá dựa trên độ dài của text
      // Nếu text > 8 ký tự thì chọn cá to, ngược lại chọn cá nhỏ
      final fishSize = wordData['text'].length > 8
          ? 'to'
          : _random.nextBool()
              ? 'nho'
              : 'to';

      final spineKey = 'ca_${fishSize}_$fishType';

      // Create the spine component
      final spineComponent = _getSpineComponent(spineKey);
      spineComponent.animationState.setAnimationByName(0, 'Idie', true);
      final skinsAvailable = spineComponent.skeleton.getData()?.getSkins();
      final skinsName = skinsAvailable?.map((skin) => skin.getName()).toList();

      if (skinsName != null && skinsName.isNotEmpty) {
        // Create Random object
        final random = Random();
        // Create a new list excluding the first element (index 0)
        final skinsExcludingFirst = skinsName.sublist(1);
        // Randomly get an index within the range of the list
        final randomIndex = random.nextInt(skinsExcludingFirst.length);
        // Get skin name at random position
        final randomSkinName = skinsExcludingFirst[randomIndex];
        // Áp dụng skin này
        spineComponent.skeleton.setSkinByName(randomSkinName);
        spineComponent.skeleton.setSlotsToSetupPose();
      }

      // Create the fish component
      final fish = FishComponent(
        text: wordData['text'],
        audioFile: '${wordData['audio']}',
        direction: direction,
        lane: lane,
        speed: 50 + _random.nextDouble() * 50, // Random speed between 50-100
        isCorrectAnswer: isCorrect,
        onTap: _onFishTapped,
        position: Vector2(startX, laneY),
        size: Vector2(
          150,
          100,
        ), // Kích thước ban đầu, sẽ được điều chỉnh trong FishComponent
        spineComponent: spineComponent,
      );

      // Thiết lập vị trí của spine component
      spineComponent.position = fish.size / 2;

      // Add fish to game and track it
      add(fish);
      _activeFish.add(fish);
    } catch (e) {
      print('Error spawning fish in lane $lane: $e');
      // We'll create a simple rectangle as a fish if spine loading fails
      _spawnSimpleFish(lane);
    }
  }

  /// Spawn a simple fish as a fallback
  Future<void> _spawnSimpleFish(int lane) async {
    // Calculate lane Y position
    final laneY = (lane + 0.5) * (gameSize.y / 4);

    // Randomly decide direction (left to right or right to left)
    final direction = _random.nextBool() ? 1 : -1;

    // Position based on direction (start offscreen)
    final startX = direction < 0 ? gameSize.x + 50.0 : -150.0;

    // Choose a random word from the pool
    final wordData = _wordPool[_random.nextInt(_wordPool.length)];

    // Decide if this fish should be correct answer
    final bool isCorrect = wordData['text'] == _currentTargetWord &&
        !_activeFish.any((fish) => fish.isCorrectAnswer);

    // Create a placeholder component
    final placeholderComponent = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(150, 50),
      paint: Paint()..color = isCorrect ? Colors.green : Colors.blue,
    );

    // Chọn loại cá dựa trên độ dài của text
    final fishSize = wordData['text'].length > 8
        ? 'to'
        : _random.nextBool()
            ? 'nho'
            : 'to';
    final fishType =
        _random.nextInt(3) + 1; // Chọn ngẫu nhiên 1 trong 3 loại cá

    // Sử dụng đường dẫn spine assets phù hợp với loại cá
    final placeholderSpine = await SpineComponent.fromAssets(
      atlasFile:
          'assets/Feed the Shark/ca $fishSize $fishType/skeleton_hdr.atlas.txt',
      skeletonFile:
          'assets/Feed the Shark/ca $fishSize $fishType/skeleton.json',
      scale: Vector2(0.1, 0.1),
      anchor: Anchor.center,
      position: Vector2.zero(),
    );

    placeholderSpine.animationState.setAnimationByName(0, 'Idie', true);
    final skinsAvailable = placeholderSpine.skeleton.getData()?.getSkins();
    final skinsName = skinsAvailable?.map((skin) => skin.getName()).toList();
    if (skinsName != null && skinsName.isNotEmpty) {
      // Create Random object
      final random = Random();
      // Create a new list excluding the first element (index 0)
      final skinsExcludingFirst = skinsName.sublist(1);
      // Randomly get an index within the range of the list
      final randomIndex = random.nextInt(skinsExcludingFirst.length);
      // Get skin name at random position
      final randomSkinName = skinsExcludingFirst[randomIndex];
      // Áp dụng skin này
      placeholderSpine.skeleton.setSkinByName(randomSkinName);
      placeholderSpine.skeleton.setSlotsToSetupPose();
    }

    // Create fish component
    final fish = FishComponent(
      text: wordData['text'],
      audioFile: '${wordData['audio']}',
      direction: direction,
      lane: lane,
      speed: 50 + _random.nextDouble() * 50,
      isCorrectAnswer: isCorrect,
      onTap: _onFishTapped,
      position: Vector2(startX, laneY),
      size: Vector2(150,
          100), // Kích thước ban đầu, sẽ được điều chỉnh trong FishComponent
      spineComponent: placeholderSpine,
    );

    // Thiết lập vị trí của spine component
    placeholderSpine.position = fish.size / 2;

    // Add fish to game and track it
    add(fish);
    _activeFish.add(fish);
  }

  /// Replace a fish that went off screen
  void _replaceFish(FishComponent oldFish) {
    // Remove the old fish
    oldFish.removeFromParent();
    _activeFish.remove(oldFish);

    // Spawn a new fish in the same lane
    _spawnFishInLane(oldFish.lane);
  }

  /// Handle fish tap
  void _onFishTapped(FishComponent fish) {
    if (_isWaitingForShark || _gameEnded) return;

    if (fish.isCorrectAnswer) {
      _handleCorrectTap(fish);
    } else {
      _handleIncorrectTap(fish);
    }
  }

  /// Handle correct fish tap
  void _handleCorrectTap(FishComponent fish) {
    _isWaitingForShark = true;

    // Gọi callback khi chọn từ đúng
    if (onCorrectWord != null) {
      onCorrectWord!(fish.text);
    }

    // Play correct sound
    _audioService.playSoundEffect('../../assets/Feed the Shark/SFX đúng.mp3');

    // Stun the fish
    fish.stun();

    // Send shark to eat the fish
    _shark.attack(fish.position);

    // // Start fish "being eaten" animation
    // fish.startEatingAnimation();

    // Increment correct answers
    _correctAnswersCount++;

    // Check if game is complete
    if (_correctAnswersCount >= requiredCorrectAnswers) {
      _endGame();
    }
    _isWaitingForShark = false;
  }

  /// Handle incorrect fish tap
  void _handleIncorrectTap(FishComponent fish) {
    // Gọi callback khi chọn từ sai
    if (onWrongWord != null) {
      onWrongWord!(fish.text);
    }

    // Play incorrect sound
    _audioService.playSoundEffect('../../assets/Feed the Shark/SFX sai.mp3');

    // Make fish shake and play its audio
    fish.shake();
    fish.playAudio();

    // Kiểm tra xem cá có đang chạy trốn không
    if (fish.isEscaping) {
      // Cá đang chạy trốn, không cần xử lý thêm gì
      return;
    }

    if (fish.isShaking) {
      // Apply shaking effect when incorrectly tapped
      fish.position.y +=
          sin(DateTime.now().millisecondsSinceEpoch / 50).toDouble() * 2;
    }
  }

  /// Handle shark animation finished
  void _onSharkAnimationFinished() {
    if (_gameEnded) return;

    _isWaitingForShark = false;

    // Remove all fish and spawn new ones
    for (var fish in List.from(_activeFish)) {
      fish.removeFromParent();
      _activeFish.remove(fish);
    }

    // Set new target word and spawn new fish
    _setNewTargetWord();
    _spawnInitialFish();
  }

  /// End the game
  void _endGame() {
    _gameEnded = true;

    // Play win sound
    _audioService.playSoundEffect('../../assets/Feed the Shark/SFX Win.mp3');

    // Stop background music
    _audioService.stopBackgroundMusic();

    // Call game complete callback
    if (onGameComplete != null) {
      Future.delayed(Duration(seconds: 2), () {
        onGameComplete!();
      });
    }

    // Additional end game animations or effects could be added here
    onGameEnd();
  }

  @override
  Future<void> onGameStart() async {
    // Reset game state
    _correctAnswersCount = 0;
    _gameEnded = false;

    // Start background music
    _audioService
        .playBackgroundMusic('../../assets/Feed the Shark/Nhạc BG.mp3');

    // Set the first target word and spawn initial fish
    _setNewTargetWord();
    _spawnInitialFish();
  }

  @override
  Future<void> onGameEnd() async {
    // Clean up resources when game ends
    _audioService.stopBackgroundMusic();
  }

  @override
  void onRemove() {
    super.onRemove();
    _audioService.stopBackgroundMusic();
  }
}
