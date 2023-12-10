import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_and_cold/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GameWidget(game: HotAndColdGame()),
  );
}
