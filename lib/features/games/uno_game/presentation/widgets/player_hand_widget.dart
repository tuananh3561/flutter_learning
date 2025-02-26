import 'package:flutter/material.dart';
import '../../domain/card.dart' as domain;
import '../../domain/player.dart';
import './card_widget.dart';

class PlayerHandWidget extends StatefulWidget {
  final Player player;
  final bool isCurrentPlayer;
  final bool isHuman;
  final Function(domain.Card)? onCardSelected;
  final domain.Card? topCard;
  final domain.CardColor? currentColor;

  /// Maximum width available for the hand
  final double maxWidth;

  /// Whether to animate when cards are added or removed
  final bool animate;

  /// Additional offset for the hand position
  final Offset? handOffset;

  const PlayerHandWidget({
    Key? key,
    required this.player,
    required this.isCurrentPlayer,
    this.isHuman = true,
    this.onCardSelected,
    this.topCard,
    this.currentColor,
    this.maxWidth = 400,
    this.animate = true,
    this.handOffset,
  }) : super(key: key);

  @override
  _PlayerHandWidgetState createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget>
    with SingleTickerProviderStateMixin {
  domain.Card? _selectedCard;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Keep track of previous hand for animations
  List<domain.Card> _previousHand = [];

  @override
  void initState() {
    super.initState();
    _previousHand = List.from(widget.player.hand);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start with animation completed
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(PlayerHandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the hand has changed, restart animation
    if (widget.animate &&
        (widget.player.hand.length != _previousHand.length ||
            _hasHandContentChanged())) {
      _previousHand = List.from(oldWidget.player.hand);
      _animationController.reset();
      _animationController.forward();
    }
  }

  bool _hasHandContentChanged() {
    if (widget.player.hand.length != _previousHand.length) return true;

    for (int i = 0; i < widget.player.hand.length; i++) {
      final current = widget.player.hand[i];
      final previous = _previousHand[i];

      if (current.color != previous.color ||
          current.type != previous.type ||
          current.value != previous.value) {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.player.hand;

    // For non-human players, show the back of the cards
    if (!widget.isHuman) {
      return _buildOpponentHand(cards);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth.clamp(0, widget.maxWidth).toDouble();

        // Calculate appropriate card spacing based on hand size and available width
        const cardWidth = 80.0; // Width of a single card
        final cardVisibleWidth =
            _calculateCardVisibleWidth(cards.length, availableWidth, cardWidth);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: 140,
              width: availableWidth,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Build each card in the hand
                  for (int i = 0; i < cards.length; i++)
                    Positioned(
                      left: widget.handOffset?.dx ?? 0 + i * cardVisibleWidth,
                      top: widget.handOffset?.dy ?? 0,
                      child: Transform.translate(
                        offset: _getCardOffset(i, cards.length),
                        child: _buildPlayerCard(cards[i], i, cards.length),
                      ),
                    ),

                  // UNO indicator
                  if (widget.player.calledUno)
                    Positioned(
                      top: -20,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'UNO!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  // Player indicator
                  if (widget.isCurrentPlayer)
                    Positioned(
                      bottom: -15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            'Your Turn',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOpponentHand(List<domain.Card> cards) {
    // For opponents, show cards face down
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth.clamp(0, widget.maxWidth).toDouble();

        // Calculate card spacing
        const cardWidth = 80.0;
        final cardVisibleWidth =
            _calculateCardVisibleWidth(cards.length, availableWidth, cardWidth);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: 120,
              width: availableWidth,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < cards.length; i++)
                    Positioned(
                      left: widget.handOffset?.dx ?? 0 + i * cardVisibleWidth,
                      top: widget.handOffset?.dy ?? 0,
                      child: Transform.translate(
                        offset: _getCardOffset(i, cards.length),
                        child: CardWidget(
                          card: cards[i],
                          faceDown: true,
                          scale: 0.9,
                        ),
                      ),
                    ),

                  // UNO indicator
                  if (widget.player.calledUno)
                    Positioned(
                      top: -20,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'UNO!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  // Current player indicator
                  if (widget.isCurrentPlayer)
                    Positioned(
                      bottom: -15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${widget.player.name}\'s Turn',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlayerCard(domain.Card card, int index, int totalCards) {
    final bool isPlayable = widget.isCurrentPlayer &&
        (widget.topCard == null ||
            card.canBePlayedOn(
                widget.topCard!, widget.currentColor ?? card.color));

    return CardWidget(
      card: card,
      faceDown: false,
      isPlayable: isPlayable,
      isSelected: _selectedCard == card,
      scale: 1.0,
      onTap: () {
        if (isPlayable && widget.onCardSelected != null) {
          setState(() {
            _selectedCard = card;
          });
          widget.onCardSelected!(card);
        }
      },
    );
  }

  double _calculateCardVisibleWidth(
      int cardCount, double availableWidth, double cardWidth) {
    if (cardCount <= 1) return 0;

    // Calculate how much each card can overlap
    final maxOverlap = cardWidth * 0.7; // Allow up to 70% overlap
    final requiredWidth =
        cardWidth + (cardCount - 1) * (cardWidth - maxOverlap);

    if (requiredWidth <= availableWidth) {
      // No need for overlap
      return cardWidth;
    } else {
      // Calculate overlap needed
      final totalOverlap = requiredWidth - availableWidth;
      final overlapPerCard = totalOverlap / (cardCount - 1);
      return cardWidth - overlapPerCard.clamp(0, maxOverlap);
    }
  }

  Offset _getCardOffset(int index, int totalCards) {
    // Apply a slight upward offset to the selected card
    if (widget.player.hand[index] == _selectedCard) {
      return const Offset(0, -20);
    }

    // Fan the cards slightly
    final middleIndex = (totalCards - 1) / 2;
    final relativeIndex = index - middleIndex;
    const maxRotation = 0.1; // Max rotation in radians

    // Distribute cards evenly
    return const Offset(0, 0);
  }
}
