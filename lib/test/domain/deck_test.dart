import 'package:flutter_test/flutter_test.dart';

import '../../domain/card.dart';
import '../../domain/deck.dart';

void main() {
  group('Deck Creation and Initialization', () {
    test('Standard deck has 108 cards', () {
      final deck = Deck();

      // Count cards by drawing them all
      int count = 0;
      while (deck.cardsRemaining > 0) {
        deck.drawCard();
        count++;
      }

      expect(count, 108);
    });

    test('Empty deck can be created for testing', () {
      final deck = Deck.empty();

      expect(deck.cardsRemaining, 0);
      expect(deck.discardCount, 0);
      expect(deck.totalCards, 0);
      expect(() => deck.topCard, throwsException);
    });

    test('Deck has correct card distribution', () {
      final deck = Deck();

      // Track card counts
      Map<CardColor, Map<CardType, Map<int?, int>>> cardCounts = {
        CardColor.red: {},
        CardColor.blue: {},
        CardColor.green: {},
        CardColor.yellow: {},
        CardColor.wild: {},
      };

      // Initialize counts
      for (var color in CardColor.values) {
        cardCounts[color]![CardType.number] = {};
        for (int i = 0; i <= 9; i++) {
          cardCounts[color]![CardType.number]![i] = 0;
        }

        for (var type in [
          CardType.skip,
          CardType.reverse,
          CardType.drawTwo,
          CardType.wild,
          CardType.wildDrawFour
        ]) {
          cardCounts[color]![type] = {null: 0};
        }
      }

      // Count cards as we draw them
      while (deck.cardsRemaining > 0) {
        final card = deck.drawCard();
        if (card.type == CardType.number) {
          cardCounts[card.color]![card.type]![card.value] =
              (cardCounts[card.color]![card.type]![card.value] ?? 0) + 1;
        } else {
          cardCounts[card.color]![card.type]![null] =
              (cardCounts[card.color]![card.type]![null] ?? 0) + 1;
        }
      }

      // Verify correct distribution
      for (var color in [
        CardColor.red,
        CardColor.blue,
        CardColor.green,
        CardColor.yellow
      ]) {
        // One zero per color
        expect(cardCounts[color]![CardType.number]![0], 1);

        // Two of each number 1-9 per color
        for (int i = 1; i <= 9; i++) {
          expect(cardCounts[color]![CardType.number]![i], 2);
        }

        // Two of each special card (Skip, Reverse, Draw Two) per color
        for (var type in [CardType.skip, CardType.reverse, CardType.drawTwo]) {
          expect(cardCounts[color]![type]![null], 2);
        }
      }

      // Four of each wild card
      expect(cardCounts[CardColor.wild]![CardType.wild]![null], 4);
      expect(cardCounts[CardColor.wild]![CardType.wildDrawFour]![null], 4);
    });
  });

  group('Deck Operations', () {
    test('Draw card decreases deck size', () {
      final deck = Deck();
      final initialSize = deck.cardsRemaining;

      deck.drawCard();

      expect(deck.cardsRemaining, initialSize - 1);
    });

    test('Discard card increases discard pile', () {
      final deck = Deck();
      final card = deck.drawCard();

      expect(deck.discardCount, 0);

      deck.discard(card);

      expect(deck.discardCount, 1);
    });

    test('Top card returns last discarded card', () {
      final deck = Deck();
      final card1 = deck.drawCard();
      final card2 = deck.drawCard();

      deck.discard(card1);
      expect(deck.topCard, card1);

      deck.discard(card2);
      expect(deck.topCard, card2);
    });

    test('Draw when deck is empty refills from discard pile', () {
      final deck = Deck();

      // Draw all cards and discard them except one
      List<Card> cards = [];
      while (deck.cardsRemaining > 1) {
        cards.add(deck.drawCard());
      }

      // Keep the last card separate
      final lastCard = deck.drawCard();

      // Discard all but the last card
      for (var card in cards) {
        deck.discard(card);
      }

      // Verify state before refill
      expect(deck.cardsRemaining, 0);
      expect(deck.discardCount, cards.length);

      // Drawing should trigger refill
      final drawnCard = deck.drawCard();

      // Verify refill happened
      expect(drawnCard, isNot(equals(lastCard)));
      expect(deck.cardsRemaining, cards.length - 1);
      expect(deck.discardCount, 1); // Only top card remains
    });

    test('Draw from empty deck with empty discard throws exception', () {
      final deck = Deck.empty();

      expect(() => deck.drawCard(), throwsException);
    });

    test('Getting top card from empty discard throws exception', () {
      final deck = Deck();

      expect(() => deck.topCard, throwsException);
    });

    test('Setup game returns valid start card', () {
      final deck = Deck();
      final startCard = deck.setupGame();

      // Verify it's not a Wild Draw Four
      expect(startCard.type, isNot(CardType.wildDrawFour));

      // Verify it's in the discard pile
      expect(deck.topCard, startCard);
      expect(deck.discardCount, 1);
    });

    test('Setup game never returns Wild Draw Four', () {
      for (int i = 0; i < 20; i++) {
        final deck = Deck();
        final startCard = deck.setupGame();

        expect(startCard.type, isNot(CardType.wildDrawFour));
      }
    });
  });

  group('Deck Shuffle', () {
    test('Shuffle reorders cards', () {
      // This is a probabilistic test, so we'll repeat it
      // to make sure we don't get unlucky
      bool atLeastOneShuffleWorked = false;

      for (int trial = 0; trial < 5; trial++) {
        final deck1 = Deck();
        final deck2 = Deck();

        // Shuffle one deck
        deck2.shuffle();

        // Draw some cards and compare
        List<Card> cards1 = [];
        List<Card> cards2 = [];

        for (int i = 0; i < 10; i++) {
          cards1.add(deck1.drawCard());
          cards2.add(deck2.drawCard());
        }

        // Check if the orders differ
        bool ordersDiffer = false;
        for (int i = 0; i < cards1.length; i++) {
          if (cards1[i] != cards2[i]) {
            ordersDiffer = true;
            break;
          }
        }

        if (ordersDiffer) {
          atLeastOneShuffleWorked = true;
          break;
        }
      }

      expect(atLeastOneShuffleWorked, true);
    });
  });
}
