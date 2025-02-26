import 'package:flutter_test/flutter_test.dart';

import '../../domain/card.dart';

void main() {
  group('Card Creation and Basic Properties', () {
    test('Number card creation is valid', () {
      const card = Card(color: CardColor.red, type: CardType.number, value: 5);

      expect(card.color, CardColor.red);
      expect(card.type, CardType.number);
      expect(card.value, 5);
    });

    test('Action card creation is valid', () {
      const card = Card(color: CardColor.blue, type: CardType.skip);

      expect(card.color, CardColor.blue);
      expect(card.type, CardType.skip);
      expect(card.value, null);
    });

    test('Wild card creation is valid', () {
      const card = Card(color: CardColor.wild, type: CardType.wild);

      expect(card.color, CardColor.wild);
      expect(card.type, CardType.wild);
      expect(card.value, null);
    });

    test('Wild Draw Four card creation is valid', () {
      const card = Card(color: CardColor.wild, type: CardType.wildDrawFour);

      expect(card.color, CardColor.wild);
      expect(card.type, CardType.wildDrawFour);
      expect(card.value, null);
    });

    test('Invalid number card creation throws assertion error', () {
      expect(() => Card(color: CardColor.red, type: CardType.number, value: 15),
          throwsA(isA<AssertionError>()));

      expect(() => Card(color: CardColor.red, type: CardType.number, value: -5),
          throwsA(isA<AssertionError>()));

      expect(
          () => Card(color: CardColor.red, type: CardType.number, value: null),
          throwsA(isA<AssertionError>()));
    });

    test('Action card with value throws assertion error', () {
      expect(() => Card(color: CardColor.blue, type: CardType.skip, value: 5),
          throwsA(isA<AssertionError>()));
    });
  });

  group('Card Points Calculation', () {
    test('Number cards are worth their face value', () {
      const card0 = Card(color: CardColor.red, type: CardType.number, value: 0);
      const card5 =
          Card(color: CardColor.blue, type: CardType.number, value: 5);
      const card9 =
          Card(color: CardColor.green, type: CardType.number, value: 9);

      expect(card0.points, 0);
      expect(card5.points, 5);
      expect(card9.points, 9);
    });

    test('Action cards are worth 20 points', () {
      const skipCard = Card(color: CardColor.red, type: CardType.skip);
      const reverseCard = Card(color: CardColor.yellow, type: CardType.reverse);
      const drawTwoCard = Card(color: CardColor.blue, type: CardType.drawTwo);

      expect(skipCard.points, 20);
      expect(reverseCard.points, 20);
      expect(drawTwoCard.points, 20);
    });

    test('Wild cards are worth 50 points', () {
      const wildCard = Card(color: CardColor.wild, type: CardType.wild);
      const wildDrawFourCard =
          Card(color: CardColor.wild, type: CardType.wildDrawFour);

      expect(wildCard.points, 50);
      expect(wildDrawFourCard.points, 50);
    });
  });

  group('Card Comparison', () {
    test('Identical cards are equal', () {
      const card1 = Card(color: CardColor.red, type: CardType.number, value: 5);
      const card2 = Card(color: CardColor.red, type: CardType.number, value: 5);

      expect(card1 == card2, true);
      expect(card1.hashCode == card2.hashCode, true);
    });

    test('Different cards are not equal', () {
      const card1 = Card(color: CardColor.red, type: CardType.number, value: 5);
      const card2 =
          Card(color: CardColor.blue, type: CardType.number, value: 5);
      const card3 = Card(color: CardColor.red, type: CardType.number, value: 6);
      const card4 = Card(color: CardColor.red, type: CardType.skip);

      expect(card1 == card2, false);
      expect(card1 == card3, false);
      expect(card1 == card4, false);
    });
  });

  group('Card Playability Rules', () {
    test('Number card can be played on matching color', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const redSeven =
          Card(color: CardColor.red, type: CardType.number, value: 7);

      expect(redSeven.canBePlayedOn(redFive, CardColor.red), true);
    });

    test('Number card can be played on matching number', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const blueFive =
          Card(color: CardColor.blue, type: CardType.number, value: 5);

      expect(blueFive.canBePlayedOn(redFive, CardColor.red), true);
    });

    test('Action card can be played on matching color', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const redSkip = Card(color: CardColor.red, type: CardType.skip);

      expect(redSkip.canBePlayedOn(redFive, CardColor.red), true);
    });

    test('Action card can be played on matching action', () {
      const redSkip = Card(color: CardColor.red, type: CardType.skip);
      const blueSkip = Card(color: CardColor.blue, type: CardType.skip);

      expect(blueSkip.canBePlayedOn(redSkip, CardColor.red), true);
    });

    test('Card cannot be played on different color and type/value', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const blueSeven =
          Card(color: CardColor.blue, type: CardType.number, value: 7);

      expect(blueSeven.canBePlayedOn(redFive, CardColor.red), false);
    });

    test('Wild card can be played on any card', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);
      const wild = Card(color: CardColor.wild, type: CardType.wild);
      const wildDrawFour =
          Card(color: CardColor.wild, type: CardType.wildDrawFour);

      expect(wild.canBePlayedOn(redFive, CardColor.red), true);
      expect(wildDrawFour.canBePlayedOn(redFive, CardColor.red), true);
    });

    test('Card can be played on matching chosen color (after wild)', () {
      const wild = Card(color: CardColor.wild, type: CardType.wild);
      const blueThree =
          Card(color: CardColor.blue, type: CardType.number, value: 3);

      // After wild is played and blue is chosen
      expect(blueThree.canBePlayedOn(wild, CardColor.blue), true);
    });
  });

  group('Card String Representation', () {
    test('Number card toString() is correct', () {
      const redFive =
          Card(color: CardColor.red, type: CardType.number, value: 5);

      expect(redFive.toString(), 'red 5');
    });

    test('Action card toString() is correct', () {
      const blueSkip = Card(color: CardColor.blue, type: CardType.skip);
      const greenReverse = Card(color: CardColor.green, type: CardType.reverse);
      const yellowDrawTwo =
          Card(color: CardColor.yellow, type: CardType.drawTwo);

      expect(blueSkip.toString(), 'blue Skip');
      expect(greenReverse.toString(), 'green Reverse');
      expect(yellowDrawTwo.toString(), 'yellow Draw Two');
    });

    test('Wild card toString() is correct', () {
      const wild = Card(color: CardColor.wild, type: CardType.wild);
      const wildDrawFour =
          Card(color: CardColor.wild, type: CardType.wildDrawFour);

      expect(wild.toString(), 'Wild');
      expect(wildDrawFour.toString(), 'Wild Draw Four');
    });
  });

  group('Card CopyWith', () {
    test('copyWith creates new card with changed properties', () {
      const original =
          Card(color: CardColor.red, type: CardType.number, value: 5);

      final colorChanged = original.copyWith(color: CardColor.blue);
      expect(colorChanged.color, CardColor.blue);
      expect(colorChanged.type, original.type);
      expect(colorChanged.value, original.value);

      final typeChanged = original.copyWith(type: CardType.skip);
      expect(typeChanged.color, original.color);
      expect(typeChanged.type, CardType.skip);
      expect(typeChanged.value, original.value);

      final valueChanged = original.copyWith(value: 9);
      expect(valueChanged.color, original.color);
      expect(valueChanged.type, original.type);
      expect(valueChanged.value, 9);
    });
  });
}
