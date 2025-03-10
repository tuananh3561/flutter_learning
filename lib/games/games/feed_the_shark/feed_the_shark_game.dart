import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flutter_learning/games/components/horizontal_line.dart';
import 'package:flutter_learning/games/components/loading_screen.dart';

import '../../components/fish_component.dart';
import '../../components/shark_component.dart';
import '../../engine/game_engine.dart';
import '../../engine/game_state_manager.dart';
import '../../engine/resource_manager.dart';
import '../../components/background_components.dart';
import 'fish_pool.dart';

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

  /// Whether the game has ended
  bool _gameEnded = false;

  /// Loading screen component
  LoadingScreen? _loadingScreen;

  /// Resource manager
  final ResourceManager _resourceManager = ResourceManager();

  /// State manager
  final GameStateManager _stateManager = GameStateManager();

  /// Fish pool
  final FishPool _fishPool = FishPool();

  /// All possible words to use in the game
  final List<Map<String, dynamic>> _wordPool = [
    {'text': 'bird', 'audio': '../../assets/audio/word/bird.mp3'},
    {'text': 'cat', 'audio': '../../assets/audio/word/cat.mp3'},
    {'text': 'dog', 'audio': '../../assets/audio/word/dog.mp3'},
    {'text': 'bird', 'audio': '../../assets/audio/word/bird.mp3'},
    // {'text': 'duck', 'audio': '../../assets/audio/word/duck.mp3'},
    // {'text': 'pig', 'audio': '../../assets/audio/word/pig.mp3'},
    // {'text': 'cow', 'audio': '../../assets/audio/word/cow.mp3'},
    // {'text': 'sheep', 'audio': '../../assets/audio/word/sheep.mp3'},
    // {'text': 'horse', 'audio': '../../assets/audio/word/horse.mp3'},
    // {'text': 'frog', 'audio': '../../assets/audio/word/frog.mp3'},
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

  /// Con cá hiện tại đang bị ăn
  FishComponent? _currentEatenFish;

  /// Constructor
  FeedTheSharkGame({
    required Vector2 gameSize,
    this.requiredCorrectAnswers = 5,
    this.onGameComplete,
    this.onCorrectWord,
    this.onWrongWord,
    this.onSetTargetWord,
    this.backgroundConfigPath = 'assets/Feed the Shark/background_config.json',
  }) : super(gameSize: gameSize) {
    // Thiết lập callbacks cho state manager
    _setupStateCallbacks();
  }

  /// Thiết lập callbacks cho state manager
  void _setupStateCallbacks() {
    // Khi trạng thái chuyển sang playing
    _stateManager.addStateCallback(GameState.playing, () {
      if (!_resourceManager.isLoaded) return;

      // Phát nhạc nền
      _resourceManager
          .playBackgroundMusic('../../assets/Feed the Shark/Nhạc BG.mp3');
    });

    // Khi trạng thái chuyển sang paused
    _stateManager.addStateCallback(GameState.paused, () {
      // Tạm dừng nhạc nền
      _resourceManager.pauseBackgroundMusic();
    });

    // Khi trạng thái chuyển sang ready
    _stateManager.addStateCallback(GameState.ready, () {
      // Dừng nhạc nền
      _resourceManager.stopBackgroundMusic();
    });

    // Khi trạng thái chuyển sang gameOver
    _stateManager.addStateCallback(GameState.gameOver, () {
      // Phát âm thanh chiến thắng
      _resourceManager
          .playSoundEffect('../../assets/Feed the Shark/SFX Win.mp3');

      // Dừng nhạc nền
      _resourceManager.stopBackgroundMusic();

      // Gọi callback kết thúc game
      if (onGameComplete != null) {
        Future.delayed(const Duration(seconds: 2), () {
          onGameComplete!();
        });
      }
    });
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Đặt trạng thái loading
    _stateManager.changeState(GameState.loading);

    // Hiển thị màn hình loading
    _showLoadingScreen();

    // Tải tài nguyên
    _loadGameAssets();
  }

  /// Hiển thị màn hình loading
  void _showLoadingScreen() {
    _loadingScreen = LoadingScreen(
      size: gameSize,
      onLoadingComplete: _onLoadingComplete,
    );
    add(_loadingScreen!);
  }

  /// Tải tài nguyên game
  Future<void> _loadGameAssets() async {
    try {
      // Khởi tạo FishPool với danh sách từ vựng
      _fishPool.initialize(_wordPool);

      // Tải tài nguyên qua ResourceManager
      await _resourceManager.loadResources('feedtheshark');
    } catch (e) {
      print('Error loading game assets: $e');
    }
  }

  /// Xử lý khi tải tài nguyên hoàn tất
  void _onLoadingComplete() {
    // Xóa màn hình loading
    if (_loadingScreen != null && _loadingScreen!.isMounted) {
      _loadingScreen!.removeFromParent();
      _loadingScreen = null;
    }

    // Chuyển sang trạng thái ready
    _stateManager.changeState(GameState.ready);

    // Bắt đầu game
    _startGame();
  }

  /// Bắt đầu game sau khi tải xong tài nguyên
  Future<void> _startGame() async {
    // Initialize background and decorations component
    _backgroundComponents = BackgroundComponents(
      configFilePath: backgroundConfigPath,
      gameSize: gameSize,
    );
    add(_backgroundComponents);

    // Create shark
    _shark = await _createSharkComponent();
    add(_shark);

    // Chuyển sang trạng thái playing
    _stateManager.changeState(GameState.playing);

    // Set the first target word and spawn initial fish
    _setNewTargetWord();
    _spawnInitialFish();
  }

  /// Create the shark component
  Future<SharkComponent> _createSharkComponent() async {
    try {
      // Lấy SpineComponent từ ResourceManager
      final spineComponent = await _resourceManager.getSpineComponent(
        'shark',
        skeletonFile: 'assets/Feed the Shark/shark/skeleton.json',
        atlasFile: 'assets/Feed the Shark/shark/skeleton_hdr.atlas.txt',
        defaultAnimation: 'Idie',
      );

      spineComponent.scale = Vector2(0.25, 0.25);

      final sharkComponent = SharkComponent(
        speed: 400,
        eatSoundEffect: '../../assets/Feed the Shark/SFX cá mập.mp3',
        eatingDuration: const Duration(milliseconds: 800),
        swimmingDuration: const Duration(milliseconds: 600),
        position: Vector2(-300, gameSize.y / 2),
        size: spineComponent.size * 0.25,
        spineComponent: spineComponent,
        gameSize: gameSize,
        onFishEaten: _onFishEaten,
      )..onAnimationFinished = _onSharkAnimationFinished;

      spineComponent.position = sharkComponent.size / 2;

      return sharkComponent;
    } catch (e) {
      print('Error creating shark component: $e');
      rethrow;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Không update game logic khi đang không chơi hoặc đã kết thúc
    if (!_stateManager.isRunning || _gameEnded) return;

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
    _resourceManager
        .playSoundEffect('../../assets/Feed the Shark/SFX guiding.mp3')
        .then((_) {
      // After guiding sound, play the target word sound
      _resourceManager.playWordSound('${wordData['audio']}');
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
      // Sử dụng FishPool để tạo cá ngẫu nhiên
      final fish = await _fishPool.createRandomFish(
        lane: lane,
        gameSize: gameSize,
        targetWord: _currentTargetWord,
        canBeCorrect: !_activeFish.any((fish) => fish.isCorrectAnswer),
        onTap: _onFishTapped,
      );

      // Thêm lane visualizer nếu cần
      add(HorizontalLine(y: (lane + 0.5) * (gameSize.y / 5)));

      // Add fish to game and track it
      add(fish);
      _activeFish.add(fish);
    } catch (e) {
      print('Error spawning fish in lane $lane: $e');
    }
  }

  /// Replace a fish that went off screen
  void _replaceFish(FishComponent oldFish) {
    // Kiểm tra cá đã được mount chưa trước khi remove
    if (oldFish.isMounted) {
      oldFish.removeFromParent();
    }
    _activeFish.remove(oldFish);

    // Spawn a new fish in the same lane
    _spawnFishInLane(oldFish.lane);
  }

  /// Handle fish tap
  void _onFishTapped(FishComponent fish) {
    // Nếu game không ở trạng thái playing hoặc đã kết thúc, không xử lý tap
    if (!_stateManager.isRunning || _gameEnded) return;

    // Đảm bảo fish vẫn còn mounted
    if (!fish.isMounted) return;

    if (fish.isCorrectAnswer) {
      _handleCorrectTap(fish);
    } else {
      _handleIncorrectTap(fish);
    }
  }

  /// Handle correct fish tap
  void _handleCorrectTap(FishComponent fish) {
    // Gọi callback khi chọn từ đúng
    if (onCorrectWord != null) {
      onCorrectWord!(fish.text);
    }

    // Play correct sound
    _resourceManager
        .playSoundEffect('../../assets/Feed the Shark/SFX đúng.mp3');

    // Stun the fish
    fish.stun();

    // Lưu lại con cá hiện tại đang bị ăn
    _currentEatenFish = fish;

    // Xác định hướng tấn công của cá mập dựa vào vị trí của con cá
    int attackDirection;
    final fishDistanceFromLeft = fish.position.x;
    final fishDistanceFromRight = gameSize.x - fish.position.x;

    // Nếu cá ở gần cạnh phải hơn, cá mập sẽ tấn công từ bên phải
    // Nếu cá ở gần cạnh trái hơn, cá mập sẽ tấn công từ bên trái
    if (fishDistanceFromLeft > fishDistanceFromRight) {
      // Cá ở gần cạnh phải hơn, cá mập tấn công từ phải sang
      attackDirection = -1;
    } else {
      // Cá ở gần cạnh trái hơn, cá mập tấn công từ trái sang
      attackDirection = 1;
    }

    // Send shark to eat the fish with the specified attack direction
    _shark.attack(fish.position, attackDirection: attackDirection);

    // Start fish "being eaten" animation
    fish.startEatingAnimation();

    // Increment correct answers
    _correctAnswersCount++;

    // Check if game is complete
    if (_correctAnswersCount >= requiredCorrectAnswers) {
      _endGame();
    }
  }

  /// Handle incorrect fish tap
  void _handleIncorrectTap(FishComponent fish) {
    // Gọi callback khi chọn từ sai
    if (onWrongWord != null) {
      onWrongWord!(fish.text);
    }

    // Play incorrect sound
    _resourceManager.playSoundEffect('../../assets/Feed the Shark/SFX sai.mp3');

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

    // Remove all fish and spawn new ones
    for (var fish in List.from(_activeFish)) {
      if (fish.isMounted) {
        fish.removeFromParent();
      }
      _activeFish.remove(fish);
    }

    // Set new target word and spawn initial fish
    _setNewTargetWord();
    _spawnInitialFish();
  }

  /// End the game
  void _endGame() {
    _gameEnded = true;

    // Chuyển sang trạng thái game over
    _stateManager.changeState(GameState.gameOver);
  }

  @override
  Future<void> onGameStart() async {
    // Reset game state
    _correctAnswersCount = 0;
    _gameEnded = false;

    // Đảm bảo tài nguyên đã được tải
    if (_stateManager.currentState == GameState.loading) {
      // Hiển thị màn hình loading nếu cần
      if (_loadingScreen == null) {
        _showLoadingScreen();
      }

      // Nếu chưa tải xong, đợi tải
      if (!_resourceManager.isLoaded) {
        // Đăng ký callback khi tải xong
        _resourceManager.addOnCompleteCallback(() {
          // Bắt đầu game khi tải xong
          _onLoadingComplete();
        });
      }
    } else {
      // Bắt đầu game mới nếu đã tải xong
      _stateManager.changeState(GameState.playing);

      // Start background music
      _resourceManager
          .playBackgroundMusic('../../assets/Feed the Shark/Nhạc BG.mp3');

      // Set the first target word and spawn initial fish
      _setNewTargetWord();
      _spawnInitialFish();
    }
  }

  @override
  Future<void> onGameEnd() async {
    // Đã xử lý trong state manager callback
  }

  @override
  void onRemove() {
    // Đảm bảo dừng hoàn toàn các hoạt động trong game
    _gameEnded = true;

    // Chuyển sang trạng thái kết thúc
    _stateManager.changeState(GameState.gameOver);

    // Dừng âm thanh
    _resourceManager.stopBackgroundMusic();

    super.onRemove();
  }

  /// Xử lý sự kiện khi cá bị ăn
  void _onFishEaten() {
    // Xóa con cá đã bị ăn khỏi game
    if (_currentEatenFish != null) {
      if (_currentEatenFish!.isMounted) {
        _currentEatenFish!.removeFromParent();
      }
      _activeFish.remove(_currentEatenFish);
      _currentEatenFish = null;
    }
  }

  /// Tạm dừng game
  void pauseGame() {
    _stateManager.pauseGame();
  }

  /// Tiếp tục game
  void resumeGame() {
    _stateManager.resumeGame();
  }

  /// Trạng thái hiện tại của game
  GameState get gameState => _stateManager.currentState;

  /// Tiến độ tải tài nguyên
  double get loadingProgress => _resourceManager.loadingProgress;
}
