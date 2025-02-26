import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/card.dart';
import '../domain/deck.dart';
import '../domain/player.dart';
import '../domain/game.dart';
import '../domain/enums/game_state.dart';

/// Service responsible for managing game state and orchestrating game flow
class GameService extends ChangeNotifier {
  /// The current game instance
  Game? _game;

  /// Stream controller for game events
  final StreamController<GameEvent> _eventController =
      StreamController<GameEvent>.broadcast();

  /// Stream of game events
  Stream<GameEvent> get eventStream => _eventController.stream;

  /// Current game rule variants in effect
  final Set<GameRuleVariant> _activeRuleVariants = {GameRuleVariant.standard};

  /// Creates a new GameService
  GameService();

  /// Initializes a new game with the specified players and rule variants
  Future<bool> initializeGame({
    required List<Player> players,
    List<GameRuleVariant> ruleVariants = const [GameRuleVariant.standard],
    bool allowPlayingDrawnCard = true,
    int unoPenaltyCardCount = 2,
  }) async {
    if (players.length < 2) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Need at least 2 players to start a game',
      ));
      return false;
    }

    // Reset active rule variants
    _activeRuleVariants.clear();
    _activeRuleVariants.addAll(ruleVariants);

    // Create a new game instance
    _game = Game(
      players: players,
      allowPlayingDrawnCard: allowPlayingDrawnCard,
      unoPenaltyCardCount: unoPenaltyCardCount,
    );

    _emitEvent(GameEvent(
      type: GameEventType.gameInitialized,
      game: _game,
    ));

    notifyListeners();
    return true;
  }

  /// Starts the game
  Future<bool> startGame() async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    final result = _game!.start();
    if (!result.success) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: result.message,
      ));
      return false;
    }

    _emitEvent(GameEvent(
      type: GameEventType.gameStarted,
      game: _game,
      card: result.card,
    ));

    notifyListeners();
    return true;
  }

  /// Handles a player playing a card
  Future<bool> playCard(Player player, Card card,
      {CardColor? chosenColor}) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    final result = _game!.playCard(player, card, chosenColor: chosenColor);
    if (!result.success) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: result.message,
      ));
      return false;
    }

    final eventType = _game!.state == GameState.finished
        ? GameEventType.gameEnded
        : GameEventType.cardPlayed;

    _emitEvent(GameEvent(
      type: eventType,
      game: _game,
      player: player,
      card: card,
      message: result.message,
    ));

    notifyListeners();
    return true;
  }

  /// Handles a player drawing a card
  Future<Card?> drawCard(Player player) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return null;
    }

    final result = _game!.drawCard(player);
    if (!result.success) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: result.message,
      ));
      return null;
    }

    _emitEvent(GameEvent(
      type: GameEventType.cardDrawn,
      game: _game,
      player: player,
      card: result.card,
      message: result.message,
    ));

    notifyListeners();
    return result.card;
  }

  /// Handles a player calling UNO
  Future<bool> callUno(Player player) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    final result = _game!.callUno(player);
    if (!result.success) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: result.message,
      ));
      return false;
    }

    _emitEvent(GameEvent(
      type: GameEventType.unoCalled,
      game: _game,
      player: player,
    ));

    notifyListeners();
    return true;
  }

  /// Handles a player catching another player who didn't call UNO
  Future<bool> catchUno(Player caller, Player target) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    final result = _game!.catchUno(caller, target);
    if (!result.success) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: result.message,
      ));
      return false;
    }

    _emitEvent(GameEvent(
      type: GameEventType.unoCaught,
      game: _game,
      player: caller,
      targetPlayer: target,
      message: result.message,
    ));

    notifyListeners();
    return true;
  }

  /// Adds a player to the game (before it's started)
  Future<bool> addPlayer(Player player) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    if (_game!.state != GameState.notStarted) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Cannot add player after game has started',
      ));
      return false;
    }

    // Check if player with same ID already exists
    if (_game!.players.any((p) => p.id == player.id)) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Player with same ID already exists',
      ));
      return false;
    }

    _game!.players.add(player);

    _emitEvent(GameEvent(
      type: GameEventType.playerJoined,
      game: _game,
      player: player,
    ));

    notifyListeners();
    return true;
  }

  /// Removes a player from the game (before it's started)
  Future<bool> removePlayer(Player player) async {
    if (_game == null) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Game not initialized',
      ));
      return false;
    }

    if (_game!.state != GameState.notStarted) {
      // If game is in progress, mark player as inactive instead
      if (_game!.state == GameState.playing) {
        final playerToRemove = _game!.players.firstWhere(
          (p) => p.id == player.id,
          orElse: () => player,
        );

        playerToRemove.isActive = false;

        // If current player is being removed, move to next player
        if (_game!.currentPlayer.id == player.id) {
          // We need to manually call _nextPlayer since it's private
          // This is a bit of a hack, but we're accessing a private method
          // In a real implementation, consider adding a public method for this
          if (_game!.players.where((p) => p.isActive).length > 1) {
            // Move to next player
            int nextIndex = _game!.currentPlayerIndex;
            do {
              if (_game!.direction == Direction.clockwise) {
                nextIndex = (nextIndex + 1) % _game!.players.length;
              } else {
                nextIndex = (nextIndex - 1 + _game!.players.length) %
                    _game!.players.length;
              }
            } while (!_game!.players[nextIndex].isActive &&
                _game!.players.where((p) => p.isActive).length > 1);

            _game!.currentPlayerIndex = nextIndex;
          }
        }

        _emitEvent(GameEvent(
          type: GameEventType.playerLeft,
          game: _game,
          player: player,
        ));

        notifyListeners();
        return true;
      }

      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Cannot remove player after game has started',
      ));
      return false;
    }

    final removed = _game!.players.remove(player);
    if (!removed) {
      _emitEvent(GameEvent(
        type: GameEventType.error,
        message: 'Player not found in game',
      ));
      return false;
    }

    _emitEvent(GameEvent(
      type: GameEventType.playerLeft,
      game: _game,
      player: player,
    ));

    notifyListeners();
    return true;
  }

  /// Resets the current game
  void resetGame() {
    _game = null;

    _emitEvent(GameEvent(
      type: GameEventType.gameReset,
    ));

    notifyListeners();
  }

  /// Gets the current game
  Game? get game => _game;

  /// Gets whether a particular rule variant is active
  bool isRuleVariantActive(GameRuleVariant variant) {
    return _activeRuleVariants.contains(variant);
  }

  /// Gets the list of active rule variants
  Set<GameRuleVariant> get activeRuleVariants =>
      Set.unmodifiable(_activeRuleVariants);

  /// Emits a game event
  void _emitEvent(GameEvent event) {
    _eventController.add(event);
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}

/// Types of game events
enum GameEventType {
  /// Game is initialized but not started
  gameInitialized,

  /// Game has started
  gameStarted,

  /// Game has ended
  gameEnded,

  /// Game has been reset
  gameReset,

  /// A card was played
  cardPlayed,

  /// A card was drawn
  cardDrawn,

  /// A player called UNO
  unoCalled,

  /// A player was caught not calling UNO
  unoCaught,

  /// A player joined the game
  playerJoined,

  /// A player left the game
  playerLeft,

  /// An error occurred
  error,
}

/// Represents a game event
class GameEvent {
  /// Type of event
  final GameEventType type;

  /// Game instance related to the event
  final Game? game;

  /// Player who triggered the event
  final Player? player;

  /// Target player (for events like UNO catch)
  final Player? targetPlayer;

  /// Card involved in the event
  final Card? card;

  /// Event message
  final String? message;

  /// Timestamp of the event
  final DateTime timestamp;

  /// Creates a new game event
  GameEvent({
    required this.type,
    this.game,
    this.player,
    this.targetPlayer,
    this.card,
    this.message,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'GameEvent{type: $type, player: ${player?.name}, '
        'card: ${card?.toString()}, message: $message}';
  }
}
