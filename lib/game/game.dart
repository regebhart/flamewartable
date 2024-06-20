import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/gamepiece/gamepiece_bloc.dart';
import '../bloc/toolmenu/tool_menu_bloc.dart';
import '../components/table.dart';

class WartableGame extends FlameGame with ScrollDetector, DragCallbacks {
  WartableGame({required this.toolMenuBloc, required this.gamePieceBloc});

  final ToolMenuBloc toolMenuBloc;
  final GamePieceBloc gamePieceBloc;

  @override
  bool debugMode = true;

  String toolSelected = 'select';

  Vector2 cameraPosition = Vector2.zero();
  late RectangleComponent selectBoxComponent;
  late Vector2 startpos;
  late Vector2 endpos;
  Vector2 compStartPos = Vector2.zero();
  Vector2 compEndPos = Vector2.zero();

  @override
  Color backgroundColor() => Colors.grey.shade700;

  @override
  Future<void> onLoad() async {
    add(FpsTextComponent());
    world.add(GameTable(gamePieceBloc: gamePieceBloc));
    camera.viewfinder.position = Vector2(0, 0);
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1;

    camera.setBounds(Rectangle.fromCenter(center: Vector2.zero(), size: Vector2.all(650)));

    await add(FlameMultiBlocProvider(
      providers: [
        FlameBlocProvider<ToolMenuBloc, String>.value(value: toolMenuBloc),
        FlameBlocProvider<GamePieceBloc, GamePieceState>.value(value: gamePieceBloc),
      ],
      children: [
        FlameBlocListener<ToolMenuBloc, String>(
          onNewState: (state) => toolSelected = state,
          onInitialState: (state) => toolSelected = state,
        ),
        FlameBlocListener<GamePieceBloc, GamePieceState>(
          onNewState: (state) async {
            world.add(state.tokens.last.spriteComponent);
          },
        ),
      ],
    ));
  }

  clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.5, 8);
  }

  static const zoomPerScrollUnit = 0.1;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom -= info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final delta = event.devicePosition;

    switch (toolSelected) {
      case 'select':
        final zoom = camera.viewfinder.zoom;
        final Vector2 cameraTopLeft =
            Vector2(camera.viewfinder.position.x - (camera.viewport.size.x / 2), camera.viewfinder.position.y - (camera.viewport.size.y / 2));
        startpos = (delta + cameraTopLeft) / zoom;
        endpos = startpos;
        selectBoxComponent = RectangleComponent.fromRect(
          Rect.fromLTWH(startpos.x, startpos.y, 0, 0),
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0
            ..color = Colors.black,
        );
        world.add(selectBoxComponent);
        break;
      default:
        break;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    switch (toolSelected) {
      case 'pan':
        //move the table around
        final delta = event.deviceDelta * 1.1;
        cameraPosition.add(-delta);
        camera.viewfinder.position = cameraPosition;
        break;
      case 'select':
        final zoom = camera.viewfinder.zoom;
        final Vector2 cameraTopLeft =
            Vector2(camera.viewfinder.position.x - (camera.viewport.size.x / 2), camera.viewfinder.position.y - (camera.viewport.size.y / 2));
        endpos = (event.localEndPosition + cameraTopLeft) / zoom;
        selectBoxComponent.x = startpos.x;
        selectBoxComponent.y = startpos.y;

        double width = endpos.x - startpos.x;
        double height = endpos.y - startpos.y;

        if (startpos.x > endpos.x) {
          selectBoxComponent.x = endpos.x;
          width = startpos.x - endpos.x;
        }
        if (startpos.y > endpos.y) {
          selectBoxComponent.y = endpos.y;
          height = startpos.y - endpos.y;
        }

        selectBoxComponent.width = width;
        selectBoxComponent.height = height;

        compStartPos.x = selectBoxComponent.x;
        compStartPos.y = selectBoxComponent.y;
        compEndPos.x = selectBoxComponent.x + selectBoxComponent.width;
        compEndPos.y = selectBoxComponent.y + selectBoxComponent.height;
      default:
        break;
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    switch (toolSelected) {
      case 'select':
        gamePieceBloc.add(SelectGamePiecesInArea(area: Rect.fromPoints(compStartPos.toOffset(), compEndPos.toOffset())));
        startpos = Vector2.zero();
        endpos = startpos;
        world.remove(selectBoxComponent);

      default:
        break;
    }
    super.onDragEnd(event);
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    final delta = (details.delta * 1.1).toVector2();
    cameraPosition.add(-delta);
    camera.viewfinder.position = cameraPosition;
  }

  void moveCamera(Vector2 delta) {
    delta = delta * 1.1;
    final cameraPosition = camera.viewfinder.position;
    final Vector2 gamesize = size / 2;
    cameraPosition.add(-delta);
    cameraPosition.clamp(gamesize * -1, gamesize);
    camera.viewfinder.position = cameraPosition;
  }
}
