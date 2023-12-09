import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';

enum PlayerState { running, jumping, waiting, dead }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<HotAndColdGame>, CollisionCallbacks {
  Player() : super(size: Vector2(39, 48)) {}

  void jump(double speed) {
    print("jump");
  }

  void switchTemperature(double speed) {
    print("switch");
  }
}
