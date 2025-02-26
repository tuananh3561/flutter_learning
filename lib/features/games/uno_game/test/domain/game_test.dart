import 'package:flutter_test/flutter_test.dart';

import '../../domain/card.dart';
import '../../domain/deck.dart';
import '../../domain/game.dart';
import '../../domain/player.dart';

void main() {
  group('Game Creation and Initialization', () {
    test('Game creation with default values', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(players: players);

      expect(game.id, isNotEmpty);
      expect(game.players, players);
      expect(game.state, GameState.notStarted);
      expect(game.currentPlayerIndex, 0);
      expect(game.direction, Direction.clockwise);
      expect(game.winner, null);
      expect(game.unoPenaltyCardCount, 2);
      expect(game.allowPlayingDrawnCard, true);
    });

    test('Game creation with custom values', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(
        id: 'custom-game',
        players: players,
        unoPenaltyCardCount: 4,
        allowPlayingDrawnCard: false,
      );

      expect(game.id, 'custom-game');
      expect(game.unoPenaltyCardCount, 4);
      expect(game.allowPlayingDrawnCard, false);
    });

    test('Game start deals cards and sets up discard pile', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(players: players);
      final result = game.start();

      expect(result.success, true);
      expect(game.state, GameState.playing);
      expect(game.startTime, isNotNull);
      expect(game.endTime, isNull);

      // Each player should have 7 cards
      expect(players[0].hand.length, 7);
      expect(players[1].hand.length, 7);

      // Discard pile should have 1 card
      expect(game.deck.discardCount, 1);

      // Top card should not be a Wild Draw Four
      expect(game.topCard.type, isNot(CardType.wildDrawFour));

      // Current color should be set to the top card's color
      expect(game.currentColor, game.topCard.color);
    });

    test('Game cannot start with fewer than 2 players', () {
      final players = [Player(id: 'p1', name: 'Player 1')];

      final game = Game(players: players);
      final result = game.start();

      expect(result.success, false);
      expect(game.state, GameState.notStarted);
    });

    test('Game cannot be started twice', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(players: players);
      final firstStart = game.start();
      final secondStart = game.start();

      expect(firstStart.success, true);
      expect(secondStart.success, false);
    });
  });

  group('Game Basic Gameplay', () {
    late Game game;
    late Player player1;
    late Player player2;
    late Deck mockDeck;

    setUp(() {
      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');

      // Create an empty deck so we can control the cards
      mockDeck = Deck.empty();

      game = Game(
        players: [player1, player2],
        deck: mockDeck,
      );

      // Add specific cards to player hands and discard pile for testing
      // Starting with player1's turn

      player1.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.number, value: 7),
      ]);

      player2.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 9),
        const Card(color: CardColor.green, type: CardType.skip),
      ]);

      // Set up the discard pile with a red card
      mockDeck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));

      // Set game state and color to match the top card
      game.state = GameState.playing;
      game.currentColor = CardColor.red;
      game.currentPlayerIndex = 0; // player1's turn
    });

    test('Play valid card', () {
      // player1 plays a red 5 on the red 3
      final card = player1.hand.first; // Red 5
      final result = game.playCard(player1, card);

      expect(result.success, true);
      expect(player1.hand.length, 1);
      expect(game.topCard, card);
      expect(game.currentColor, CardColor.red);
      expect(game.currentPlayerIndex, 1); // Now player2's turn
    });

    test('Play invalid card fails', () {
      // player1 tries to play a blue 7 on the red 3 (invalid)
      final card = player1.hand[1]; // Blue 7
      final result = game.playCard(player1, card);

      expect(result.success, false);
      expect(player1.hand.length, 2);
      expect(game.topCard.color, CardColor.red);
      expect(game.topCard.value, 3);
      expect(game.currentPlayerIndex, 0); // Still player1's turn
    });

    test('Play out of turn fails', () {
      // player2 tries to play when it's player1's turn
      final card = player2.hand.first; // Red 9
      final result = game.playCard(player2, card);

      expect(result.success, false);
      expect(player2.hand.length, 2);
      expect(game.currentPlayerIndex, 0); // Still player1's turn
    });

    test('Draw card when no playable cards', () {
      // Add a card to the deck for drawing
      mockDeck.discard(
          const Card(color: CardColor.yellow, type: CardType.number, value: 4));

      // Use refillFromDiscardPile to move it to the draw pile
      mockDeck.refillFromDiscardPile();

      final result = game.drawCard(player1);

      expect(result.success, true);
      expect(player1.hand.length, 3);
      expect(game.currentPlayerIndex, 1); // Now player2's turn
    });

    test('Win condition when player plays last card', () {
      // Remove one card from player1's hand so they'll win after playing
      player1.removeCard(player1.hand[1]);

      // player1 plays their last card
      final card = player1.hand.first; // Red 5
      final result = game.playCard(player1, card);

      expect(result.success, true);
      expect(player1.hand.isEmpty, true);
      expect(game.state, GameState.finished);
      expect(game.winner, player1);
      expect(game.endTime, isNotNull);
    });
  });

  group('Special Card Effects', () {
    late Game game;
    late Player player1;
    late Player player2;
    late Player player3;
    late Deck mockDeck;

    setUp(() {
      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');
      player3 = Player(id: 'p3', name: 'Player 3');

      mockDeck = Deck.empty();

      game = Game(
        players: [player1, player2, player3],
        deck: mockDeck,
      );

      // Add cards to the deck for drawing during tests
      for (int i = 0; i < 10; i++) {
        mockDeck.discard(
            Card(color: CardColor.yellow, type: CardType.number, value: i));
      }
      mockDeck.refillFromDiscardPile();

      // Set up a red card as the top card
      mockDeck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));

      game.state = GameState.playing;
      game.currentColor = CardColor.red;
      game.currentPlayerIndex = 0; // player1's turn
    });

    test('Skip card effect', () {
      player1.addCard(const Card(color: CardColor.red, type: CardType.skip));

      final result = game.playCard(player1, player1.hand.first);

      expect(result.success, true);
      expect(game.currentPlayerIndex, 2); // Skipped player2
    });

    test('Reverse card effect with more than 2 players', () {
      player1.addCard(const Card(color: CardColor.red, type: CardType.reverse));

      final result = game.playCard(player1, player1.hand.first);

      expect(result.success, true);
      expect(game.direction, Direction.counterClockwise);
      expect(game.currentPlayerIndex, 2); // Was 0, now reversed to 2
    });

    test('Reverse card effect with 2 players acts like skip', () {
      // Remove player3 to test 2-player case
      game.players.removeAt(2);

      player1.addCard(const Card(color: CardColor.red, type: CardType.reverse));

      final result = game.playCard(player1, player1.hand.first);

      expect(result.success, true);
      expect(game.direction, Direction.counterClockwise);
      expect(game.currentPlayerIndex, 0); // Back to player1 (skipped player2)
    });

    test('Draw Two card effect', () {
      player1.addCard(const Card(color: CardColor.red, type: CardType.drawTwo));

      final result = game.playCard(player1, player1.hand.first);

      expect(result.success, true);
      expect(player2.hand.length, 2); // Drew 2 cards
      expect(game.currentPlayerIndex, 2); // Skipped player2
    });

    test('Wild card effect', () {
      player1.addCard(const Card(color: CardColor.wild, type: CardType.wild));

      final result = game.playCard(player1, player1.hand.first,
          chosenColor: CardColor.blue);

      expect(result.success, true);
      expect(game.currentColor, CardColor.blue); // Color changed
      expect(game.currentPlayerIndex, 1); // Next player's turn
    });

    test('Wild card without chosen color fails', () {
      player1.addCard(const Card(color: CardColor.wild, type: CardType.wild));

      final result =
          game.playCard(player1, player1.hand.first); // No color chosen

      expect(result.success, false);
      expect(game.currentColor, CardColor.red); // Color unchanged
      expect(player1.hand.length, 1); // Card not played
    });

    test('Wild Draw Four card effect', () {
      player1.addCard(
          const Card(color: CardColor.wild, type: CardType.wildDrawFour));

      final result = game.playCard(player1, player1.hand.first,
          chosenColor: CardColor.green);

      expect(result.success, true);
      expect(game.currentColor, CardColor.green); // Color changed
      expect(player2.hand.length, 4); // Drew 4 cards
      expect(game.currentPlayerIndex, 2); // Skipped player2
    });
  });

  group('UNO Calling and Catching', () {
    late Game game;
    late Player player1;
    late Player player2;

    setUp(() {
      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');

      game = Game(
        players: [player1, player2],
        unoPenaltyCardCount: 2,
      );

      // Set up game state
      game.state = GameState.playing;

      // Add cards to player1's hand (1 card for UNO)
      player1.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));

      // Add cards to player2's hand (normal hand)
      player2.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 7),
        const Card(color: CardColor.green, type: CardType.skip),
      ]);

      // Add cards to the deck for drawing penalties
      for (int i = 0; i < 10; i++) {
        game.deck.discard(
            Card(color: CardColor.yellow, type: CardType.number, value: i));
      }
      game.deck.refillFromDiscardPile();
    });

    test('Call UNO successfully', () {
      final result = game.callUno(player1);

      expect(result.success, true);
      expect(player1.calledUno, true);
    });

    test('Call UNO fails when player has multiple cards', () {
      final result = game.callUno(player2);

      expect(result.success, false);
      expect(player2.calledUno, false);
    });

    test('Catch player who didn\'t call UNO', () {
      // Ensure player1 has UNO but hasn't called it
      expect(player1.hasUno, true);
      expect(player1.calledUno, false);

      final result = game.catchUno(player2, player1);

      expect(result.success, true);
      expect(player1.hand.length, 3); // Original + 2 penalty cards
    });

    test('Cannot catch player who called UNO', () {
      player1.calledUno = true;

      final result = game.catchUno(player2, player1);

      expect(result.success, false);
      expect(player1.hand.length, 1); // No penalty
    });

    test('Cannot catch player without UNO', () {
      final result = game.catchUno(player1, player2);

      expect(result.success, false);
      expect(player2.hand.length, 2); // No penalty
    });
  });

  group('Game Duration and History', () {
    test('Game records start and end time', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(players: players);

      expect(game.startTime, isNull);
      expect(game.endTime, isNull);
      expect(game.duration, Duration.zero);

      game.start();

      expect(game.startTime, isNotNull);
      expect(game.endTime, isNull);
      expect(game.duration.inSeconds, greaterThanOrEqualTo(0));

      // Set up for a win
      players[0].hand.clear();
      players[1].hand.clear();
      players[1].addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      game.deck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));
      game.currentColor = CardColor.red;
      game.currentPlayerIndex = 1;

      // Player plays their last card to win
      game.playCard(players[1], players[1].hand.first);

      expect(game.endTime, isNotNull);
      expect(game.duration.inSeconds, greaterThanOrEqualTo(0));
    });

    test('Game records action history', () {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final game = Game(players: players);

      // Start game
      game.start();

      // Check that start_game is in history
      expect(game.actionHistory.isNotEmpty, true);
      expect(game.actionHistory.first['action'], 'start_game');

      // Set up for playing a card
      players[0].hand.clear();
      players[0].addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      game.deck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));
      game.currentColor = CardColor.red;
      game.currentPlayerIndex = 0;

      // Play a card
      game.playCard(players[0], players[0].hand.first);

      // Check that play_card is in history
      expect(
          game.actionHistory
              .where((a) => a['action'] == 'play_card')
              .isNotEmpty,
          true);
    });
  });
}
