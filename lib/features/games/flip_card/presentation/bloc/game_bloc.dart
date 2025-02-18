import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/card_entity.dart';
import '../../domain/entities/game_state.dart';
import 'game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc()
      : super(const GameState(
          cards: [],
          selectedCards: [],
          status: GameStatus.initial,
        )) {
    on<GameInitialized>(_onGameInitialized);
    on<CardSelected>(_onCardSelected);
  }

  void _onGameInitialized(GameInitialized event, Emitter<GameState> emit) {
    final cards = _generateCards();
    emit(state.copyWith(
      cards: cards,
      status: GameStatus.playing,
    ));
  }

  void _onCardSelected(CardSelected event, Emitter<GameState> emit) async {
    if (state.isProcessing ||
        state.selectedCards.length >= 2 ||
        event.card.isMatched ||
        event.card.isFlipped) {
      return;
    }

    // Flip selected card
    final updatedCards = state.cards.map((card) {
      if (card.id == event.card.id) {
        return card.copyWith(isFlipped: true);
      }
      return card;
    }).toList();

    final updatedSelectedCards = [...state.selectedCards, event.card];

    emit(state.copyWith(
      cards: updatedCards,
      selectedCards: updatedSelectedCards,
    ));

    // Check for match if two cards are selected
    if (updatedSelectedCards.length == 2) {
      emit(state.copyWith(isProcessing: true));
      await Future.delayed(const Duration(milliseconds: 1000));

      final isMatch = updatedSelectedCards[0].imagePath ==
          updatedSelectedCards[1].imagePath;

      final processedCards = state.cards.map((card) {
        if (updatedSelectedCards.any((c) => c.id == card.id)) {
          return card.copyWith(
            isMatched: isMatch,
            isFlipped: isMatch,
          );
        }
        return card;
      }).toList();

      final allMatched = processedCards.every((card) => card.isMatched);

      emit(state.copyWith(
        cards: processedCards,
        selectedCards: [],
        isProcessing: false,
        status: allMatched ? GameStatus.completed : GameStatus.playing,
      ));
    }
  }

  List<CardEntity> _generateCards() {
    const images = [
      'assets/images/word/dog.png',
      'assets/images/word/cat.png',
      'assets/images/word/bird.png',
    ];

    final cards = <CardEntity>[];
    var id = 0;

    for (final image in images) {
      for (var i = 0; i < 2; i++) {
        cards.add(CardEntity(
          id: id++,
          imagePath: image,
          soundPath:
              'assets/audio/word/${image.split('/').last.split('.').first}.mp3',
        ));
      }
    }

    cards.shuffle();
    return cards;
  }
}
