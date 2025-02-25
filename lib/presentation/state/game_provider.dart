import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/card.dart';
import '../../domain/enums/game_state.dart';
import '../../domain/game.dart';
import '../../domain/player.dart';
import '../../application/game_service.dart';
import '../../application/ai_service.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService;
  final AIService _aiService;

  Game? _game;
  String _gameStatus = '';
  bool _isAIThinking = false;
  List<GameEvent> _recentEvents = [];

  // Timer for AI moves
  Timer? _aiMoveTimer;

  // Timer for displaying status messages
  Timer? _statusTimer;

  GameProvider({
    required GameService gameService,
    required AIService aiService,
  })  : _gameService = gameService,
        _aiService = aiService {
    _initializeListeners();
  }

  void _initializeListeners() {
    _gameService.eventStream.listen((event) {
      _handleGameEvent(event);
    });
  }

  // Getters
  Game? get game => _game;
  String get gameStatus => _gameStatus;
  bool get isAIThinking => _isAIThinking;
  List<GameEvent> get recentEvents => _recentEvents;

  // Initialize a new game
  Future<void> initializeGame({
    required int aiPlayerCount,
    required AIDifficulty difficulty,
    List<GameRuleVariant> ruleVariants = const [GameRuleVariant.standard],
  }) async {
    // Create a human player
    final humanPlayer = Player(
      name: 'You',
      type: PlayerType.human,
    );

    // Create AI players
    final List<Player> aiPlayers = [];
    for (int i = 0; i < aiPlayerCount; i++) {
      final PlayerType aiType;
      switch (difficulty) {
        case AIDifficulty.easy:
          aiType = PlayerType.aiEasy;
          break;
        case AIDifficulty.medium:
          aiType = PlayerType.aiMedium;
          break;
        case AIDifficulty.hard:
          aiType = PlayerType.aiHard;
          break;
      }

      aiPlayers.add(Player(
        name: 'AI ${i + 1}',
        type: aiType,
      ));
    }

    // Combine players
    final allPlayers = [humanPlayer, ...aiPlayers];

    // Initialize game in the service
    await _gameService.initializeGame(
      players: allPlayers,
      ruleVariants: ruleVariants,
    );

    // Start the game
    await _gameService.startGame();

    // Update state
    _game = _gameService.game;

    // Start AI move cycle if it's AI's turn
    _checkAndTriggerAIMove();

    notifyListeners();
  }

  // Play a card
  Future<void> playCard(Player player, Card card,
      {CardColor? chosenColor}) async {
    if (_game == null || player.type != PlayerType.human) return;

    final result =
        await _gameService.playCard(player, card, chosenColor: chosenColor);

    if (result) {
      _game = _gameService.game;
      _checkAndTriggerAIMove();
      notifyListeners();
    }
  }

  // Draw a card
  Future<void> drawCard(Player player) async {
    if (_game == null || player.type != PlayerType.human) return;

    final drawnCard = await _gameService.drawCard(player);

    if (drawnCard != null) {
      _game = _gameService.game;
      _checkAndTriggerAIMove();

      // Show what card was drawn
      _showStatus('Drew ${_cardToString(drawnCard)}');

      notifyListeners();
    }
  }

  // Call UNO
  Future<void> callUno(Player player) async {
    if (_game == null) return;

    final result = await _gameService.callUno(player);

    if (result) {
      _game = _gameService.game;
      _showStatus('${player.name} called UNO!');
      notifyListeners();
    }
  }

  // Catch UNO
  Future<void> catchUno(Player caller, Player target) async {
    if (_game == null) return;

    final result = await _gameService.catchUno(caller, target);

    if (result) {
      _game = _gameService.game;
      _showStatus('${caller.name} caught ${target.name} not saying UNO!');
      notifyListeners();
    } else {
      _showStatus('Cannot catch UNO');
    }
  }

  // Handle AI moves
  Future<void> _checkAndTriggerAIMove() async {
    if (_game == null || _isAIThinking || _game!.state != GameState.playing)
      return;

    final currentPlayer = _game!.currentPlayer;

    // Check if it's an AI player's turn
    if (currentPlayer.type != PlayerType.human) {
      _isAIThinking = true;
      notifyListeners();

      // Use a timer to add a delay for AI "thinking"
      _aiMoveTimer?.cancel();
      _aiMoveTimer = Timer(const Duration(milliseconds: 1000), () async {
        // Check and call UNO if AI has one card
        await _aiService.checkAndCallUno(_game!, currentPlayer);

        // Check if AI can catch another player with UNO
        for (final player in _game!.players) {
          if (player.id != currentPlayer.id &&
              player.hasUno &&
              !player.calledUno) {
            await _aiService.checkAndCatchUno(_game!, currentPlayer);
            break;
          }
        }

        // Make AI move
        final action = await _aiService.makeMove(_game!, currentPlayer);

        switch (action.type) {
          case AIActionType.playCard:
            if (action.card != null) {
              _showStatus(
                  '${currentPlayer.name} played ${_cardToString(action.card!)}');

              if (action.chosenColor != null) {
                _showStatus(
                    '${currentPlayer.name} chose ${_colorToString(action.chosenColor!)}');
              }
            }
            break;

          case AIActionType.drawCard:
            _showStatus('${currentPlayer.name} drew a card');
            break;

          case AIActionType.callUno:
            _showStatus('${currentPlayer.name} called UNO!');
            break;

          case AIActionType.catchUno:
            if (action.targetPlayer != null) {
              _showStatus(
                  '${currentPlayer.name} caught ${action.targetPlayer!.name} not saying UNO!');
            }
            break;

          default:
            break;
        }

        // Update game state
        _game = _gameService.game;
        _isAIThinking = false;

        // Check if the game is over
        if (_game!.state == GameState.finished) {
          _showStatus('Game Over! ${_game!.winner?.name} wins!');
        } else {
          // Check if it's still AI's turn (another AI player)
          _checkAndTriggerAIMove();
        }

        notifyListeners();
      });
    }
  }

  // Reset the game
  void resetGame() {
    _aiMoveTimer?.cancel();
    _statusTimer?.cancel();
    _gameService.resetGame();
    _game = null;
    _gameStatus = '';
    _isAIThinking = false;
    _recentEvents = [];
    notifyListeners();
  }

  // Handle game events
  void _handleGameEvent(GameEvent event) {
    // Add to recent events
    _recentEvents.add(event);
    if (_recentEvents.length > 10) {
      _recentEvents.removeAt(0);
    }

    // Update game reference
    _game = event.game;

    // Handle specific events
    switch (event.type) {
      case GameEventType.gameStarted:
        _showStatus('Game started');
        break;

      case GameEventType.gameEnded:
        final winner = _game?.winner;
        if (winner != null) {
          _showStatus('Game Over! ${winner.name} wins!');
        } else {
          _showStatus('Game Over!');
        }
        break;

      case GameEventType.cardPlayed:
        if (event.player != null && event.card != null) {
          _showStatus(
              '${event.player!.name} played ${_cardToString(event.card!)}');
        }
        break;

      case GameEventType.cardDrawn:
        if (event.player != null) {
          _showStatus('${event.player!.name} drew a card');
        }
        break;

      case GameEventType.unoCalled:
        if (event.player != null) {
          _showStatus('${event.player!.name} called UNO!');
        }
        break;

      case GameEventType.unoCaught:
        if (event.player != null && event.targetPlayer != null) {
          _showStatus(
              '${event.player!.name} caught ${event.targetPlayer!.name} not saying UNO!');
        }
        break;

      case GameEventType.error:
        if (event.message != null) {
          _showStatus('Error: ${event.message}');
        }
        break;

      default:
        break;
    }

    notifyListeners();
  }

  // Show a status message for a limited time
  void _showStatus(String message) {
    _gameStatus = message;

    _statusTimer?.cancel();
    _statusTimer = Timer(const Duration(seconds: 3), () {
      _gameStatus = '';
      notifyListeners();
    });
  }

  // Helper to convert card to string representation
  String _cardToString(Card card) {
    String colorStr = _colorToString(card.color);

    switch (card.type) {
      case CardType.number:
        return '$colorStr ${card.value}';
      case CardType.skip:
        return '$colorStr Skip';
      case CardType.reverse:
        return '$colorStr Reverse';
      case CardType.drawTwo:
        return '$colorStr Draw Two';
      case CardType.wild:
        return 'Wild';
      case CardType.wildDrawFour:
        return 'Wild Draw Four';
    }
  }

  // Helper to convert color to string representation
  String _colorToString(CardColor color) {
    switch (color) {
      case CardColor.red:
        return 'Red';
      case CardColor.blue:
        return 'Blue';
      case CardColor.green:
        return 'Green';
      case CardColor.yellow:
        return 'Yellow';
      case CardColor.wild:
        return 'Wild';
    }
  }

  @override
  void dispose() {
    _aiMoveTimer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }
}
