import 'dart:async';

import 'package:flame/components.dart';
import '../game/game.dart';

class GameTable extends SpriteComponent with HasGameReference<WartableGame> {
  GameTable();
  String toolSelected = '';

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('landscape.png');
    size = Vector2(1500, 1500);
    anchor = Anchor.center;
    position = Vector2(0, 0);

    return super.onLoad();
  }
}
