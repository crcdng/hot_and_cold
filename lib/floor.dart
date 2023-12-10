import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'game.dart';

class HotSprite extends Sprite {
  HotSprite(super.image,
      {required Vector2 super.srcPosition, required Vector2 super.srcSize});
}

class ColdSprite extends Sprite {
  ColdSprite(super.image,
      {required Vector2 super.srcPosition, required Vector2 super.srcSize});
}

class Floor extends PositionComponent with HasGameReference<HotAndColdGame> {
  Floor() : super();

  @override
  bool get debugMode => true;

  static final Vector2 tileSize = Vector2(64, 64);
  final Queue<SpriteComponent> floorTiles = Queue();
  List<SpriteComponent> floor = [];

  late final _coldSprite = ColdSprite(
    game.spriteImage,
    srcPosition: Vector2(390, 390),
    srcSize: tileSize,
  );

  late final _hotSprite = HotSprite(
    game.spriteImage,
    srcPosition: Vector2(195, 492),
    srcSize: tileSize,
  );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final tilesX = size.x ~/ tileSize.x + 1;
    floor = _generateFloor(tilesX);
    y = ((size.y + tileSize.y) / 2);
    addAll(floor);
    floorTiles.addAll(floor);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = game.speed * dt;
    for (final tile in floorTiles) {
      tile.x -= increment;
    }

    final firstTile = floorTiles.first;
    if (firstTile.x <= -firstTile.width) {
      // TODO does not work
      // var newTile = new SpriteComponent(
      //   sprite: Random().nextBool() ? _hotSprite : _coldSprite,
      //   size: tileSize,
      // );
      firstTile.x = floorTiles.last.x + floorTiles.last.width;
      floorTiles.remove(firstTile);
      floorTiles.add(firstTile);
    }
  }

  List<SpriteComponent> _generateFloor(int tilesX) {
    return List.generate(
        tilesX,
        (index) => SpriteComponent(
              sprite: Random().nextBool() ? _hotSprite : _coldSprite,
              size: tileSize,
            )
              ..add(RectangleHitbox()..renderShape = false)
              ..x = tileSize.x * index);
  }
}
