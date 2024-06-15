import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/gamepiece/gamepiece_bloc.dart';
import '../bloc/toolmenu/tool_menu_bloc.dart';
import '../components/table.dart';

class WartableGame extends FlameGame with ScrollDetector, ScaleDetector, PanDetector, DragCallbacks, HasCollisionDetection {
  WartableGame({required this.toolMenuBloc, required this.gamePieceBloc})
      : super(camera: CameraComponent.withFixedResolution(width: 1000, height: 1000));

  final ToolMenuBloc toolMenuBloc;
  final GamePieceBloc gamePieceBloc;

  String toolSelected = 'pan';

  Vector2 cameraPosition = Vector2.zero();

  @override
  Color backgroundColor() => Colors.grey.shade700;

  @override
  Future<void> onLoad() async {
    world.add(GameTable());
    camera.viewfinder.position = Vector2(0, 0);
    camera.viewfinder.anchor = Anchor.center;

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
      default:
        break;
    }
    super.onDragUpdate(event);
  }
}
