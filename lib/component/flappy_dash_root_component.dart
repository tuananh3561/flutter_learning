import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_dash/bloc/game/game_cubit.dart';
import 'package:flappy_dash/component/dash.dart';
import 'package:flappy_dash/component/dash_parallax_background.dart';
import 'package:flappy_dash/component/pipe_pair.dart';
import 'package:flappy_dash/flappy_dash_game.dart';

class FlappyDashRootComponent extends Component
    with HasGameRef<FlappyDashGame>, FlameBlocReader<GameCubit, GameState> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const double _pipesDistance = 400.0;
  late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(DashBackground());
    add(_dash = Dash());
    _generatePipe(
      fromX: 350.0,
    );
    game.camera.viewfinder.add(
      _scoreText = TextComponent(
        text: bloc.state.currentScore.toString(),
        position: Vector2(0, -(game.size.y / 2)),
      ),
    );
  }

  void _generatePipe({
    int count = 5,
    double fromX = 0.0,
  }) {
    for (var i = 0; i < count; i++) {
      const area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe =
          PipePair(position: Vector2(fromX + (i * _pipesDistance), y)));
    }
  }

  void _removePipe() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() {
    _checkToStart();
    _dash.jump();
  }

  void onTapDown(TapDownEvent event) {
    _checkToStart();
    _dash.jump();
  }

  void _checkToStart() {
    if (bloc.state.currentPlayingState == PlayingState.none) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = bloc.state.currentScore.toString();
    if (_dash.x > _lastPipe.x) {
      _generatePipe(
        fromX: _pipesDistance,
      );
      _removePipe();
    }
    game.camera.viewfinder.zoom = 1;
  }
}
