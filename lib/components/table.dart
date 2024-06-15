import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../bloc/gamepiece/gamepiece_bloc.dart';
import '../game/game.dart';

class GameTable extends SpriteComponent with TapCallbacks, HasGameReference<WartableGame> {
  GameTable({required this.gamePieceBloc});

  final GamePieceBloc gamePieceBloc;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('landscape.png');
    size = Vector2(1500, 1500);
    anchor = Anchor.center;
    position = Vector2(0, 0);

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    gamePieceBloc.add(const ClearGamePieceSelections());
    super.onTapUp(event);
  }
}
