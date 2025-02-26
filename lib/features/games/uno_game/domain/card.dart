import 'package:flutter/foundation.dart';

enum CardColor { red, blue, green, yellow, wild }

enum CardType { number, skip, reverse, drawTwo, wild, wildDrawFour }

/// Represents a single UNO card.
class Card {
  final CardColor color;
  final CardType type;
  final int? value; // Null for special cards

  /// Creates a new Card with specified properties
  const Card({required this.color, required this.type, this.value})
      : assert(
            (type == CardType.number &&
                    value != null &&
                    value >= 0 &&
                    value <= 9) ||
                (type != CardType.number && (value == null || value == -1)),
            'Number cards must have values 0-9, non-number cards must have null value');

  /// Determines if this card can be played on top of the given card
  /// according to UNO rules
  bool canBePlayedOn(Card topCard, CardColor currentColor) {
    // Wild cards can always be played
    if (type == CardType.wild || type == CardType.wildDrawFour) {
      return true;
    }

    // Match by color or by type/value
    return color == currentColor ||
        (type == topCard.type) ||
        (type == CardType.number && value == topCard.value);
  }

  /// Returns point value of this card according to UNO scoring rules
  int get points {
    switch (type) {
      case CardType.number:
        return value ?? 0;
      case CardType.skip:
      case CardType.reverse:
      case CardType.drawTwo:
        return 20;
      case CardType.wild:
      case CardType.wildDrawFour:
        return 50;
      default:
        return 0;
    }
  }

  /// Creates a string representation of the card
  @override
  String toString() {
    switch (type) {
      case CardType.number:
        return '${color.name} $value';
      case CardType.skip:
        return '${color.name} Skip';
      case CardType.reverse:
        return '${color.name} Reverse';
      case CardType.drawTwo:
        return '${color.name} Draw Two';
      case CardType.wild:
        return 'Wild';
      case CardType.wildDrawFour:
        return 'Wild Draw Four';
      default:
        return 'Unknown Card';
    }
  }

  /// Checks if two cards are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Card &&
        other.color == color &&
        other.type == type &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(color, type, value);

  /// Creates a copy of this card, optionally changing some properties
  Card copyWith({
    CardColor? color,
    CardType? type,
    int? value,
  }) {
    return Card(
      color: color ?? this.color,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
