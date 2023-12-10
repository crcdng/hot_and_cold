import 'package:flame/components.dart';

import 'game.dart';

class Button extends SpriteComponent with HasGameReference<HotAndColdGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('flatLight24.png');
    size = Vector2.all(48.0);
    return (super.onLoad());
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    anchor = Anchor.center;
    x = size.x / 2;
    y = size.y * 5 / 6;
  }
}
