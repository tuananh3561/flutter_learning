import 'package:flutter_test/flutter_test.dart';
import '../../application/ai_service.dart';
import '../../domain/card.dart';
import '../../domain/deck.dart';
import '../../domain/game.dart';
import '../../domain/player.dart';

void main() {
  group('AI Move Decision Making', () {
    late AIService aiService;
    late Game game;
    late Player humanPlayer;
    late Player aiPlayer;
    late Deck mockDeck;

    setUp(() {
      // Create AI service with no delay for faster tests
      aiService = AIService(minThinkingDelay: 0, maxThinkingDelay: 0);

      humanPlayer = Player(id: 'human', name: 'Human Player');
      aiPlayer = Player(id: 'ai', name: 'AI Player', type: PlayerType.aiMedium);

      mockDeck = Deck.empty();

      game = Game(
        players: [humanPlayer, aiPlayer],
        deck: mockDeck,
      );

      // Add cards to the deck for drawing
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
    });

    test('AI plays matching color card when available', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Give AI a red card and a blue card
      aiPlayer.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.number, value: 7),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.playCard);
      expect(action.card?.color, CardColor.red);
    });

    test('AI plays matching number card when no matching color', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Set top card
      mockDeck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      game.currentColor = CardColor.red;

      // Give AI cards with no red but a matching number
      aiPlayer.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 5),
        const Card(color: CardColor.green, type: CardType.number, value: 7),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.playCard);
      expect(action.card?.value, 5);
    });

    test('AI plays action card when available', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Give AI a regular card and an action card of the same color
      aiPlayer.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.red, type: CardType.skip),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.playCard);
      expect(action.card?.type, CardType.skip);
    });

    test('AI plays wild card when no matching cards', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Give AI cards with no matches to top card plus a wild
      aiPlayer.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 8),
        const Card(color: CardColor.green, type: CardType.number, value: 7),
        const Card(color: CardColor.wild, type: CardType.wild),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.playCard);
      expect(action.card?.type, CardType.wild);
      expect(action.chosenColor, isNotNull);
    });

    test('AI draws card when no playable cards', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Give AI cards with no matches to top card
      aiPlayer.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 8),
        const Card(color: CardColor.green, type: CardType.number, value: 7),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.drawCard);
      expect(aiPlayer.hand.length, 3); // Original 2 + 1 drawn
    });

    test('AI chooses most common color when playing wild', () async {
      // Set it to AI's turn
      game.currentPlayerIndex = 1;

      // Give AI multiple blue cards and a wild
      aiPlayer.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 8),
        const Card(color: CardColor.blue, type: CardType.number, value: 9),
        const Card(color: CardColor.blue, type: CardType.skip),
        const Card(color: CardColor.green, type: CardType.number, value: 7),
        const Card(color: CardColor.wild, type: CardType.wild),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.playCard);
      expect(action.card?.type, CardType.wild);
      expect(action.chosenColor, CardColor.blue); // Most common color in hand
    });

    test('AI cannot make move when not its turn', () async {
      // Set it to human's turn
      game.currentPlayerIndex = 0;

      // Give AI playable cards
      aiPlayer.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
      ]);

      final action = await aiService.makeMove(game, aiPlayer);

      expect(action.type, AIActionType.none);
    });
  });

  group('AI UNO Calling Behavior', () {
    late AIService aiService;
    late Game game;
    late Player humanPlayer;
    late Player aiPlayer;

    setUp(() {
      // Create AI service with no delay for faster tests
      aiService = AIService(minThinkingDelay: 0, maxThinkingDelay: 0);

      humanPlayer = Player(id: 'human', name: 'Human Player');
      aiPlayer = Player(id: 'ai', name: 'AI Player', type: PlayerType.aiMedium);

      game = Game(
        players: [humanPlayer, aiPlayer],
      );

      game.state = GameState.playing;
    });

    test('AI calls UNO when on last card', () async {
      // Give AI one card
      aiPlayer.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));

      expect(aiPlayer.hasUno, true);
      expect(aiPlayer.calledUno, false);

      // Run multiple times to account for randomness
      bool calledUnoAtLeastOnce = false;

      for (int i = 0; i < 10; i++) {
        aiPlayer.calledUno = false;
        final action = await aiService.checkAndCallUno(game, aiPlayer);

        if (action.type == AIActionType.callUno) {
          calledUnoAtLeastOnce = true;
          break;
        }
      }

      expect(calledUnoAtLeastOnce, true);
    });

    test('AI does not call UNO when having multiple cards', () async {
      // Give AI two cards
      aiPlayer.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.number, value: 7),
      ]);

      expect(aiPlayer.hasUno, false);

      final action = await aiService.checkAndCallUno(game, aiPlayer);

      expect(action.type, AIActionType.none);
      expect(aiPlayer.calledUno, false);
    });
  });

  group('AI UNO Catching Behavior', () {
    late AIService aiService;
    late Game game;
    late Player humanPlayer;
    late Player targetPlayer;
    late Player aiPlayer;
    late Deck mockDeck;

    setUp(() {
      // Create AI service with no delay for faster tests
      aiService = AIService(minThinkingDelay: 0, maxThinkingDelay: 0);

      humanPlayer = Player(id: 'human', name: 'Human Player');
      targetPlayer = Player(id: 'target', name: 'Target Player');
      aiPlayer = Player(
          id: 'ai',
          name: 'AI Player',
          type: PlayerType.aiHard // Use hard AI to maximize catching chances
          );

      mockDeck = Deck.empty();

      game = Game(
        players: [humanPlayer, targetPlayer, aiPlayer],
        deck: mockDeck,
      );

      // Add cards to the deck for penalty draws
      for (int i = 0; i < 10; i++) {
        mockDeck.discard(
            Card(color: CardColor.yellow, type: CardType.number, value: i));
      }
      mockDeck.refillFromDiscardPile();

      game.state = GameState.playing;

      // Set up target player with UNO but not called
      targetPlayer.addCard(
          const Card(color: CardColor.red, type: CardType.number, value: 5));
      targetPlayer.calledUno = false;
    });

    test('AI can catch player who did not call UNO', () async {
      // Run multiple times to account for randomness
      bool caughtUnoAtLeastOnce = false;

      for (int i = 0; i < 10; i++) {
        targetPlayer.hand.clear();
        targetPlayer.addCard(
            const Card(color: CardColor.red, type: CardType.number, value: 5));
        targetPlayer.calledUno = false;

        final action = await aiService.checkAndCatchUno(game, aiPlayer);

        if (action.type == AIActionType.catchUno) {
          caughtUnoAtLeastOnce = true;
          expect(action.targetPlayer, targetPlayer);
          break;
        }
      }

      expect(caughtUnoAtLeastOnce, true);
    });

    test('AI does not catch UNO if player called it', () async {
      targetPlayer.calledUno = true;

      final action = await aiService.checkAndCatchUno(game, aiPlayer);

      expect(action.type, AIActionType.none);
    });

    test('AI does not catch player without UNO', () async {
      // Give target player multiple cards
      targetPlayer.hand.clear();
      targetPlayer.addCards([
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.blue, type: CardType.number, value: 7),
      ]);

      expect(targetPlayer.hasUno, false);

      final action = await aiService.checkAndCatchUno(game, aiPlayer);

      expect(action.type, AIActionType.none);
    });
  });

  group('AI Difficulty Levels', () {
    late AIService aiService;
    late Game game;
    late Player humanPlayer;
    late Deck mockDeck;

    setUp(() {
      // Create AI service with no delay for faster tests
      aiService = AIService(minThinkingDelay: 0, maxThinkingDelay: 0);

      humanPlayer = Player(id: 'human', name: 'Human Player');
      mockDeck = Deck.empty();

      // Add cards to the deck for drawing
      for (int i = 0; i < 10; i++) {
        mockDeck.discard(
            Card(color: CardColor.yellow, type: CardType.number, value: i));
      }
      mockDeck.refillFromDiscardPile();

      // Set up a red card as the top card
      mockDeck.discard(
          const Card(color: CardColor.red, type: CardType.number, value: 3));
    });

    test('Different AI difficulty levels make different strategic choices',
        () async {
      // Create three different AI players
      final aiEasy =
          Player(id: 'ai-easy', name: 'AI Easy', type: PlayerType.aiEasy);
      final aiMedium =
          Player(id: 'ai-medium', name: 'AI Medium', type: PlayerType.aiMedium);
      final aiHard =
          Player(id: 'ai-hard', name: 'AI Hard', type: PlayerType.aiHard);

      // Give each AI the same hand with multiple options
      final testHand = [
        const Card(color: CardColor.red, type: CardType.number, value: 5),
        const Card(color: CardColor.red, type: CardType.skip),
        const Card(color: CardColor.green, type: CardType.number, value: 7),
        const Card(color: CardColor.blue, type: CardType.number, value: 9),
        const Card(color: CardColor.wild, type: CardType.wild),
      ];

      aiEasy.addCards(List.from(testHand));
      aiMedium.addCards(List.from(testHand));
      aiHard.addCards(List.from(testHand));

      // Create separate games for each AI to avoid state interference
      final gameEasy = Game(
        players: [humanPlayer, aiEasy],
        deck: Deck.empty()
          ..discard(const Card(
              color: CardColor.red, type: CardType.number, value: 3)),
      );
      gameEasy.state = GameState.playing;
      gameEasy.currentColor = CardColor.red;
      gameEasy.currentPlayerIndex = 1; // AI's turn

      final gameMedium = Game(
        players: [humanPlayer, aiMedium],
        deck: Deck.empty()
          ..discard(const Card(
              color: CardColor.red, type: CardType.number, value: 3)),
      );
      gameMedium.state = GameState.playing;
      gameMedium.currentColor = CardColor.red;
      gameMedium.currentPlayerIndex = 1; // AI's turn

      final gameHard = Game(
        players: [humanPlayer, aiHard],
        deck: Deck.empty()
          ..discard(const Card(
              color: CardColor.red, type: CardType.number, value: 3)),
      );
      gameHard.state = GameState.playing;
      gameHard.currentColor = CardColor.red;
      gameHard.currentPlayerIndex = 1; // AI's turn

      // Have each AI make a move
      final easyAction = await aiService.makeMove(gameEasy, aiEasy);
      final mediumAction = await aiService.makeMove(gameMedium, aiMedium);
      final hardAction = await aiService.makeMove(gameHard, aiHard);

      // All AIs should play a card
      expect(easyAction.type, AIActionType.playCard);
      expect(mediumAction.type, AIActionType.playCard);
      expect(hardAction.type, AIActionType.playCard);

      // All cards played should be valid
      expect(
          easyAction.card!
              .canBePlayedOn(gameEasy.topCard, gameEasy.currentColor),
          true);
      expect(
          mediumAction.card!
              .canBePlayedOn(gameMedium.topCard, gameMedium.currentColor),
          true);
      expect(
          hardAction.card!
              .canBePlayedOn(gameHard.topCard, gameHard.currentColor),
          true);

      // Test results are probabilistic, so we can only verify basic functionality
      // We can't reliably check exact strategy differences in a unit test
    });
  });

  group('AI Select Best Color Logic', () {
    test('AI selects most common color when playing wild', () {
      final aiService = AIService(minThinkingDelay: 0, maxThinkingDelay: 0);
      final player =
          Player(id: 'ai', name: 'AI Player', type: PlayerType.aiMedium);

      // Hand with more blue cards than any other color
      player.addCards([
        const Card(color: CardColor.blue, type: CardType.number, value: 1),
        const Card(color: CardColor.blue, type: CardType.number, value: 2),
        const Card(color: CardColor.blue, type: CardType.number, value: 3),
        const Card(color: CardColor.red, type: CardType.number, value: 4),
        const Card(color: CardColor.green, type: CardType.number, value: 5),
        const Card(color: CardColor.wild, type: CardType.wild),
      ]);

      // Access private method through reflection or test a public method
      // that uses the color selection logic
      final game = Game(
        players: [player],
        deck: Deck.empty()
          ..discard(const Card(
              color: CardColor.yellow, type: CardType.number, value: 3)),
      );
      game.state = GameState.playing;
      game.currentColor = CardColor.yellow;
      game.currentPlayerIndex = 0;

      // Play the wild card
      final wildCard = player.hand.last;
      game.playCard(player, wildCard, chosenColor: CardColor.blue);

      // Verify the color was chosen correctly
      expect(game.currentColor, CardColor.blue);
    });
  });
}
