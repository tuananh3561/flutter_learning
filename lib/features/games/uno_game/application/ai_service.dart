import 'dart:async';
import 'dart:math';
import '../domain/card.dart';
import '../domain/game.dart';
import '../domain/player.dart';
import '../domain/enums/game_state.dart';

/// Service responsible for AI player decision making
class AIService {
  /// Random number generator for AI decisions
  final Random _random = Random();

  /// Delay between AI actions to simulate thinking (milliseconds)
  final int _minThinkingDelay;
  final int _maxThinkingDelay;

  /// Creates a new AIService with configurable thinking delays
  AIService({
    int minThinkingDelay = 500,
    int maxThinkingDelay = 2000,
  })  : _minThinkingDelay = minThinkingDelay,
        _maxThinkingDelay = maxThinkingDelay;

  /// Makes a move for the AI player in the current game
  /// Returns the action that was taken
  Future<AIAction> makeMove(Game game, Player aiPlayer) async {
    // Simulate thinking time for more natural gameplay
    await _simulateThinking();

    // Ensure it's this AI's turn
    if (game.currentPlayer.id != aiPlayer.id) {
      return AIAction(type: AIActionType.none, message: "Not AI's turn");
    }

    // Get playable cards
    final playableCards =
        aiPlayer.getPlayableCards(game.topCard, game.currentColor);

    // If there are playable cards, choose one based on AI difficulty
    if (playableCards.isNotEmpty) {
      final card = _selectCardToPlay(aiPlayer, playableCards, game.currentColor,
          _difficultyFromPlayerType(aiPlayer.type));

      // For wild cards, choose a color
      CardColor? chosenColor;
      if (card.type == CardType.wild || card.type == CardType.wildDrawFour) {
        chosenColor = _selectBestColor(aiPlayer);

        final result = game.playCard(aiPlayer, card, chosenColor: chosenColor);

        if (result.success) {
          return AIAction(
              type: AIActionType.playCard,
              card: card,
              chosenColor: chosenColor,
              message:
                  "${aiPlayer.name} played ${card.toString()}${chosenColor != null ? " and chose ${chosenColor.name}" : ""}");
        } else {
          return AIAction(
              type: AIActionType.error,
              message: "Error playing card: ${result.message}");
        }
      } else {
        final result = game.playCard(aiPlayer, card);

        if (result.success) {
          return AIAction(
              type: AIActionType.playCard,
              card: card,
              message: "${aiPlayer.name} played ${card.toString()}");
        } else {
          return AIAction(
              type: AIActionType.error,
              message: "Error playing card: ${result.message}");
        }
      }
    } else {
      // No playable cards, draw one
      final result = game.drawCard(aiPlayer);

      if (result.success) {
        return AIAction(
            type: AIActionType.drawCard,
            card: result.card,
            message: "${aiPlayer.name} drew a card");
      } else {
        return AIAction(
            type: AIActionType.error,
            message: "Error drawing card: ${result.message}");
      }
    }
  }

  /// Calls UNO for the AI player if they have one card left
  Future<AIAction> checkAndCallUno(Game game, Player aiPlayer) async {
    // Based on difficulty, AI might forget to call UNO
    final difficulty = _difficultyFromPlayerType(aiPlayer.type);

    // Easy AI often forgets, Medium sometimes forgets, Hard rarely forgets
    double callChance;
    switch (difficulty) {
      case AIDifficulty.easy:
        callChance = 0.4; // 40% chance to call UNO
        break;
      case AIDifficulty.medium:
        callChance = 0.7; // 70% chance to call UNO
        break;
      case AIDifficulty.hard:
        callChance = 0.95; // 95% chance to call UNO
        break;
    }

    if (aiPlayer.hasUno &&
        !aiPlayer.calledUno &&
        _random.nextDouble() < callChance) {
      await _simulateThinking(
          minDelay: 300, maxDelay: 800); // Faster thinking for UNO calls

      final result = game.callUno(aiPlayer);

      if (result.success) {
        return AIAction(
            type: AIActionType.callUno,
            message: "${aiPlayer.name} called UNO!");
      }
    }

    return AIAction(type: AIActionType.none);
  }

  /// Checks if the AI should catch another player who didn't call UNO
  Future<AIAction> checkAndCatchUno(Game game, Player aiPlayer) async {
    // Based on difficulty, AI might not notice when others forget to call UNO
    final difficulty = _difficultyFromPlayerType(aiPlayer.type);

    // Easy AI rarely notices, Medium sometimes notices, Hard often notices
    double noticeChance;
    switch (difficulty) {
      case AIDifficulty.easy:
        noticeChance = 0.2; // 20% chance to notice
        break;
      case AIDifficulty.medium:
        noticeChance = 0.5; // 50% chance to notice
        break;
      case AIDifficulty.hard:
        noticeChance = 0.85; // 85% chance to notice
        break;
    }

    // Find players who have UNO but didn't call it
    for (final player in game.players) {
      if (player.id != aiPlayer.id &&
          player.hasUno &&
          !player.calledUno &&
          _random.nextDouble() < noticeChance) {
        await _simulateThinking(
            minDelay: 300, maxDelay: 1000); // Quick reaction time

        final result = game.catchUno(aiPlayer, player);

        if (result.success) {
          return AIAction(
              type: AIActionType.catchUno,
              targetPlayer: player,
              message:
                  "${aiPlayer.name} caught ${player.name} not saying UNO!");
        }
      }
    }

    return AIAction(type: AIActionType.none);
  }

  /// Selects a card to play based on AI difficulty
  Card _selectCardToPlay(Player player, List<Card> playableCards,
      CardColor currentColor, AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.easy:
        // Easy AI plays randomly
        return playableCards[_random.nextInt(playableCards.length)];

      case AIDifficulty.medium:
        // Medium AI prefers action cards and tries to play same color

        // First priority: special cards (Skip, Reverse, Draw Two)
        final specialCards = playableCards
            .where((card) =>
                card.type == CardType.skip ||
                card.type == CardType.reverse ||
                card.type == CardType.drawTwo)
            .toList();

        if (specialCards.isNotEmpty) {
          return specialCards[_random.nextInt(specialCards.length)];
        }

        // Second priority: cards of the current color
        final sameColorCards = playableCards
            .where((card) =>
                card.color == currentColor && card.type == CardType.number)
            .toList();

        if (sameColorCards.isNotEmpty) {
          return sameColorCards[_random.nextInt(sameColorCards.length)];
        }

        // Third priority: wild cards
        final wildCards = playableCards
            .where((card) =>
                card.type == CardType.wild ||
                card.type == CardType.wildDrawFour)
            .toList();

        if (wildCards.isNotEmpty) {
          return wildCards[_random.nextInt(wildCards.length)];
        }

        // Last priority: other number cards
        return playableCards[_random.nextInt(playableCards.length)];

      case AIDifficulty.hard:
        // Hard AI uses advanced strategy

        // First, check if player is about to win (has 2 cards)
        // If so, prioritize Skip, Draw Two, or Draw Four
        if (player.cardCount == 2) {
          final blockingCards = playableCards
              .where((card) =>
                  card.type == CardType.skip ||
                  card.type == CardType.drawTwo ||
                  card.type == CardType.wildDrawFour)
              .toList();

          if (blockingCards.isNotEmpty) {
            return blockingCards[_random.nextInt(blockingCards.length)];
          }
        }

        // Count cards by color to determine which color to play
        final colorCount = player.getColorCount();

        // Remove wild from consideration
        colorCount.remove(CardColor.wild);

        // Find the most common color in hand
        final mostCommonColor =
            colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        // Try to play cards of the most common color
        final bestColorCards = playableCards
            .where((card) =>
                card.color == mostCommonColor &&
                card.type != CardType.wild &&
                card.type != CardType.wildDrawFour)
            .toList();

        if (bestColorCards.isNotEmpty) {
          // Among cards of best color, prefer action cards
          final actionCards = bestColorCards
              .where((card) => card.type != CardType.number)
              .toList();

          if (actionCards.isNotEmpty) {
            return actionCards[_random.nextInt(actionCards.length)];
          }

          return bestColorCards[_random.nextInt(bestColorCards.length)];
        }

        // If no cards of most common color, play action cards
        final actionCards = playableCards
            .where((card) =>
                card.type == CardType.skip ||
                card.type == CardType.reverse ||
                card.type == CardType.drawTwo)
            .toList();

        if (actionCards.isNotEmpty) {
          return actionCards[_random.nextInt(actionCards.length)];
        }

        // Save wild cards for when really needed
        final nonWildCards = playableCards
            .where((card) =>
                card.type != CardType.wild &&
                card.type != CardType.wildDrawFour)
            .toList();

        if (nonWildCards.isNotEmpty) {
          return nonWildCards[_random.nextInt(nonWildCards.length)];
        }

        // If all else fails, play any card (including wild)
        return playableCards[_random.nextInt(playableCards.length)];
    }
  }

  /// Selects the best color when playing a wild card
  CardColor _selectBestColor(Player player) {
    final colorCount = player.getColorCount();

    // Remove wild from consideration
    colorCount.remove(CardColor.wild);

    // If player has no cards other than wilds, choose a random color
    if (colorCount.values.every((count) => count == 0)) {
      final colors = [
        CardColor.red,
        CardColor.blue,
        CardColor.green,
        CardColor.yellow
      ];
      return colors[_random.nextInt(colors.length)];
    }

    // Otherwise, choose the most common color in hand
    return colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Maps PlayerType to AIDifficulty
  AIDifficulty _difficultyFromPlayerType(PlayerType type) {
    switch (type) {
      case PlayerType.aiEasy:
        return AIDifficulty.easy;
      case PlayerType.aiMedium:
        return AIDifficulty.medium;
      case PlayerType.aiHard:
        return AIDifficulty.hard;
      default:
        return AIDifficulty.medium; // Default for non-AI players
    }
  }

  /// Simulates AI thinking time with a random delay
  Future<void> _simulateThinking({
    int? minDelay,
    int? maxDelay,
  }) async {
    final min = minDelay ?? _minThinkingDelay;
    final max = maxDelay ?? _maxThinkingDelay;

    final delay = min + _random.nextInt(max - min);
    await Future.delayed(Duration(milliseconds: delay));
  }
}

/// Types of AI actions
enum AIActionType {
  /// No action taken
  none,

  /// AI played a card
  playCard,

  /// AI drew a card
  drawCard,

  /// AI called UNO
  callUno,

  /// AI caught another player not calling UNO
  catchUno,

  /// An error occurred
  error,
}

/// Represents an action taken by an AI player
class AIAction {
  /// Type of action
  final AIActionType type;

  /// Card involved in the action
  final Card? card;

  /// Color chosen for wild cards
  final CardColor? chosenColor;

  /// Target player (for catch UNO)
  final Player? targetPlayer;

  /// Action description
  final String? message;

  /// Creates a new AI action
  AIAction({
    required this.type,
    this.card,
    this.chosenColor,
    this.targetPlayer,
    this.message,
  });

  @override
  String toString() => message ?? type.toString();
}
