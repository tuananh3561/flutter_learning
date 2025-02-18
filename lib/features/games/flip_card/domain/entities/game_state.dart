import 'card_entity.dart';

enum GameStatus { initial, playing, completed }

class GameState {
  final List<CardEntity> cards;
  final List<CardEntity> selectedCards;
  final GameStatus status;
  final bool isProcessing;

  const GameState({
    required this.cards,
    required this.selectedCards,
    required this.status,
    this.isProcessing = false,
  });

  GameState copyWith({
    List<CardEntity>? cards,
    List<CardEntity>? selectedCards,
    GameStatus? status,
    bool? isProcessing,
  }) {
    return GameState(
      cards: cards ?? this.cards,
      selectedCards: selectedCards ?? this.selectedCards,
      status: status ?? this.status,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
