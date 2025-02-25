import 'package:uuid/uuid.dart';
import 'card.dart';

/// Defines the player types (human or AI)
enum PlayerType { human, aiEasy, aiMedium, aiHard }

/// Represents a player in the UNO game
class Player {
  final String id;
  final String name;
  final PlayerType type;
  final List<Card> hand = [];

  bool calledUno = false;
  bool _isActive = true;

  /// Creates a new player with the given name and type
  Player({String? id, required this.name, this.type = PlayerType.human})
      : id = id ?? const Uuid().v4();

  /// Adds a card to the player's hand
  void addCard(Card card) {
    hand.add(card);
    calledUno = false; // Reset UNO status when adding cards
  }

  /// Adds multiple cards to the player's hand
  void addCards(List<Card> cards) {
    hand.addAll(cards);
    calledUno = false;
  }

  /// Removes a card from the player's hand
  /// Returns true if the card was successfully removed, false otherwise
  bool removeCard(Card card) {
    final index = hand.indexWhere((c) =>
        c.color == card.color && c.type == card.type && c.value == card.value);

    if (index != -1) {
      hand.removeAt(index);
      return true;
    }
    return false;
  }

  /// Gets all cards in the player's hand that can be played
  /// on the current top card
  List<Card> getPlayableCards(Card topCard, CardColor currentColor) {
    return hand
        .where((card) => card.canBePlayedOn(topCard, currentColor))
        .toList();
  }

  /// Checks if the player has any playable cards
  bool hasPlayableCard(Card topCard, CardColor currentColor) {
    return getPlayableCards(topCard, currentColor).isNotEmpty;
  }

  /// Gets card count by color for strategic decision making (AI)
  Map<CardColor, int> getColorCount() {
    final Map<CardColor, int> colorCount = {
      CardColor.red: 0,
      CardColor.blue: 0,
      CardColor.green: 0,
      CardColor.yellow: 0,
      CardColor.wild: 0,
    };

    for (final card in hand) {
      colorCount[card.color] = (colorCount[card.color] ?? 0) + 1;
    }

    return colorCount;
  }

  /// Calculates the total point value of cards in hand
  int get pointsInHand {
    return hand.fold(0, (sum, card) => sum + card.points);
  }

  /// Checks if the player has UNO (one card)
  bool get hasUno => hand.length == 1;

  /// Checks if the player has won (no cards)
  bool get hasWon => hand.isEmpty;

  /// Gets the number of cards in the player's hand
  int get cardCount => hand.length;

  /// Sets whether the player is active (still in the game)
  set isActive(bool value) {
    _isActive = value;
  }

  /// Checks if the player is active
  bool get isActive => _isActive;

  /// Creates a string representation of the player
  @override
  String toString() {
    return '$name (${hand.length} cards)';
  }
}
