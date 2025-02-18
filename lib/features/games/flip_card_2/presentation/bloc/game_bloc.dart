import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../audio_service.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/game_state.dart';
import '../../config/asset_paths.dart';
import 'game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AudioService audioService;
  Timer? _previewTimer;

  GameBloc({required this.audioService})
      : super(GameState(
          cards: [],
          selectedCards: [],
          phase: GamePhase.initial,
        )) {
    on<GameInitialized>(_onGameInitialized);
    on<CardSelected>(_onCardSelected);
    on<PreviewCompleted>(_onPreviewCompleted);
    on<ShuffleCompleted>(_onShuffleCompleted);
  }

  void _onGameInitialized(
      GameInitialized event, Emitter<GameState> emit) async {
    final cards = _generateCards();

    // Start with all cards face down
    emit(state.copyWith(
      cards: cards,
      phase: GamePhase.preview,
    ));

    // Flip all cards face up for preview
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
      cards: cards.map((card) => card.copyWith(isFlipped: true)).toList(),
    ));

    // Start preview timer
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(seconds: 3), () {
      add(PreviewCompleted());
    });
  }

  void _onPreviewCompleted(PreviewCompleted event, Emitter<GameState> emit) {
    // Flip all cards face down
    final updatedCards =
        state.cards.map((card) => card.copyWith(isFlipped: false)).toList();

    emit(state.copyWith(
      cards: updatedCards,
      phase: GamePhase.shuffle,
    ));

    // Start shuffle animation
    _shuffleCards();
  }

  void _shuffleCards() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    add(ShuffleCompleted());
  }

  void _onShuffleCompleted(ShuffleCompleted event, Emitter<GameState> emit) {
    final shuffledCards = List<CardEntity>.from(state.cards)..shuffle();

    // Update positions after shuffle
    final updatedCards = shuffledCards
        .asMap()
        .map((index, card) {
          final position = _calculateCardPosition(index);
          return MapEntry(index, card.copyWith(position: position));
        })
        .values
        .toList();

    emit(state.copyWith(
      cards: updatedCards,
      phase: GamePhase.playing,
    ));

    audioService.playGameStart();
  }

  void _onCardSelected(CardSelected event, Emitter<GameState> emit) async {
    if (state.phase != GamePhase.playing ||
        state.isProcessing ||
        event.card.isMatched ||
        event.card.isFlipped) {
      return;
    }

    audioService.playCardFlip();

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

      final isMatch = updatedSelectedCards[0].imagePath ==
          updatedSelectedCards[1].imagePath;

      if (isMatch) {
        await _handleMatch(updatedSelectedCards, emit);
      } else {
        await _handleNonMatch(updatedCards, emit);
      }
    }
  }

  Future<void> _handleMatch(
      List<CardEntity> selectedCards, Emitter<GameState> emit) async {
    // Fade out matched cards
    final processedCards = state.cards.map((card) {
      if (selectedCards.any((c) => c.id == card.id)) {
        return card.copyWith(isMatched: true);
      }
      return card;
    }).toList();

    emit(state.copyWith(
      cards: processedCards,
      selectedCards: [],
      phase: GamePhase.matching,
      matchedCard: selectedCards.first,
    ));

    // Play match sound and show center image
    audioService.playMatchSound(selectedCards.first.soundPath);

    await Future.delayed(const Duration(milliseconds: 3000));

    // Clear center display
    emit(state.copyWith(
      matchedCard: null,
      phase: GamePhase.playing,
      isProcessing: false,
    ));

    // Check for game completion
    final allMatched = processedCards.every((card) => card.isMatched);
    if (allMatched) {
      audioService.playVictory();
      emit(state.copyWith(phase: GamePhase.completed));
    }
  }

  Future<void> _handleNonMatch(
      List<CardEntity> cards, Emitter<GameState> emit) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Flip cards back
    final updatedCards = cards.map((card) {
      if (state.selectedCards.any((c) => c.id == card.id)) {
        return card.copyWith(isFlipped: false);
      }
      return card;
    }).toList();

    audioService.playCardFlip();

    emit(state.copyWith(
      cards: updatedCards,
      selectedCards: [],
      isProcessing: false,
    ));
  }

  List<CardEntity> _generateCards() {
    const images = AssetPaths.cardImages;

    final cards = <CardEntity>[];
    var id = 0;

    for (final image in images) {
      for (var i = 0; i < 2; i++) {
        cards.add(CardEntity(
          id: id++,
          imagePath: image,
          soundPath: AssetPaths.getMatchSoundPath(image),
          position: _calculateCardPosition(id - 1),
        ));
      }
    }

    return cards..shuffle();
  }

  Offset _calculateCardPosition(int index) {
    final row = index ~/ 3;
    final col = index % 3;
    return Offset(col * 120.0, row * 160.0);
  }

  @override
  Future<void> close() {
    _previewTimer?.cancel();
    return super.close();
  }
}
