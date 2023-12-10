import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'floor.dart';
import 'game.dart';

enum PlayerState { idle, running, jumping, dead }

enum PlayerTemperature { hot, cold }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<HotAndColdGame>, CollisionCallbacks {
  late PlayerTemperature playerTemperature;

  final double gravity = 1;
  final double initialJumpVelocity = -20.0;
  double _jumpVelocity = 0.0;

  @override
  bool get debugMode => false;

  Player() : super(size: Vector2(39, 48)) {
    playerTemperature =
        Random().nextBool() ? PlayerTemperature.hot : PlayerTemperature.cold;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox()..renderShape = false);
    animations = _getAnimations;
    current = PlayerState.idle;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = size.x / 3;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > groundY) {
        land();
      }
    } else {
      y = groundY;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      //...
    } else if (other is SpriteComponent) {
      final otherTemperature = other.sprite.runtimeType;
      if ((playerTemperature == PlayerTemperature.hot &&
              otherTemperature == ColdSprite) ||
          (playerTemperature == PlayerTemperature.cold &&
              otherTemperature == HotSprite)) {
        die();
      }
    }
  }

  void start() {
    current = PlayerState.running;
  }

  double get groundY {
    return (game.size.y / 2) - height / 2 + 10;
  }

  void jump(double speed) {
    if (current == PlayerState.jumping) {
      return;
    }
    current = PlayerState.jumping;
    _jumpVelocity = initialJumpVelocity - (speed / 500);
    print("jump");
  }

  void land() {
    y = groundY;
    _jumpVelocity = 0.0;
    current = PlayerState.running;
  }

  void switchTemperature(double speed) {
    playerTemperature = switch (playerTemperature) {
      PlayerTemperature.hot => PlayerTemperature.cold,
      PlayerTemperature.cold => PlayerTemperature.hot,
    };
    animations = _getAnimations;
    print("switch to $playerTemperature");
  }

  void die() {
    print("dead");
  }

  Map<PlayerState, SpriteAnimation> get _getAnimations {
    return {
      PlayerState.idle: _getAnimation(
        framesHot: [(Vector2(39.0, 48.0), Vector2(850.0, 518.0))],
        framesCold: [(Vector2(45.0, 54.0), Vector2(762.0, 203.0))],
      ),
      PlayerState.running: _getAnimation(
        framesHot: [
          (Vector2(39.0, 48.0), Vector2(850.0, 47.0)),
          (Vector2(39.0, 45.0), Vector2(850.0, 96.0)),
          (Vector2(39.0, 45.0), Vector2(849.0, 251.0)),
          (Vector2(49.0, 42.0), Vector2(710.0, 384.0)),
          (Vector2(64.0, 38.0), Vector2(130.0, 975.0))
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
              game.spriteSheet,
              srcSize: frame.$1, // size
              srcPosition: frame.$2, // position in the spritesheet
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
