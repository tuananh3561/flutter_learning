import 'package:flutter_test/flutter_test.dart';

import '../../application/game_service.dart';
import '../../domain/card.dart';
import '../../domain/game.dart';
import '../../domain/player.dart';
import '../../domain/enums/game_state.dart';

void main() {
  group('GameService Initialization and Game Creation', () {
    late GameService gameService;

    setUp(() {
      gameService = GameService();
    });

    tearDown(() {
      gameService.dispose();
    });

    test('Initial state has no game', () {
      expect(gameService.game, isNull);
    });

    test('Initialize game with players', () async {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final result = await gameService.initializeGame(players: players);

      expect(result, true);
      expect(gameService.game, isNotNull);
      expect(gameService.game!.players, players);
      expect(gameService.game!.state, GameState.notStarted);
    });

    test('Initialize game with custom rule variants', () async {
      final players = [
        Player(id: 'p1', name: 'Player 1'),
        Player(id: 'p2', name: 'Player 2'),
      ];

      final ruleVariants = [
        GameRuleVariant.stackingDraw,
        GameRuleVariant.forcePlay,
      ];

      await gameService.initializeGame(
        players: players,
        ruleVariants: ruleVariants,
      );

      expect(
          gameService.isRuleVariantActive(GameRuleVariant.stackingDraw), true);
      expect(gameService.isRuleVariantActive(GameRuleVariant.forcePlay), true);
      expect(gameService.isRuleVariantActive(GameRuleVariant.standard), false);
    });

    test('Cannot initialize game with fewer than 2 players', () async {
      final players = [Player(id: 'p1', name: 'Player 1')];

      final result = await gameService.initializeGame(players: players);

      expect(result, false);
      expect(gameService.game, isNull);
    });
  });

  group('GameService Game Flow', () {
    late GameService gameService;
    late Player player1;
    late Player player2;

    setUp(() {
      gameService = GameService();

      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');

      gameService.initializeGame(players: [player1, player2]);
    });

    tearDown(() {
      gameService.dispose();
    });

    test('Start game deals cards and sets up initial state', () async {
      await gameService.startGame();

      expect(gameService.game!.state, GameState.playing);
      expect(player1.hand.length, 7);
      expect(player2.hand.length, 7);
    });

    test('Game events are emitted', () async {
      // Listen for game events
      List<GameEvent> events = [];
      gameService.eventStream.listen((event) {
        events.add(event);
      });

      await gameService.startGame();

      // Should have at least gameInitialized and gameStarted events
      expect(events.length, greaterThanOrEqualTo(2));
      expect(
          events
              .where((e) => e.type == GameEventType.gameInitialized)
              .isNotEmpty,
          true);
      expect(
          events.where((e) => e.type == GameEventType.gameStarted).isNotEmpty,
          true);
    });

    test('Reset game clears state', () async {
      await gameService.startGame();

      expect(gameService.game, isNotNull);

      gameService.resetGame();

      expect(gameService.game, isNull);
    });
  });

  group('GameService Player Management', () {
    late GameService gameService;
    late Player player1;
    late Player player2;
    late Player player3;

    setUp(() {
      gameService = GameService();

      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');
      player3 = Player(id: 'p3', name: 'Player 3');

      gameService.initializeGame(players: [player1, player2]);
    });

    tearDown(() {
      gameService.dispose();
    });

    test('Add player before game starts', () async {
      final result = await gameService.addPlayer(player3);

      expect(result, true);
      expect(gameService.game!.players.length, 3);
      expect(gameService.game!.players.contains(player3), true);
    });

    test('Cannot add player with duplicate ID', () async {
      final duplicatePlayer = Player(id: 'p1', name: 'Duplicate Player');

      final result = await gameService.addPlayer(duplicatePlayer);

      expect(result, false);
      expect(gameService.game!.players.length, 2);
    });

    test('Remove player before game starts', () async {
      final result = await gameService.removePlayer(player2);

      expect(result, true);
      expect(gameService.game!.players.length, 1);
      expect(gameService.game!.players.contains(player2), false);
    });

    test('Cannot add/remove player after game starts', () async {
      await gameService.startGame();

      final addResult = await gameService.addPlayer(player3);
      final removeResult = await gameService.removePlayer(player2);

      expect(addResult, false);
      expect(removeResult, false);
      expect(gameService.game!.players.length, 2);
    });

    test('Mark player as inactive when removed during game', () async {
      await gameService.startGame();

      // Hack: set game state to playing (should already be, but just in case)
      gameService.game!.state = GameState.playing;

      // Use removePlayer to mark player2 as inactive
      final removeResult = await gameService.removePlayer(player2);

      // Should still "succeed" but player isn't actually removed
      expect(removeResult, true);
      expect(gameService.game!.players.length, 2);
      expect(gameService.game!.players.contains(player2), true);
      expect(player2.isActive, false);
    });
  });

  group('GameService Game Actions', () {
    late GameService gameService;
    late Player player1;
    late Player player2;

    setUp(() async {
      gameService = GameService();

      player1 = Player(id: 'p1', name: 'Player 1');
      player2 = Player(id: 'p2', name: 'Player 2');

      await gameService.initializeGame(players: [player1, player2]);
      await gameService.startGame();

      // Clear player hands to set up specific test scenarios
      player1.hand.clear();
      player2.hand.clear();
    });

    tearDown(() {
      gameService.dispose();
    });

    test('Play card', () async {
      // Set up game state for testing
      const card = Card(color: CardColor.red, type: CardType.number, value: 5);
      player1.addCard(card);

      gameService.game!.deck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));
      gameService.game!.currentColor = CardColor.red;
      gameService.game!.currentPlayerIndex = 0; // player1's turn

      final result = await gameService.playCard(player1, card);

      expect(result, true);
      expect(player1.hand.isEmpty, true);
      expect(gameService.game!.topCard, card);
    });

    test('Draw card', () async {
      // Set up game state for testing
      gameService.game!.deck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));
      gameService.game!.currentColor = CardColor.red;
      gameService.game!.currentPlayerIndex = 0; // player1's turn

      // Add a card to draw pile
      gameService.game!.deck.discard(
          const Card(color: CardColor.blue, type: CardType.number, value: 7));
      gameService.game!.deck.refillFromDiscardPile();

      final drawnCard = await gameService.drawCard(player1);

      expect(drawnCard, isNotNull);
      expect(player1.hand.length, 1);
      expect(player1.hand.first, drawnCard);
    });

    test('Call UNO', () async {
      // Set up player with one card
      player1.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));

      expect(player1.hasUno, true);
      expect(player1.calledUno, false);

      final result = await gameService.callUno(player1);

      expect(result, true);
      expect(player1.calledUno, true);
    });

    test('Catch UNO', () async {
      // Set up player with one card who hasn't called UNO
      player1.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));

      expect(player1.hasUno, true);
      expect(player1.calledUno, false);

      // Add cards to draw pile for penalty
      for (int i = 0; i < 3; i++) {
        gameService.game!.deck.discard(
            Card(color: CardColor.yellow, type: CardType.number, value: i));
      }
      gameService.game!.deck.refillFromDiscardPile();

      final result = await gameService.catchUno(player2, player1);

      expect(result, true);
      expect(player1.hand.length, 3); // Original + 2 penalty cards
    });
  });
}
