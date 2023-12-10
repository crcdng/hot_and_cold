import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'game.dart';

class MenuOverlay extends StatelessWidget {
  final HotAndColdGame game;

  const MenuOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // ignore: sized_box_for_whitespace
      child: GestureDetector(
        onTap: () => {
          if (game.state == GameState.gameOver)
            {html.window.location.reload()}
          else
            {game.start()}
        },
        child: Container(
          color: Colors.black45.withOpacity(0.5),
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.85,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                      text: 'Hot',
                      style: TextStyle(
                        fontFamily: 'Kenney-Blocks',
                        fontSize: 48,
                        color: Color.fromRGBO(240, 10, 10, 1),
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            fontFamily: 'Kenney-Blocks',
                            fontSize: 48,
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        TextSpan(
                          text: 'Cold',
                          style: TextStyle(
                            fontFamily: 'Kenney-Blocks',
                            fontSize: 48,
                            color: Color.fromRGBO(10, 10, 240, 1),
                          ),
                        )
                      ]),
                ),
                SizedBox(height: 8),
                Text(
                  'made by @crcdng for Flame Game Jam 3.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Kenney-Mini-Square',
                  ),
                ),
                SizedBox(height: 28),
                Text(
                  'Tap Button: jump\nDouble tap: switch temperature ',
                  style: TextStyle(
                    fontFamily: 'Kenney-Mini-Square',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 28),
                Text(
                  'Avoid Hot and Cold',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Kenney-Mini-Square',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
