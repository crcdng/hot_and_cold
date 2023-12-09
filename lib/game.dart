import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'floor.dart';
import 'player.dart';

enum GameState { intro, playing, gameOver }

class HotAndColdGame extends FlameGame
    with TapCallbacks, DoubleTapCallbacks, HasCollisionDetection {
  final double startSpeed = 10;
  GameState state = GameState.intro;
  double speed = 0.0;

  late final Image spriteImage;
  late final floor = Floor();
  late final player = Player();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    spriteImage = await Flame.images.load('spritesheet_complete.png');

    add(floor);
    add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (state != GameState.playing) {
      start();
      return;
    }
    player.jump(speed);
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    super.onDoubleTapDown(event);
    if (state != GameState.playing) {
      return;
    }
    player.switchTemperature(speed);
  }

  void start() {
    state = GameState.playing;
    speed = startSpeed;
  }
}
