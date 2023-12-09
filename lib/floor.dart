import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'game.dart';

class Floor extends PositionComponent with HasGameReference<HotAndColdGame> {
  Floor() : super();

  @override
  bool get debugMode => true;

  static final Vector2 tileSize = Vector2(64, 64);
  final Queue<SpriteComponent> floorTiles = Queue();

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
      print("new tile needed");
      var newTile = SpriteComponent(
        sprite: Random().nextBool() ? _hotSprite : _coldSprite,
        size: tileSize,
      )..x = floorTiles.last.x + floorTiles.last.width;
      floorTiles.remove(firstTile);
      floorTiles.add(newTile);
    }
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
