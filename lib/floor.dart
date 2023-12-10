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

class NeutralSprite extends Sprite {
  NeutralSprite(super.image,
      {required Vector2 super.srcPosition, required Vector2 super.srcSize});
}

class Floor extends PositionComponent with HasGameReference<HotAndColdGame> {
  Floor() : super();

  @override
  bool get debugMode => false;

  static final Vector2 tileSize = Vector2(64, 64);
  final Queue<SpriteComponent> floorTiles = Queue();
  List<SpriteComponent> floor = [];

  late final _coldSprite = ColdSprite(
    game.spriteSheet,
    srcPosition: Vector2(390, 390),
    srcSize: tileSize,
  );

  late final _hotSprite = HotSprite(
    game.spriteSheet,
    srcPosition: Vector2(195, 492),
    srcSize: tileSize,
  );

  late final _neutralSprite = NeutralSprite(
    game.spriteSheet,
    srcPosition: Vector2(520, 309),
    srcSize: tileSize,
  );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final tilesX = size.x ~/ tileSize.x + 1;
    floor.removeWhere((element) => true);
    print("start called");
    floorTiles.clear();
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
      floorTiles.removeFirst();
      //  floorTiles.remove(firstTile);
      // if (firstTile.sprite.runtimeType != NeutralSprite) {
      //   floorTiles.add(firstTile);
      // }

      floorTiles.add(firstTile);
    }
  }

  List<SpriteComponent> _generateFloor(int tilesX) {
    return List.generate(
        tilesX,
        (index) => SpriteComponent(
              sprite: generateSprite(index),
              size: tileSize,
            )
              ..add(RectangleHitbox()..renderShape = false)
              ..x = tileSize.x * index);
  }

  Sprite generateSprite(i) {
    if (i < 10) {
      return _neutralSprite;
    }
    switch (Random().nextInt(10)) {
      case >= 0 && < 2:
        return _neutralSprite;
      case >= 2 && < 6:
        return _coldSprite;
      case >= 6 && < 10:
        return _hotSprite;
      default:
        return _neutralSprite;
    }
  }
}
