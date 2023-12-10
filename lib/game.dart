import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'floor.dart';
import 'player.dart';
import 'score.dart';

enum GameState { intro, playing, gameOver }

class HotAndColdGame extends FlameGame
    with TapCallbacks, DoubleTapCallbacks, HasCollisionDetection {
  final double startSpeed = 130;
  double speed = 0.0;
  double _distance = 0.0;
  int score = 0;
  int highScore = 0;

  final floor = Floor();
  final player = Player();
  final scoreDisplay = ScoreDisplay();

  late final Image spriteSheet;

  GameState state = GameState.intro;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    spriteSheet = await Flame.images.load('spritesheet_complete.png');

    add(floor);
    add(player);
    add(scoreDisplay);
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

  @override
  void update(double dt) {
    super.update(dt);
    _distance += dt * speed;
    score = _distance ~/ 10;
    scoreDisplay.score = score;
  }

  void start() {
    state = GameState.playing;
    speed = startSpeed;
    score = 0;
    scoreDisplay.score = score;
  }

  void gameOver() {
    state = GameState.gameOver;
    if (score > highScore) {
      highScore = score;
      scoreDisplay.highScore = highScore;
    }
    // gameOverPanel.visible = true;
    player.current = PlayerState.dead;
    speed = 0.0;
  }
}
