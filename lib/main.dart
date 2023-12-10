import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_and_cold/game.dart';

import 'menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GameWidget(
      game: HotAndColdGame(),
      overlayBuilderMap: {
        'Menu': (context, game) {
          return const MenuOverlay();
        },
      },
    ),
  );
}
