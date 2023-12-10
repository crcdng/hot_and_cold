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
    text = 'SCORE ${scoreString(_score)} HIGHSCORE ${scoreString(_highScore)}';
  }

  set highScore(int newScore) {
    _highScore = newScore;
    text = 'SCORE ${scoreString(_score)} HIGHSCORE ${scoreString(_highScore)}';
  }

  String scoreString(int score) => score.toString().padLeft(5, '0');

  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 32,
        color: Color.fromRGBO(100, 10, 10, 1),
      ),
    );
    position = Vector2(20, 320);
    score = 0;
  }
}
