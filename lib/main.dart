import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_and_cold/game.dart';

import 'menu.dart';

void main() {
  final game = HotAndColdGame();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'Menu': (context, HotAndColdGame game) {
          return MenuOverlay(game);
        },
      },
    ),
  );
}
