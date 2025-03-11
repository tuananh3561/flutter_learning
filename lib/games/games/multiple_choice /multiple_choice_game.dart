import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/games/components/background_components.dart';

import '../../components/loading_screen.dart';
import '../../engine/game_engine.dart';
import '../../engine/game_state_manager.dart';
import '../../engine/resource_manager.dart';
import '../../components/audio_button_component.dart';
import '../../components/image_card_component.dart';
import '../../components/drop_zone_component.dart';
import '../../components/rounded_rect_painter_component.dart';
import 'managers/vocabulary_repository.dart';
import 'managers/audio_button_pool.dart';
import 'managers/animation_controller.dart';
import 'managers/game_config_manager.dart';

/// Game Multiple Choice - Trò chơi nối từ vựng với hình ảnh thông qua âm thanh
class MultipleChoiceGame extends BaseGame {
  /// GameConfigManager - quản lý cấu hình game
  final GameConfigManager _configManager = GameConfigManager();

  /// Số lượt chơi cần để hoàn thành game
  late final int requiredRounds;

  /// Số lượng đáp án cho mỗi lượt chơi
  late final int numberOfChoices;

  /// Loại game (Drop hoặc Tap)
  late final String typeGame;

  /// Lượt chơi hiện tại
  int _currentRound = 0;

  /// Số lượng câu trả lời đúng
  int _correctAnswers = 0;

  /// Random generator
  final Random _random = Random();

  /// Từ vựng hiện tại cần ghép
  Map<String, dynamic>? _currentTarget;

  /// Danh sách từ vựng hiện tại đang hiển thị
  List<Map<String, dynamic>> _currentChoices = [];

  /// ResourceManager - quản lý tài nguyên
  final ResourceManager _resourceManager = ResourceManager();

  /// StateManager - quản lý trạng thái game
  final GameStateManager _stateManager = GameStateManager();

  /// VocabularyRepository - quản lý từ vựng
  late final VocabularyRepository _vocabularyRepository;

  /// AudioButtonPool - quản lý pool các audio button
  late final AudioButtonPool _audioButtonPool;

  /// AirplaneAnimationController - quản lý animation máy bay
  late final AirplaneAnimationController _airplaneAnimationController;

  /// Loading screen component
  LoadingScreen? _loadingScreen;

  /// Background and decorations component
  late BackgroundComponents _backgroundComponents;

  /// Component con máy bay (Spine)
  SpineComponent? _airplaneComponent;

  /// Component box câu hỏi
  CustomPainterComponent? _boxQuestion;

  /// Component hiển thị hình ảnh từ vựng mục tiêu
  ImageCardComponent? _targetImageCard;

  /// Danh sách các nút audio
  final List<AudioButtonComponent> _audioButtons = [];

  /// Danh sách các drop zones
  final List<DropZoneComponent> _dropZones = [];

  /// Theo dõi trạng thái tải tài nguyên
  bool _resourcesLoaded = false;

  /// Theo dõi trạng thái tạm dừng
  bool _isPaused = false;

  /// Callback khi game kết thúc
  final Function? onGameComplete;

  /// Callback khi ghép đúng từ
  final Function(String)? onCorrectMatch;

  /// Callback khi ghép sai từ
  final Function(String)? onWrongMatch;

  /// Path to the background config file
  late final String backgroundConfigPath;

  /// Constructor
  MultipleChoiceGame({
    required Vector2 gameSize,
    int? requiredRounds,
    int? numberOfChoices,
    String? typeGame,
    this.onGameComplete,
    this.onCorrectMatch,
    this.onWrongMatch,
    String? backgroundConfigPath,
  }) : super(gameSize: gameSize) {
    _loadConfig();

    // Sử dụng giá trị từ tham số nếu được cung cấp, nếu không sử dụng giá trị từ cấu hình
    this.requiredRounds =
        requiredRounds ?? _configManager.gameSettings['requiredRounds'] ?? 5;
    this.numberOfChoices =
        numberOfChoices ?? _configManager.gameSettings['numberOfChoices'] ?? 3;
    this.typeGame =
        typeGame ?? _configManager.gameSettings['typeGame'] ?? 'Drop';
    this.backgroundConfigPath = backgroundConfigPath ??
        _configManager.gameSettings['backgroundConfigPath'] ??
        'assets/Multiple Choice/background_config.json';

    _setupManagers();
    _setupStateCallbacks();
  }

  /// Tải cấu hình game
  void _loadConfig() {
    try {
      if (!_configManager.isLoaded) {
        // Tải đồng bộ trong constructor, trong thực tế nên tải bất đồng bộ
        _configManager.loadConfig();
      }
    } catch (e) {
      print('Error loading game config: $e');
    }
  }

  /// Khởi tạo các managers
  void _setupManagers() {
    _vocabularyRepository = VocabularyRepository();
    _audioButtonPool = AudioButtonPool();
    _airplaneAnimationController =
        AirplaneAnimationController(_resourceManager);
  }

  /// Thiết lập callbacks cho state manager
  void _setupStateCallbacks() {
    // Khi trạng thái chuyển sang playing
    _stateManager.addStateCallback(GameState.playing, () {
      if (!_resourcesLoaded) return;
      _isPaused = false;
    });

    // Khi trạng thái chuyển sang paused
    _stateManager.addStateCallback(GameState.paused, () {
      _isPaused = true;
      _resourceManager.pauseBackgroundMusic();
    });

    // Khi trạng thái chuyển sang gameOver
    _stateManager.addStateCallback(GameState.gameOver, () {
      _resourceManager.stopBackgroundMusic();
      _showEndingAnimation();

      if (onGameComplete != null) {
        Future.delayed(const Duration(seconds: 5), () {
          onGameComplete!();
        });
      }
    });
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _stateManager.changeState(GameState.loading);
    _showLoadingScreen();
    await _loadGameAssets();
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
      await _resourceManager.loadResources('multiplechoice');
      await _vocabularyRepository.initialize();
      await _audioButtonPool.initialize(gameSize, numberOfChoices);
      await _airplaneAnimationController.initialize();
      _resourcesLoaded = true;
    } catch (e) {
      print('Error loading game assets: $e');
      // Hiển thị thông báo lỗi
      _showErrorMessage('Không thể tải tài nguyên game');
    }
  }

  /// Hiển thị thông báo lỗi
  void _showErrorMessage(String message) {
    // Thêm logic hiển thị lỗi ở đây
    print('ERROR: $message');
  }

  /// Xử lý khi tải tài nguyên hoàn tất
  void _onLoadingComplete() {
    if (_loadingScreen != null && _loadingScreen!.isMounted) {
      _loadingScreen!.removeFromParent();
      _loadingScreen = null;
    }

    _stateManager.changeState(GameState.ready);
    _startGame();
  }

  /// Bắt đầu game sau khi tải xong tài nguyên
  Future<void> _startGame() async {
    _initializeBackground();
    await _showIntroAnimation();
    _stateManager.changeState(GameState.playing);
    await _startNewRound();
  }

  /// Khởi tạo background
  void _initializeBackground() {
    _backgroundComponents = BackgroundComponents(
      configFilePath: backgroundConfigPath,
      gameSize: gameSize,
    );
    add(_backgroundComponents);
  }

  /// Hiển thị animation intro
  Future<void> _showIntroAnimation() async {
    try {
      _airplaneComponent =
          await _airplaneAnimationController.getAirplaneComponent(
        position: Vector2(gameSize.x / 2 + 30, gameSize.y / 2 - 10),
        scale: Vector2(0.18, 0.18),
      );

      add(_airplaneComponent!);
      await _airplaneAnimationController
          .playIntroAnimation(_airplaneComponent!);
    } catch (e) {
      print('Error showing intro animation: $e');
    }
  }

  /// Hiển thị animation kết thúc
  Future<void> _showEndingAnimation() async {
    try {
      await _airplaneAnimationController.playEndingAnimation(
        _airplaneComponent,
        onComplete: () {
          // Animation kết thúc
        },
      );
    } catch (e) {
      print('Error showing ending animation: $e');
    }
  }

  /// Bắt đầu lượt chơi mới
  Future<void> _startNewRound() async {
    _currentRound++;
    _clearRoundComponents();

    await _airplaneAnimationController.playNextAnimation(_airplaneComponent);

    _prepareRoundData();
    _setupRoundUI();
  }

  /// Chuẩn bị dữ liệu cho lượt chơi
  void _prepareRoundData() {
    _selectTargetWord();
    _generateChoices();
  }

  /// Xóa các component từ lượt trước
  void _clearRoundComponents() {
    _removeComponent(_boxQuestion);
    _removeComponent(_targetImageCard);

    // Xóa các nút audio
    for (final button in _audioButtons) {
      if (button.isMounted) {
        _audioButtonPool.release(button);
        button.removeFromParent();
      }
    }
    _audioButtons.clear();

    // Xóa các drop zones
    for (final zone in _dropZones) {
      if (zone.isMounted) {
        zone.removeFromParent();
      }
    }
    _dropZones.clear();
  }

  /// Helper để xóa component an toàn
  void _removeComponent(Component? component) {
    if (component != null && component.isMounted) {
      component.removeFromParent();
    }
  }

  /// Chọn từ vựng làm mục tiêu
  void _selectTargetWord() {
    final vocabularyList = _vocabularyRepository.getVocabularyList();
    _currentTarget = vocabularyList[_random.nextInt(vocabularyList.length)];
  }

  /// Tạo các lựa chọn cho lượt chơi
  void _generateChoices() {
    _currentChoices = [];

    // Thêm từ vựng mục tiêu vào danh sách
    _currentChoices.add(_currentTarget!);

    // Lấy danh sách từ vựng không bao gồm từ mục tiêu
    final vocabularyList = _vocabularyRepository.getVocabularyList();
    List<Map<String, dynamic>> tempPool = List.from(vocabularyList)
      ..removeWhere((item) => item['text'] == _currentTarget!['text']);

    // Chọn ngẫu nhiên các từ vựng khác
    tempPool.shuffle(_random);
    _currentChoices.addAll(tempPool.take(numberOfChoices - 1));

    // Xáo trộn lại danh sách lựa chọn
    _currentChoices.shuffle(_random);
  }

  /// Thiết lập giao diện cho lượt chơi
  void _setupRoundUI() {
    _createBoxQuestion();
    _showTargetImage();
    _createDropZones();
    _createAudioButtons();
    _playTargetAudio();
  }

  void _createBoxQuestion() {
    final boxConfig = _configManager.questionConfig['boxQuestion'];
    final position = _configManager.getVector2(
        'boxQuestion', 'position', boxConfig['position'], gameSize);
    final size = _configManager.getVector2(
        'boxQuestion', 'size', boxConfig['size'], gameSize);
    final color = _configManager.getColor(
        'boxQuestion', 'backgroundColor', boxConfig['backgroundColor']);
    final borderRadius = boxConfig['borderRadius']?.toDouble() ?? 15.0;

    final roundedRectPainter = RoundedRectPainter(
      color: color,
      borderRadius: borderRadius,
    );

    _boxQuestion = CustomPainterComponent(
      painter: roundedRectPainter,
      position: position,
      size: size,
    );

    add(_boxQuestion!);
  }

  /// Hiển thị hình ảnh từ vựng mục tiêu
  void _showTargetImage() {
    final targetConfig = _configManager.questionConfig['targetImage'];
    final imagePath = targetConfig['path']
        .toString()
        .replaceAll('{text}', _currentTarget!['text']);
    final position = _configManager.getVector2(
        'targetImage', 'position', targetConfig['position'], gameSize);
    final size = _configManager.getVector2(
        'targetImage', 'size', targetConfig['size'], gameSize);
    final borderColor = _configManager.getColor(
        'targetImage', 'borderColor', targetConfig['borderColor']);
    final priority = targetConfig['priority'] ?? 80;

    _targetImageCard = ImageCardComponent(
      imagePath: imagePath,
      position: position,
      size: size,
      text: '',
      borderColor: borderColor,
    );

    _targetImageCard!.priority = priority;
    add(_targetImageCard!);
  }

  /// Tạo các nút audio
  void _createAudioButtons() {
    final buttonConfig = _configManager.answerConfig['audioButtons'];
    final buttonSize = _configManager.getVector2('audioButtons', 'buttonSize',
        buttonConfig['layout']['buttonSize'], gameSize);

    for (int i = 0; i < _currentChoices.length; i++) {
      final choice = _currentChoices[i];

      // Lấy button từ pool với index cụ thể
      final audioButton = _audioButtonPool.getAtIndex(
        index: i,
        text: choice['text'],
        audioFile: choice['audio'],
        size: buttonSize,
        onDrop: _handleDrop,
        onTap: () => _resourceManager.playWordSound(choice['audio']),
      );

      add(audioButton);
      _audioButtons.add(audioButton);
    }
  }

  /// Tạo các ô drop
  void _createDropZones() {
    final dropConfig = _configManager.dropZoneConfig;

    // Kiểm tra nếu drop zones được bật
    if (dropConfig['enabled'] == true) {
      final zones = dropConfig['zones'];

      for (int i = 0; i < zones.length; i++) {
        final zone = zones[i];
        final position = _configManager.getVector2(
            'dropZone_$i', 'position', zone['position'], gameSize);
        final size = _configManager.getVector2(
            'dropZone_$i', 'size', zone['size'], gameSize);

        final dropZone = DropZoneComponent(
          id: zone['id'],
          position: position,
          size: size,
        );

        add(dropZone);
        _dropZones.add(dropZone);
      }
    }
  }

  /// Phát âm thanh từ vựng mục tiêu
  void _playTargetAudio() {
    _resourceManager.playWordSound(_currentTarget!['audio']);
  }

  /// Xử lý khi kéo nút audio vào ô drop
  void _handleDrop(String text) {
    AudioButtonComponent? currentButton = _findAudioButtonByText(text);

    if (text == _currentTarget!['text']) {
      _handleCorrectAnswer(currentButton);
    } else {
      _handleWrongAnswer(text, currentButton);
    }
  }

  /// Tìm audio button theo text
  AudioButtonComponent? _findAudioButtonByText(String text) {
    for (final button in _audioButtons) {
      if (button.text == text) {
        return button;
      }
    }
    return null;
  }

  /// Xử lý khi trả lời đúng
  void _handleCorrectAnswer(AudioButtonComponent? button) {
    _playCorrectSound();
    _correctAnswers++;

    if (button != null) {
      button.setCorrect();
    }

    _notifyCorrectMatch();
    _showTargetText();
    _scheduleNextRound();
  }

  /// Phát âm thanh khi trả lời đúng
  void _playCorrectSound() {
    final soundConfig = _configManager.soundConfig;
    final correctSound = soundConfig['effectSounds']['correct'];
    _resourceManager.playSoundEffect(correctSound);
  }

  /// Thông báo khi trả lời đúng
  void _notifyCorrectMatch() {
    if (onCorrectMatch != null) {
      onCorrectMatch!(_currentTarget!['text']);
    }
  }

  /// Hiển thị text từ vựng đúng trên hình ảnh
  void _showTargetText() {
    if (_targetImageCard != null && _targetImageCard!.isMounted) {
      final textComponent = TextComponent(
        text: _currentTarget!['text'],
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.green,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        anchor: Anchor.center,
        position: Vector2(100, 230),
      );
      _targetImageCard!.add(textComponent);
    }
  }

  /// Lên lịch cho lượt chơi tiếp theo
  void _scheduleNextRound() {
    if (_currentRound >= requiredRounds) {
      Future.delayed(const Duration(seconds: 2), _endGame);
    } else {
      Future.delayed(const Duration(seconds: 2), _startNewRound);
    }
  }

  /// Xử lý khi trả lời sai
  void _handleWrongAnswer(String text, AudioButtonComponent? button) {
    _playWrongSound();

    if (button != null) {
      button.setIncorrect();
    }

    _notifyWrongMatch(text);
    _scheduleResetButtons();
  }

  /// Phát âm thanh khi trả lời sai
  void _playWrongSound() {
    final soundConfig = _configManager.soundConfig;
    final wrongSound = soundConfig['effectSounds']['wrong'];
    _resourceManager.playSoundEffect(wrongSound);
  }

  /// Thông báo khi trả lời sai
  void _notifyWrongMatch(String text) {
    if (onWrongMatch != null) {
      onWrongMatch!(text);
    }
  }

  /// Lên lịch đặt lại các nút
  void _scheduleResetButtons() {
    Future.delayed(const Duration(seconds: 1), () {
      for (final button in _audioButtons) {
        button.reset();
      }
    });
  }

  /// Kết thúc game
  void _endGame() {
    _stateManager.changeState(GameState.gameOver);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Không update game logic khi không phải trạng thái playing hoặc đang tạm dừng
    if (_stateManager.currentState != GameState.playing || _isPaused) return;
  }

  @override
  void onRemove() {
    // Dừng âm thanh
    _resourceManager.stopBackgroundMusic();

    // Giải phóng tài nguyên
    _audioButtonPool.dispose();
    _airplaneAnimationController.dispose();

    super.onRemove();
  }

  /// Tạm dừng game
  void pauseGame() {
    _stateManager.pauseGame();
  }

  /// Tiếp tục game
  void resumeGame() {
    _stateManager.resumeGame();
  }

  /// Lấy trạng thái hiện tại của game
  GameState get gameState => _stateManager.currentState;

  @override
  Future<void> onGameStart() async {
    // Reset game state
    _currentRound = 0;
    _correctAnswers = 0;

    if (_stateManager.currentState == GameState.loading) {
      if (_loadingScreen == null) {
        _showLoadingScreen();
      }

      if (!_resourcesLoaded) {
        _resourceManager.addOnCompleteCallback(_onLoadingComplete);
      }
    } else {
      _stateManager.changeState(GameState.playing);
      await _startNewRound();
    }
  }

  @override
  Future<void> onGameEnd() async {
    _stateManager.changeState(GameState.gameOver);
  }
}
