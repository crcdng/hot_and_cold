import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'floor.dart';

class HotAndColdGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late final Image spriteImage;

  late final floor = Floor();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    spriteImage = await Flame.images.load('spritesheet_complete.png');

    add(floor);
  }
}
