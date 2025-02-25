import 'package:flutter_test/flutter_test.dart';

import '../../domain/card.dart';
import '../../domain/player.dart';

void main() {
  group('Player Creation', () {
    test('Player creation with default values', () {
      final player = Player(name: 'Test Player');

      expect(player.name, 'Test Player');
      expect(player.type, PlayerType.human);
      expect(player.id, isNotEmpty);
      expect(player.hand, isEmpty);
      expect(player.calledUno, false);
      expect(player.isActive, true);
    });

    test('Player creation with custom id and type', () {
      final player = Player(
        id: 'custom-id',
        name: 'AI Player',
        type: PlayerType.aiMedium,
      );

      expect(player.id, 'custom-id');
      expect(player.name, 'AI Player');
      expect(player.type, PlayerType.aiMedium);
    });

    test('Different players have different IDs', () {
      final player1 = Player(name: 'Player 1');
      final player2 = Player(name: 'Player 2');

      expect(player1.id != player2.id, true);
    });
  });

  group('Player Hand Management', () {
    late Player player;

    setUp(() {
      player = Player(name: 'Test Player');
    });

    test('Add card to hand', () {
      const card = Card(color: CardColor.red, type: CardType.number, value: 5);

      player.addCard(card);

      expect(player.hand.length, 1);
      expect(player.hand.first, card);
      expect(player.cardCount, 1);
    });

    test('Add multiple cards to hand', () {
      final cards = [
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.skip),
        const Card(color: CardColor.wild, type: CardType.wild),
      ];

      player.addCards(cards);

      expect(player.hand.length, 3);
      expect(player.hand, cards);
      expect(player.cardCount, 3);
    });

    test('Remove card from hand', () {
      const card1 = Card(color: CardColor.red, type: CardType.number, value: 5);
      const card2 = Card(color: CardColor.blue, type: CardType.skip);

      player.addCard(card1);
      player.addCard(card2);

      expect(player.hand.length, 2);

      final removed = player.removeCard(card1);

      expect(removed, true);
      expect(player.hand.length, 1);
      expect(player.hand.first, card2);
    });

    test('Remove card not in hand returns false', () {
      const card1 = Card(color: CardColor.red, type: CardType.number, value: 5);
      const card2 = Card(color: CardColor.blue, type: CardType.skip);

      player.addCard(card1);

      final removed = player.removeCard(card2);

      expect(removed, false);
      expect(player.hand.length, 1);
    });

    test('Check for playable cards', () {
      const topCard =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const currentColor = CardColor.red;

      // Cards in hand
      const redSeven =
          Card(color: CardColor.red, type: CardType.number, value: 7);
      const blueFive =
          Card(color: CardColor.blue, type: CardType.number, value: 5);
      const yellowSix =
          Card(color: CardColor.yellow, type: CardType.number, value: 6);
      const wild = Card(color: CardColor.wild, type: CardType.wild);

      player.addCard(redSeven);
      player.addCard(blueFive);
      player.addCard(yellowSix);
      player.addCard(wild);

      final playableCards = player.getPlayableCards(topCard, currentColor);

      // Should include cards that match color or value, plus wilds
      expect(playableCards.length, 3);
      expect(playableCards.contains(redSeven), true);
      expect(playableCards.contains(blueFive), true);
      expect(playableCards.contains(wild), true);
      expect(playableCards.contains(yellowSix), false);

      expect(player.hasPlayableCard(topCard, currentColor), true);
    });

    test('No playable cards', () {
      const topCard =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const currentColor = CardColor.red;

      // Cards that don't match
      const yellowSix =
          Card(color: CardColor.yellow, type: CardType.number, value: 6);
      const blueSeven =
          Card(color: CardColor.blue, type: CardType.number, value: 7);

      player.addCard(yellowSix);
      player.addCard(blueSeven);

      final playableCards = player.getPlayableCards(topCard, currentColor);

      expect(playableCards.isEmpty, true);
      expect(player.hasPlayableCard(topCard, currentColor), false);
    });
  });

  group('Player State', () {
    late Player player;

    setUp(() {
      player = Player(name: 'Test Player');
    });

    test('Has UNO with one card', () {
      expect(player.hasUno, false);

      player.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      expect(player.hasUno, true);

      player.addCard(const Card(color: CardColor.blue, type: CardType.skip));
      expect(player.hasUno, false);
    });

    test('Has won with no cards', () {
      expect(player.hasWon, true);

      player.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      expect(player.hasWon, false);
    });

    test('Called UNO state', () {
      player.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));

      expect(player.calledUno, false);

      player.calledUno = true;
      expect(player.calledUno, true);

      // Adding card resets UNO status
      player.addCard(const Card(color: CardColor.blue, type: CardType.skip));
      expect(player.calledUno, false);
    });

    test('Player active state', () {
      expect(player.isActive, true);

      player.isActive = false;
      expect(player.isActive, false);

      player.isActive = true;
      expect(player.isActive, true);
    });
  });

  group('Player Color Counting', () {
    late Player player;

    setUp(() {
      player = Player(name: 'Test Player');
    });

    test('Empty hand has zero of each color', () {
      final colorCount = player.getColorCount();

      expect(colorCount[CardColor.red], 0);
      expect(colorCount[CardColor.blue], 0);
      expect(colorCount[CardColor.green], 0);
      expect(colorCount[CardColor.yellow], 0);
      expect(colorCount[CardColor.wild], 0);
    });

    test('Color counting is accurate', () {
      player.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.red, type: CardType.number, value: 7),
        const Card(color: CardColor.blue, type: CardType.skip),
        const Card(color: CardColor.green, type: CardType.number, value: 3),
        const Card(color: CardColor.wild, type: CardType.wild),
        const Card(color: CardColor.wild, type: CardType.wildDrawFour),
      ]);

      final colorCount = player.getColorCount();

      expect(colorCount[CardColor.red], 2);
      expect(colorCount[CardColor.blue], 1);
      expect(colorCount[CardColor.green], 1);
      expect(colorCount[CardColor.yellow], 0);
      expect(colorCount[CardColor.wild], 2);
    });
  });

  group('Player Points Calculation', () {
    late Player player;

    setUp(() {
      player = Player(name: 'Test Player');
    });

    test('Empty hand has zero points', () {
      expect(player.pointsInHand, 0);
    });

    test('Points calculation is correct', () {
      player.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.skip),
        const Card(color: CardColor.wild, type: CardType.wild),
      ]);

      // 5 (number) + 20 (skip) + 50 (wild) = 75
      expect(player.pointsInHand, 75);
    });
  });

  group('Player String Representation', () {
    test('ToString includes name and card count', () {
      final player = Player(name: 'Test Player');

      expect(player.toString(), 'Test Player (0 cards)');

      player.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      player.addCard(const Card(color: CardColor.blue, type: CardType.skip));

      expect(player.toString(), 'Test Player (2 cards)');
    });
  });
}
