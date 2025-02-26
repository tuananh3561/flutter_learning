import 'package:flutter/material.dart';
import '../../domain/card.dart' as domain;

class CardWidget extends StatelessWidget {
  final domain.Card card;
  final bool faceDown;
  final bool isPlayable;
  final bool isSelected;
  final double scale;
  final VoidCallback? onTap;
  final bool showShadow;

  const CardWidget({
    Key? key,
    required this.card,
    this.faceDown = false,
    this.isPlayable = true,
    this.isSelected = false,
    this.scale = 1.0,
    this.onTap,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPlayable ? onTap : null,
      child: Transform.scale(
        scale: scale * (isSelected ? 1.1 : 1.0),
        child: Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: showShadow
                ? [
                    const BoxShadow(
                      color: Colors.black38,
                      offset: Offset(2, 3),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: faceDown ? _buildCardBack() : _buildCardFront(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _getCardBackgroundColor(),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Card background pattern
          _buildCardPattern(),

          // Card value/symbol
          Center(
            child: _buildCardContent(),
          ),

          // Top-left corner label
          Positioned(
            top: 5,
            left: 5,
            child: _buildCornerLabel(),
          ),

          // Bottom-right corner label (reversed)
          Positioned(
            bottom: 5,
            right: 5,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: _buildCornerLabel(),
            ),
          ),

          // Overlay for non-playable cards
          if (!isPlayable && !faceDown)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          // Selection indicator
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.indigo.shade800,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.indigo.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              'UNO',
              style: TextStyle(
                color: Colors.yellow.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPattern() {
    switch (card.type) {
      case domain.CardType.skip:
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.block,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );

      case domain.CardType.reverse:
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );

      case domain.CardType.drawTwo:
        return Stack(
          children: [
            Positioned(
              top: 35,
              left: 15,
              child: Transform.rotate(
                angle: -0.2,
                child: _miniCard(30, 45),
              ),
            ),
            Positioned(
              top: 35,
              right: 15,
              child: Transform.rotate(
                angle: 0.2,
                child: _miniCard(30, 45),
              ),
            ),
          ],
        );

      case domain.CardType.wild:
      case domain.CardType.wildDrawFour:
        return Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                ],
                stops: [0.0, 0.33, 0.66, 1.0],
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCardContent() {
    if (card.type == domain.CardType.number) {
      return Text(
        '${card.value}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (card.type == domain.CardType.wildDrawFour) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Wild card circle is already in pattern
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _miniCard(20, 30),
                const SizedBox(width: 2),
                _miniCard(20, 30),
                const SizedBox(width: 2),
                _miniCard(20, 30),
                const SizedBox(width: 2),
                _miniCard(20, 30),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCornerLabel() {
    Widget content;

    switch (card.type) {
      case domain.CardType.number:
        content = Text(
          '${card.value}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
        break;

      case domain.CardType.skip:
        content = const Icon(
          Icons.block,
          color: Colors.white,
          size: 12,
        );
        break;

      case domain.CardType.reverse:
        content = const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 12,
        );
        break;

      case domain.CardType.drawTwo:
        content = const Text(
          '+2',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        break;

      case domain.CardType.wild:
        content = const Icon(
          Icons.widgets,
          color: Colors.white,
          size: 12,
        );
        break;

      case domain.CardType.wildDrawFour:
        content = const Text(
          '+4',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(2),
      child: content,
    );
  }

  Color _getCardBackgroundColor() {
    switch (card.color) {
      case domain.CardColor.red:
        return Colors.red;
      case domain.CardColor.blue:
        return Colors.blue;
      case domain.CardColor.green:
        return Colors.green;
      case domain.CardColor.yellow:
        return Colors.amber;
      case domain.CardColor.wild:
        return Colors.black;
    }
  }

  Widget _miniCard(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Card animation widget for playing/drawing animations
class AnimatedCardWidget extends StatefulWidget {
  final domain.Card card;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback? onComplete;
  final double startScale;
  final double endScale;
  final bool faceDown;

  const AnimatedCardWidget({
    Key? key,
    required this.card,
    required this.startPosition,
    required this.endPosition,
    this.onComplete,
    this.startScale = 1.0,
    this.endScale = 1.0,
    this.faceDown = false,
  }) : super(key: key);

  @override
  _AnimatedCardWidgetState createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.startScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: CardWidget(
              card: widget.card,
              faceDown: widget.faceDown,
              scale: 1.0,
              showShadow: true,
            ),
          ),
        );
      },
    );
  }
}
