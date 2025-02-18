import 'package:equatable/equatable.dart';

import 'card_entity.dart';

enum GamePhase {
  initial, // Initial game state
  preview, // Showing all cards face up for 3 seconds
  shuffle, // Shuffling cards animation
  playing, // Main gameplay phase
  matching, // Showing matched card in center
  completed // Game completed
}

class GameState extends Equatable {
  final List<CardEntity> cards;
  final List<CardEntity> selectedCards;
  final GamePhase phase;
  final bool isProcessing;
  final CardEntity? matchedCard; // For center display
  final String? matchSound; // Sound to play for match

  const GameState({
    required this.cards,
    required this.selectedCards,
    required this.phase,
    this.isProcessing = false,
    this.matchedCard,
    this.matchSound,
  });

  GameState copyWith({
    List<CardEntity>? cards,
    List<CardEntity>? selectedCards,
    GamePhase? phase,
    bool? isProcessing,
    CardEntity? matchedCard,
    String? matchSound,
  }) {
    return GameState(
      cards: cards ?? this.cards,
      selectedCards: selectedCards ?? this.selectedCards,
      phase: phase ?? this.phase,
      isProcessing: isProcessing ?? this.isProcessing,
      matchedCard: matchedCard,
      matchSound: matchSound,
    );
  }

  @override
  List<Object?> get props => [
        cards,
        selectedCards,
        phase,
        isProcessing,
        matchedCard,
        matchSound,
      ];
}
