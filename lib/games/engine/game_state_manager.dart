import 'package:flutter/foundation.dart';

/// Định nghĩa các trạng thái game cơ bản
enum GameState {
  /// Trạng thái đang tải tài nguyên
  loading,

  /// Trạng thái sẵn sàng chơi
  ready,

  /// Trạng thái đang chơi
  playing,

  /// Trạng thái tạm dừng
  paused,

  /// Trạng thái kết thúc
  gameOver,
}

/// Manager quản lý trạng thái của game
class GameStateManager extends ChangeNotifier {
  /// Trạng thái hiện tại của game
  GameState _currentState = GameState.loading;

  /// Trạng thái trước đó của game
  GameState? _previousState;

  /// Timestamp khi trạng thái thay đổi
  DateTime _lastStateChangeTime = DateTime.now();

  /// Thời gian ở trạng thái hiện tại (milliseconds)
  int get timeInCurrentState =>
      DateTime.now().difference(_lastStateChangeTime).inMilliseconds;

  /// Các callback khi trạng thái thay đổi
  final Map<GameState, List<void Function()>> _stateChangeCallbacks = {};

  /// Constructor
  GameStateManager({GameState initialState = GameState.loading}) {
    _currentState = initialState;
    _lastStateChangeTime = DateTime.now();

    // Khởi tạo danh sách callback trống cho mỗi state
    for (final state in GameState.values) {
      _stateChangeCallbacks[state] = [];
    }
  }

  /// Trạng thái hiện tại
  GameState get currentState => _currentState;

  /// Trạng thái trước đó
  GameState? get previousState => _previousState;

  /// Kiểm tra game đang ở trạng thái nào
  bool isInState(GameState state) => _currentState == state;

  /// Chuyển sang trạng thái mới
  void changeState(GameState newState) {
    if (_currentState == newState) return;

    _previousState = _currentState;
    _currentState = newState;
    _lastStateChangeTime = DateTime.now();

    // Gọi các callbacks cho trạng thái mới
    _notifyStateChangeCallbacks();

    // Thông báo cho listeners
    notifyListeners();
  }

  /// Quay lại trạng thái trước đó
  void restorePreviousState() {
    if (_previousState != null) {
      final tempState = _currentState;
      _currentState = _previousState!;
      _previousState = tempState;
      _lastStateChangeTime = DateTime.now();

      // Gọi các callbacks cho trạng thái mới
      _notifyStateChangeCallbacks();

      // Thông báo cho listeners
      notifyListeners();
    }
  }

  /// Thêm callback cho trạng thái
  void addStateCallback(GameState state, void Function() callback) {
    _stateChangeCallbacks[state]?.add(callback);
  }

  /// Xóa callback khỏi trạng thái
  void removeStateCallback(GameState state, void Function() callback) {
    _stateChangeCallbacks[state]?.remove(callback);
  }

  /// Xóa tất cả callbacks cho trạng thái
  void clearStateCallbacks(GameState state) {
    _stateChangeCallbacks[state]?.clear();
  }

  /// Gọi các callbacks cho trạng thái hiện tại
  void _notifyStateChangeCallbacks() {
    final callbacks = _stateChangeCallbacks[_currentState] ?? [];
    for (final callback in callbacks) {
      callback();
    }
  }

  /// Bắt đầu game
  void startGame() => changeState(GameState.playing);

  /// Tạm dừng game
  void pauseGame() {
    if (_currentState == GameState.playing) {
      changeState(GameState.paused);
    }
  }

  /// Tiếp tục game
  void resumeGame() {
    if (_currentState == GameState.paused) {
      changeState(GameState.playing);
    }
  }

  /// Kết thúc game
  void endGame() => changeState(GameState.gameOver);

  /// Reset game về trạng thái sẵn sàng
  void resetGame() => changeState(GameState.ready);

  /// Game có đang chạy không
  bool get isRunning => _currentState == GameState.playing;

  /// Game có đang tạm dừng không
  bool get isPaused => _currentState == GameState.paused;

  /// Game đã kết thúc chưa
  bool get isGameOver => _currentState == GameState.gameOver;

  /// Game đang tải tài nguyên
  bool get isLoading => _currentState == GameState.loading;

  /// Game sẵn sàng chơi
  bool get isReady => _currentState == GameState.ready;
}
