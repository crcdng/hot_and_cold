import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';

enum PlayerState { idle, running, jumping, switching, dead }

enum PlayerTemperature { hot, cold }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<HotAndColdGame>, CollisionCallbacks {
  late PlayerTemperature playerTemperature;

  @override
  bool get debugMode => true;

  Player() : super(size: Vector2(39, 48)) {
    playerTemperature =
        Random().nextBool() ? PlayerTemperature.hot : PlayerTemperature.cold;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    animations = _getAnimations;
    current = PlayerState.idle;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = size.x / 2;
  }

  void start() {
    current = PlayerState.running;
  }

  void jump(double speed) {
    current = PlayerState.jumping;
    print("jump");
  }

  void switchTemperature(double speed) {
    current = PlayerState.switching;
    playerTemperature = switch (playerTemperature) {
      PlayerTemperature.hot => PlayerTemperature.cold,
      PlayerTemperature.cold => PlayerTemperature.hot,
    };
    animations = _getAnimations;
    print("switch to $playerTemperature");
  }

  Map<PlayerState, SpriteAnimation> get _getAnimations {
    return {
      PlayerState.idle: _getAnimation(
        framesHot: [(Vector2(39.0, 48.0), Vector2(850.0, 518.0))],
        framesCold: [(Vector2(45.0, 54.0), Vector2(762.0, 203.0))],
      ),
      PlayerState.running: _getAnimation(
        framesHot: [
          //  (Vector2(39.0, 48.0), Vector2(850.0, 47.0)),
          // (Vector2(39.0, 45.0), Vector2(850.0, 96.0)),
          // (Vector2(39.0, 45.0), Vector2(849.0, 251.0)),
          (Vector2(49.0, 42.0), Vector2(710.0, 384.0)),
          // (Vector2(64.0, 38.0), Vector2(130.0, 975.0))
        ],
        framesCold: [
          (Vector2(45.0, 54.0), Vector2(759.0, 812.0)),
          (Vector2(45.0, 54.0), Vector2(760.0, 380.0)),
          (Vector2(45.0, 52.0), Vector2(759.0, 503.0)),
          (Vector2(49.0, 45.0), Vector2(713.0, 157.0)),
          (Vector2(64.0, 40.0), Vector2(585.0, 779.0))
        ],
        stepTime: 0.2,
      ),
      PlayerState.jumping: _getAnimation(
        framesHot: [
          (Vector2(39.0, 48.0), Vector2(850.0, 469.0)),
          (Vector2(39.0, 46.0), Vector2(850.0, 0.0)),
          (Vector2(56.0, 38.0), Vector2(650.0, 685.0))
        ],
        framesCold: [
          (Vector2(45.0, 54.0), Vector2(760.0, 435.0)),
          (Vector2(45.0, 50.0), Vector2(759.0, 556.0)),
          (Vector2(46.0, 40.0), Vector2(758.0, 771.0))
        ],
        stepTime: 0.2,
      ),
      PlayerState.dead: _getAnimation(
        framesHot: [(Vector2(39.0, 46.0), Vector2(850.0, 297.0))],
        framesCold: [(Vector2(45.0, 47.0), Vector2(762.0, 258.0))],
      ),
    };
  }

  SpriteAnimation _getAnimation({
    required List<(Vector2, Vector2)> framesHot,
    required List<(Vector2, Vector2)> framesCold,
    double stepTime = double.infinity,
  }) {
    return SpriteAnimation.spriteList(
      (playerTemperature == PlayerTemperature.hot ? framesHot : framesCold)
          .map(
            (frame) => Sprite(
              game.spriteImage,
              srcSize: frame.$1, // size
              srcPosition: frame.$2, // position in the spritesheet
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
