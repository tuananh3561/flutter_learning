import 'dart:math';
import 'card.dart';

/// Represents the UNO deck of cards, including both the draw pile and discard pile
class Deck {
  final List<Card> _cards = [];
  final List<Card> _discardPile = [];
  final Random _random = Random();

  /// Creates a new UNO deck with all 108 cards
  Deck() {
    _initializeDeck();
    shuffle();
  }

  /// Creates an empty deck for testing purposes
  Deck.empty();

  /// Initializes the standard UNO deck with all 108 cards
  void _initializeDeck() {
    _cards.clear();
    _discardPile.clear();

    // Add all colored cards (colors: red, blue, green, yellow)
    for (var color in [
      CardColor.red,
      CardColor.blue,
      CardColor.green,
      CardColor.yellow
    ]) {
      // One 0 card per color
      _cards.add(Card(color: color, type: CardType.number, value: 0));

      // Two of each number 1-9 per color
      for (int value = 1; value <= 9; value++) {
        _cards.add(Card(color: color, type: CardType.number, value: value));
        _cards.add(Card(color: color, type: CardType.number, value: value));
      }

      // Two of each special card (Skip, Reverse, Draw Two) per color
      for (var type in [CardType.skip, CardType.reverse, CardType.drawTwo]) {
        _cards.add(Card(color: color, type: type));
        _cards.add(Card(color: color, type: type));
      }
    }

    // Add wild cards (4 of each)
    for (int i = 0; i < 4; i++) {
      _cards.add(const Card(color: CardColor.wild, type: CardType.wild));
      _cards
          .add(const Card(color: CardColor.wild, type: CardType.wildDrawFour));
    }
  }

  /// Shuffles the deck of cards
  void shuffle() {
    _cards.shuffle(_random);
  }

  /// Draws a card from the top of the deck
  /// Returns the drawn card
  /// Automatically refills from discard pile if necessary
  Card drawCard() {
    if (_cards.isEmpty) {
      refillFromDiscardPile();
    }

    if (_cards.isEmpty) {
      throw Exception("No cards left in the game!");
    }

    return _cards.removeAt(0);
  }

  /// Places a card on top of the discard pile
  void discard(Card card) {
    _discardPile.add(card);
  }

  /// Gets the top card of the discard pile without removing it
  Card get topCard {
    if (_discardPile.isEmpty) {
      throw Exception("No cards in discard pile!");
    }
    return _discardPile.last;
  }

  /// Transfers cards from discard pile back to the draw pile,
  /// keeping only the top card in the discard pile
  void refillFromDiscardPile() {
    if (_discardPile.length <= 1) {
      return; // Nothing to refill
    }

    // Keep the top card in the discard pile
    final topCard = _discardPile.removeLast();

    // Move the rest to the draw pile and shuffle
    _cards.addAll(_discardPile);
    _discardPile.clear();
    _discardPile.add(topCard);
    shuffle();
  }

  /// Returns number of cards remaining in the draw pile
  int get cardsRemaining => _cards.length;

  /// Returns number of cards in the discard pile
  int get discardCount => _discardPile.length;

  /// Returns total number of cards in both piles
  int get totalCards => _cards.length + _discardPile.length;

  /// Creates a new deck with an initial card turned over
  /// Returns the starting card
  Card setupGame() {
    Card initialCard;
    do {
      initialCard = drawCard();
      // Cannot start with a Wild Draw Four
      if (initialCard.type != CardType.wildDrawFour) {
        discard(initialCard);
        return initialCard;
      }
      // Put the Wild Draw Four back and try again
      _cards.add(initialCard);
      shuffle();
    } while (true);
  }
}
