import 'dart:math';

import 'package:flame/components.dart';
import 'game.dart';

class Floor extends PositionComponent with HasGameReference<HotAndColdGame> {
  Floor() : super();

  static final Vector2 tileSize = Vector2(64, 64);

  late final _coldSprite = Sprite(
    game.spriteImage,
    srcPosition: Vector2(390, 390),
    srcSize: tileSize,
  );

  late final _hotSprite = Sprite(
    game.spriteImage,
    srcPosition: Vector2(195, 492),
    srcSize: tileSize,
  );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final tilesX = size.x ~/ tileSize.x + 1;
    final floor = _generateFloor(tilesX);
    y = (size.y / 2);
    addAll(floor);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  List<SpriteComponent> _generateFloor(int tilesX) {
    return List.generate(
        tilesX,
        (index) => SpriteComponent(
              sprite: Random().nextBool() ? _hotSprite : _coldSprite,
              size: tileSize,
            )..x = tileSize.x * index);
  }
}
