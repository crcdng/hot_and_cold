import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart' hide PlayerState;

import 'button.dart';
import 'floor.dart';
import 'player.dart';
import 'score.dart';

enum GameState { intro, playing, gameOver }

class HotAndColdGame extends FlameGame
    with TapCallbacks, DoubleTapCallbacks, HasCollisionDetection {
  final double startSpeed = 130;
  final double maxSpeed = 390;
  double speed = 0.0;
  double _distance = 0.0;
  int score = 0;
  int highScore = 0;

  final floor = Floor();
  final player = Player();
  final scoreDisplay = ScoreDisplay();
  final button = Button();

  final menuOverlayIdentifier = 'Menu';

  late final Image spriteSheet;

  GameState state = GameState.intro;

  @override
  Future<void> onLoad() async {
    spriteSheet = await Flame.images.load('spritesheet_complete.png');
    await FlameAudio.audioCache
        .loadAll(['highUp.mp3', 'phaseJump1.mp3', 'lowDown.mp3']);

    add(floor);
    add(player);
    add(scoreDisplay);
    add(button);
    overlays.add(menuOverlayIdentifier);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (state != GameState.playing) {
      start();
      return;
    }
    player.jump(speed);
    FlameAudio.play('phaseJump1.mp3');
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    super.onDoubleTapDown(event);
    if (state != GameState.playing) {
      return;
    }
    player.switchTemperature(speed);
    FlameAudio.play('highUp.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != GameState.playing) {
      return;
    }
    _distance += dt * speed;
    score = _distance ~/ 10;
    scoreDisplay.score = score;
    if (speed < maxSpeed) {
      speed += 0.01;
    }
  }

  void start() {
    state = GameState.playing;
    speed = startSpeed;
    score = 0;
    scoreDisplay.score = score;
    overlays.remove(menuOverlayIdentifier);
  }

  void gameOver() {
    state = GameState.gameOver;
    if (score > highScore) {
      highScore = score;
      scoreDisplay.highScore = highScore;
    }
    overlays.add(menuOverlayIdentifier);
    player.current = PlayerState.dead;
    speed = 0.0;
    FlameAudio.play('lowDown.mp3');
  }
}
