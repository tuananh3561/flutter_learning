import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../domain/card.dart' as domain;
import '../../domain/game.dart';
import '../../domain/player.dart';
import '../state/game_provider.dart';
import './card_widget.dart';
import './player_hand_widget.dart';
import './color_picker_widget.dart';

class GameTableWidget extends StatefulWidget {
  const GameTableWidget({Key? key}) : super(key: key);

  @override
  _GameTableWidgetState createState() => _GameTableWidgetState();
}

class _GameTableWidgetState extends State<GameTableWidget>
    with TickerProviderStateMixin {
  domain.Card? _selectedCard;
  domain.CardColor? _selectedWildColor;
  bool _isColorPickerVisible = false;
  bool _isDrawing = false;
  bool _isPlaying = false;

  // Animation controllers
  late AnimationController _tableAnimationController;
  late Animation<double> _tableAnimation;

  // Card animations
  final List<Widget> _animatedCards = [];

  @override
  void initState() {
    super.initState();

    _tableAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _tableAnimation = CurvedAnimation(
      parent: _tableAnimationController,
      curve: Curves.easeInOut,
    );

    _tableAnimationController.forward();
  }

  @override
  void dispose() {
    _tableAnimationController.dispose();
    super.dispose();
  }

  void _playCard(domain.Card card, GameProvider gameProvider) {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    // For wild cards, show color picker
    if (card.type == domain.CardType.wild ||
        card.type == domain.CardType.wildDrawFour) {
      setState(() {
        _selectedCard = card;
        _isColorPickerVisible = true;
      });
      return;
    }

    // Normal card play
    _playSelectedCard(card, null, gameProvider);
  }

  void _playSelectedCard(domain.Card card, domain.CardColor? chosenColor,
      GameProvider gameProvider) {
    final humanPlayer = gameProvider.game?.players
        .firstWhere((p) => p.type == PlayerType.human);

    if (humanPlayer == null) return;

    // Create play animation
    final RenderBox tableBox = context.findRenderObject() as RenderBox;
    final tablePosition = tableBox.localToGlobal(Offset.zero);
    final tableCenter = tablePosition +
        Offset(tableBox.size.width / 2, tableBox.size.height / 2);

    // Starting position (estimate from player's hand)
    final startPosition = Offset(
      tableCenter.dx,
      tableBox.size.height - 80,
    );

    // End position (center of the table)
    final endPosition = Offset(
      tableCenter.dx - 40, // Center of card
      tableCenter.dy - 60, // Center of card
    );

    setState(() {
      _animatedCards.add(
        AnimatedCardWidget(
          card: card,
          startPosition: startPosition,
          endPosition: endPosition,
          startScale: 1.0,
          endScale: 1.0,
          onComplete: () {
            // Remove the animation after completion
            setState(() {
              _animatedCards.removeWhere(
                  (widget) => (widget as AnimatedCardWidget).card == card);

              // Actually play the card in the game
              gameProvider.playCard(humanPlayer, card,
                  chosenColor: chosenColor);

              _isPlaying = false;
              _selectedCard = null;
              _selectedWildColor = null;
            });
          },
        ),
      );
    });
  }

  void _drawCard(GameProvider gameProvider) {
    if (_isDrawing) return;

    setState(() {
      _isDrawing = true;
    });

    final humanPlayer = gameProvider.game?.players
        .firstWhere((p) => p.type == PlayerType.human);

    if (humanPlayer == null) return;

    // Create draw animation
    final RenderBox tableBox = context.findRenderObject() as RenderBox;
    final tablePosition = tableBox.localToGlobal(Offset.zero);
    final tableCenter = tablePosition +
        Offset(tableBox.size.width / 2, tableBox.size.height / 2);

    // Starting position (draw pile location)
    final startPosition = Offset(
      tableCenter.dx + 60, // Right of center
      tableCenter.dy - 60, // Middle of table
    );

    // End position (player's hand)
    final endPosition = Offset(
      tableCenter.dx,
      tableBox.size.height - 80,
    );

    // Start the card face down, then it will be added to the player's hand
    setState(() {
      _animatedCards.add(
        AnimatedCardWidget(
          card: const domain.Card(
              color: domain.CardColor.red,
              type: domain.CardType.number,
              value: 0), // Placeholder
          startPosition: startPosition,
          endPosition: endPosition,
          startScale: 1.0,
          endScale: 1.0,
          faceDown: true,
          onComplete: () {
            // Remove the animation after completion
            setState(() {
              _animatedCards.removeLast();

              // Actually draw the card in the game
              gameProvider.drawCard(humanPlayer);

              _isDrawing = false;
            });
          },
        ),
      );
    });
  }

  void _callUno(GameProvider gameProvider) {
    final humanPlayer = gameProvider.game?.players
        .firstWhere((p) => p.type == PlayerType.human);

    if (humanPlayer == null) return;

    gameProvider.callUno(humanPlayer);
  }

  void _catchUno(Player target, GameProvider gameProvider) {
    final humanPlayer = gameProvider.game?.players
        .firstWhere((p) => p.type == PlayerType.human);

    if (humanPlayer == null) return;

    gameProvider.catchUno(humanPlayer, target);
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final game = gameProvider.game;

    if (game == null) {
      return const Center(
        child: Text('Game not initialized'),
      );
    }

    final humanPlayer = game.players.firstWhere(
      (p) => p.type == PlayerType.human,
      orElse: () => game.players.first,
    );

    final aiPlayers =
        game.players.where((p) => p.type != PlayerType.human).toList();

    return AnimatedBuilder(
      animation: _tableAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.shade800,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Game direction indicator
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    game.direction == Direction.clockwise
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              // Current player and color indicator
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: _getColorFromCardColor(game.currentColor),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Current: ${game.currentPlayer.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center table with cards
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Discard pile
                      CardWidget(
                        card: game.topCard,
                        scale: 1.2,
                      ),

                      const SizedBox(width: 40),

                      // Draw pile
                      GestureDetector(
                        onTap: () {
                          if (game.currentPlayer.id == humanPlayer.id &&
                              !_isDrawing &&
                              !_isPlaying) {
                            _drawCard(gameProvider);
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Transform.translate(
                              offset: const Offset(-2, -2),
                              child: CardWidget(
                                card: game
                                    .topCard, // Doesn't matter, it's face down
                                faceDown: true,
                                scale: 1.2,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, 0),
                              child: CardWidget(
                                card: game
                                    .topCard, // Doesn't matter, it's face down
                                faceDown: true,
                                scale: 1.2,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(2, 2),
                              child: CardWidget(
                                card: game
                                    .topCard, // Doesn't matter, it's face down
                                faceDown: true,
                                scale: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // AI players (positioned around the table)
              ..._positionAIPlayers(aiPlayers, game),

              // Human player hand (at the bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Column(
                  children: [
                    // UNO and action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // UNO button
                        ElevatedButton(
                          onPressed: () => _callUno(gameProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Call UNO!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Catch UNO button
                        ElevatedButton(
                          onPressed: () {
                            // Show a dialog to select the player to catch
                            final unoPlayers = game.players
                                .where((p) =>
                                    p.id != humanPlayer.id &&
                                    p.hand.length == 1 &&
                                    !p.calledUno)
                                .toList();

                            if (unoPlayers.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No players to catch!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Catch UNO'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: unoPlayers
                                      .map((player) => ListTile(
                                            title: Text(player.name),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _catchUno(player, gameProvider);
                                            },
                                          ))
                                      .toList(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Catch UNO!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Player hand
                    PlayerHandWidget(
                      player: humanPlayer,
                      isCurrentPlayer: game.currentPlayer.id == humanPlayer.id,
                      isHuman: true,
                      topCard: game.topCard,
                      currentColor: game.currentColor,
                      maxWidth: MediaQuery.of(context).size.width - 40,
                      onCardSelected: (card) {
                        if (game.currentPlayer.id == humanPlayer.id) {
                          _playCard(card, gameProvider);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Color picker for wild cards
              if (_isColorPickerVisible && _selectedCard != null)
                Positioned.fill(
                  child: ColorPickerWidget(
                    onColorSelected: (color) {
                      setState(() {
                        _selectedWildColor = color;
                        _isColorPickerVisible = false;
                      });

                      // Play the wild card with the selected color
                      _playSelectedCard(_selectedCard!, color, gameProvider);
                    },
                  ),
                ),

              // Animated cards (for card movement animations)
              ..._animatedCards,

              // Game status messages
              if (gameProvider.gameStatus.isNotEmpty)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        gameProvider.gameStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
  }

  List<Widget> _positionAIPlayers(List<Player> aiPlayers, Game game) {
    final widgets = <Widget>[];
    final int totalPlayers = aiPlayers.length;

    if (totalPlayers == 0) return widgets;

    // Position AI players based on their count
    switch (totalPlayers) {
      case 1:
        // One AI player at the top
        widgets.add(
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: PlayerHandWidget(
              player: aiPlayers[0],
              isCurrentPlayer: game.currentPlayer.id == aiPlayers[0].id,
              isHuman: false,
              maxWidth: MediaQuery.of(context).size.width - 40,
            ),
          ),
        );
        break;

      case 2:
        // Two AI players: left and right
        widgets.add(
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: RotatedBox(
              quarterTurns: 1,
              child: PlayerHandWidget(
                player: aiPlayers[0],
                isCurrentPlayer: game.currentPlayer.id == aiPlayers[0].id,
                isHuman: false,
                maxWidth: MediaQuery.of(context).size.height - 40,
              ),
            ),
          ),
        );

        widgets.add(
          Positioned(
            top: 20,
            right: 20,
            bottom: 20,
            child: RotatedBox(
              quarterTurns: 3,
              child: PlayerHandWidget(
                player: aiPlayers[1],
                isCurrentPlayer: game.currentPlayer.id == aiPlayers[1].id,
                isHuman: false,
                maxWidth: MediaQuery.of(context).size.height - 40,
              ),
            ),
          ),
        );
        break;

      case 3:
        // Three AI players: top, left, right
        widgets.add(
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: PlayerHandWidget(
              player: aiPlayers[0],
              isCurrentPlayer: game.currentPlayer.id == aiPlayers[0].id,
              isHuman: false,
              maxWidth: MediaQuery.of(context).size.width - 40,
            ),
          ),
        );

        widgets.add(
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: RotatedBox(
              quarterTurns: 1,
              child: PlayerHandWidget(
                player: aiPlayers[1],
                isCurrentPlayer: game.currentPlayer.id == aiPlayers[1].id,
                isHuman: false,
                maxWidth: MediaQuery.of(context).size.height - 40,
              ),
            ),
          ),
        );

        widgets.add(
          Positioned(
            top: 20,
            right: 20,
            bottom: 20,
            child: RotatedBox(
              quarterTurns: 3,
              child: PlayerHandWidget(
                player: aiPlayers[2],
                isCurrentPlayer: game.currentPlayer.id == aiPlayers[2].id,
                isHuman: false,
                maxWidth: MediaQuery.of(context).size.height - 40,
              ),
            ),
          ),
        );
        break;

      default:
        // For more players, distribute them evenly around the top
        final double angleStep = math.pi / (totalPlayers + 1);

        for (int i = 0; i < totalPlayers; i++) {
          final double angle = math.pi / 2 + angleStep * (i + 1);
          final double radius = MediaQuery.of(context).size.width * 0.4;

          final double x = radius * math.cos(angle);
          final double y = radius * math.sin(angle);

          widgets.add(
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - y - 60,
              left: MediaQuery.of(context).size.width / 2 + x - 150,
              child: Transform.rotate(
                angle: angle + math.pi,
                child: PlayerHandWidget(
                  player: aiPlayers[i],
                  isCurrentPlayer: game.currentPlayer.id == aiPlayers[i].id,
                  isHuman: false,
                  maxWidth: 300,
                ),
              ),
            ),
          );
        }
        break;
    }

    return widgets;
  }

  Color _getColorFromCardColor(domain.CardColor color) {
    switch (color) {
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
}
