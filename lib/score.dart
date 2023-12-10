import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';

import 'game.dart';

class ScoreDisplay extends TextComponent with HasGameReference<HotAndColdGame> {
  var _score = 0;
  var _highScore = 0;

  int get score => _score;
  set score(int newScore) {
    _score = newScore;
    text = '${scoreString(_score)} \nHI ${scoreString(_highScore)}';
  }

  set highScore(int newScore) {
    _highScore = newScore;
    text =
        'SCORE ${scoreString(_score)} \nHIGHSCORE ${scoreString(_highScore)}';
  }

  String scoreString(int score) => score.toString().padLeft(8, '0');

  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: const TextStyle(
        fontFamily: 'Kenney-Blocks',
        fontSize: 28,
        color: Color.fromRGBO(140, 140, 140, 1),
      ),
    );
    position = Vector2(20, 20);
    score = 0;
    return super.onLoad();
  }
}
