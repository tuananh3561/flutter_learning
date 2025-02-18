import '../../domain/entities/card_entity.dart';

abstract class GameEvent {}

class GameInitialized extends GameEvent {}

class CardSelected extends GameEvent {
  final CardEntity card;
  CardSelected(this.card);
}
