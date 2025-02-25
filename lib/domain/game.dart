import 'package:uuid/uuid.dart';
import 'card.dart';
import 'deck.dart';
import 'player.dart';

/// Direction of play
enum Direction { clockwise, counterClockwise }

/// Current state of the game
enum GameState { notStarted, playing, finished }

/// Result of a player's action
class ActionResult {
  final bool success;
  final String message;
  final Card? card;

  const ActionResult({this.success = true, this.message = '', this.card});

  const ActionResult.failure(String message)
      : success = false,
        message = message,
        card = null;

  const ActionResult.success(String message, {Card? card})
      : success = true,
        message = message,
        card = card;
}

/// Represents an UNO game
class Game {
  final String id;
  final List<Player> players;
  final Deck deck;
  late CardColor currentColor;
  int currentPlayerIndex = 0;
  Direction direction = Direction.clockwise;
  GameState state = GameState.notStarted;
  DateTime? startTime;
  DateTime? endTime;

  /// The player who won the game (null if game not finished)
  Player? winner;

  /// Number of cards to draw when catching someone who didn't call UNO
  final int unoPenaltyCardCount;

  /// Whether to allow playing a drawn card immediately
  final bool allowPlayingDrawnCard;

  /// History of actions in the game for replay/undo
  final List<Map<String, dynamic>> _actionHistory = [];

  /// Creates a new UNO game with the given players
  Game(
      {String? id,
      required this.players,
      Deck? deck,
      this.unoPenaltyCardCount = 2,
      this.allowPlayingDrawnCard = true})
      : id = id ?? const Uuid().v4(),
        deck = deck ?? Deck();

  /// Starts the game
  ActionResult start() {
    if (players.length < 2) {
      return const ActionResult.failure("Need at least 2 players to start");
    }

    if (state != GameState.notStarted) {
      return const ActionResult.failure("Game already started");
    }

    startTime = DateTime.now();

    // Deal 7 cards to each player
    for (int i = 0; i < 7; i++) {
      for (final player in players) {
        player.addCard(deck.drawCard());
      }
    }

    // Draw the first card for the discard pile
    final initialCard = deck.setupGame();
    currentColor = initialCard.color;

    // Apply effect of initial card
    _applyCardEffect(initialCard);

    state = GameState.playing;

    _addToHistory(action: 'start_game', data: {
      'initial_card': initialCard.toString(),
      'initial_player': currentPlayerIndex,
    });

    return ActionResult.success("Game started successfully", card: initialCard);
  }

  /// Plays a card from the player's hand
  ActionResult playCard(Player player, Card card, {CardColor? chosenColor}) {
    if (state != GameState.playing) {
      return const ActionResult.failure("Game not in progress");
    }

    if (players[currentPlayerIndex].id != player.id) {
      return const ActionResult.failure("Not this player's turn");
    }

    if (!card.canBePlayedOn(deck.topCard, currentColor)) {
      return const ActionResult.failure("Invalid card play");
    }

    // Wild cards need a chosen color
    if ((card.type == CardType.wild || card.type == CardType.wildDrawFour) &&
        chosenColor == null) {
      return const ActionResult.failure("Must choose a color for wild card");
    }

    // Remove card from player's hand
    if (!player.removeCard(card)) {
      return const ActionResult.failure("Player doesn't have this card");
    }

    // Add to discard pile
    deck.discard(card);

    // Update current color for wild cards
    if (card.type == CardType.wild || card.type == CardType.wildDrawFour) {
      currentColor = chosenColor!;
    } else {
      currentColor = card.color;
    }

    _addToHistory(action: 'play_card', data: {
      'player_id': player.id,
      'card': card.toString(),
      'chosen_color': chosenColor?.toString(),
    });

    // Apply card effect
    _applyCardEffect(card);

    // Check win condition
    if (player.hasWon) {
      _endGame(player);
      return ActionResult.success("Player ${player.name} wins!", card: card);
    }

    // Move to next player (if not already done by card effects)
    if (card.type != CardType.skip &&
        card.type != CardType.drawTwo &&
        card.type != CardType.wildDrawFour) {
      _nextPlayer();
    }

    return ActionResult.success("Card played successfully", card: card);
  }

  /// Draws a card for the current player
  ActionResult drawCard(Player player) {
    if (state != GameState.playing) {
      return const ActionResult.failure("Game not in progress");
    }

    if (players[currentPlayerIndex].id != player.id) {
      return const ActionResult.failure("Not this player's turn");
    }

    final card = deck.drawCard();
    player.addCard(card);

    _addToHistory(action: 'draw_card', data: {
      'player_id': player.id,
      'card': card.toString(),
    });

    // If drawn card can be played and rules allow, player can play it
    final canPlayDrawnCard =
        allowPlayingDrawnCard && card.canBePlayedOn(deck.topCard, currentColor);

    if (!canPlayDrawnCard) {
      _nextPlayer();
      return ActionResult.success("Card drawn, turn passed", card: card);
    }

    return ActionResult.success(
        "Card drawn, can be played immediately if desired",
        card: card);
  }

  /// Calls UNO for the player
  ActionResult callUno(Player player) {
    if (state != GameState.playing) {
      return const ActionResult.failure("Game not in progress");
    }

    if (player.hasUno) {
      player.calledUno = true;

      _addToHistory(action: 'call_uno', data: {
        'player_id': player.id,
      });

      return const ActionResult.success("UNO called successfully");
    }

    return const ActionResult.failure(
        "Player doesn't have UNO (exactly one card)");
  }

  /// Catches a player who failed to call UNO
  ActionResult catchUno(Player caller, Player target) {
    if (state != GameState.playing) {
      return const ActionResult.failure("Game not in progress");
    }

    // Check if target has UNO but didn't call it
    if (target.hasUno && !target.calledUno) {
      // Penalty: Draw cards
      final drawnCards = <Card>[];
      for (int i = 0; i < unoPenaltyCardCount; i++) {
        drawnCards.add(deck.drawCard());
      }
      target.addCards(drawnCards);

      _addToHistory(action: 'catch_uno', data: {
        'caller_id': caller.id,
        'target_id': target.id,
        'cards_drawn': drawnCards.length,
      });

      return ActionResult.success(
          "${target.name} didn't call UNO and must draw $unoPenaltyCardCount cards!");
    }

    return const ActionResult.failure(
        "Player doesn't have UNO or already called it");
  }

  /// Applies the effect of a played card
  void _applyCardEffect(Card card) {
    switch (card.type) {
      case CardType.skip:
        _nextPlayer(); // Skip next player
        _addToHistory(action: 'effect_skip', data: {
          'skipped_player': players[currentPlayerIndex].id,
        });
        break;

      case CardType.reverse:
        _reverseDirection();
        // If only 2 players, reverse acts like skip
        if (players.length == 2) {
          _nextPlayer();
        }
        _addToHistory(action: 'effect_reverse', data: {
          'new_direction': direction.toString(),
        });
        break;

      case CardType.drawTwo:
        _nextPlayer();
        final targetPlayer = players[currentPlayerIndex];
        final drawnCards = <Card>[deck.drawCard(), deck.drawCard()];
        targetPlayer.addCards(drawnCards);
        _addToHistory(action: 'effect_draw_two', data: {
          'target_player': targetPlayer.id,
        });
        _nextPlayer();
        break;

      case CardType.wildDrawFour:
        _nextPlayer();
        final targetPlayer = players[currentPlayerIndex];
        final drawnCards = <Card>[];
        for (int i = 0; i < 4; i++) {
          drawnCards.add(deck.drawCard());
        }
        targetPlayer.addCards(drawnCards);
        _addToHistory(action: 'effect_wild_draw_four', data: {
          'target_player': targetPlayer.id,
          'new_color': currentColor.toString(),
        });
        _nextPlayer();
        break;

      case CardType.wild:
        _addToHistory(action: 'effect_wild', data: {
          'new_color': currentColor.toString(),
        });
        break;

      default:
        // No special effect for number cards
        break;
    }
  }

  /// Moves to the next player based on current direction
  void _nextPlayer() {
    if (direction == Direction.clockwise) {
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    } else {
      currentPlayerIndex =
          (currentPlayerIndex - 1 + players.length) % players.length;
    }

    // Skip inactive players
    while (!players[currentPlayerIndex].isActive && _countActivePlayers() > 1) {
      if (direction == Direction.clockwise) {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      } else {
        currentPlayerIndex =
            (currentPlayerIndex - 1 + players.length) % players.length;
      }
    }
  }

  /// Reverses the direction of play
  void _reverseDirection() {
    direction = direction == Direction.clockwise
        ? Direction.counterClockwise
        : Direction.clockwise;
  }

  /// Ends the game with a winner
  void _endGame(Player winner) {
    state = GameState.finished;
    this.winner = winner;
    endTime = DateTime.now();

    _addToHistory(action: 'game_end', data: {
      'winner_id': winner.id,
      'winner_name': winner.name,
      'scores': _calculateScores(),
    });
  }

  /// Calculates final scores
  Map<String, int> _calculateScores() {
    final Map<String, int> scores = {};

    // Winner gets points from all other players' hands
    int winnerScore = 0;
    for (final player in players) {
      if (player.id != winner?.id) {
        winnerScore += player.pointsInHand;
      }
      scores[player.id] = 0;
    }

    if (winner != null) {
      scores[winner!.id] = winnerScore;
    }

    return scores;
  }

  /// Counts the number of active players
  int _countActivePlayers() {
    return players.where((p) => p.isActive).length;
  }

  /// Adds an action to the history log
  void _addToHistory(
      {required String action, required Map<String, dynamic> data}) {
    _actionHistory.add({
      'action': action,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    });
  }

  /// Gets the game history
  List<Map<String, dynamic>> get actionHistory =>
      List.unmodifiable(_actionHistory);

  /// Gets the current player
  Player get currentPlayer => players[currentPlayerIndex];

  /// Gets the top card on the discard pile
  Card get topCard => deck.topCard;

  /// Gets the next player who will play (for UI hints)
  Player get nextPlayer {
    int nextIndex;
    if (direction == Direction.clockwise) {
      nextIndex = (currentPlayerIndex + 1) % players.length;
    } else {
      nextIndex = (currentPlayerIndex - 1 + players.length) % players.length;
    }
    return players[nextIndex];
  }

  /// Gets the game duration
  Duration get duration {
    if (startTime == null) return Duration.zero;
    return (endTime ?? DateTime.now()).difference(startTime!);
  }
}
