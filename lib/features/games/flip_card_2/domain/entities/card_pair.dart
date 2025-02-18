import 'package:equatable/equatable.dart';

import 'card_entity.dart';

class CardPair extends Equatable {
  final CardEntity firstCard;
  final CardEntity secondCard;

  const CardPair({
    required this.firstCard,
    required this.secondCard,
  });

  bool get isMatched => firstCard.imagePath == secondCard.imagePath;

  @override
  List<Object?> get props => [firstCard, secondCard];
}
