import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flamewartable/bloc/toolmenu/tool_menu_bloc.dart';
import 'package:flutter/material.dart';

import '../game/game.dart';

class GamePieceComponent extends SpriteComponent with TapCallbacks, DragCallbacks, CollisionCallbacks, HasGameReference<WartableGame> {
  GamePieceComponent({required this.spriteImage, required this.toolMenuBloc, required this.gamePieceBloc})
      : super(size: Vector2.all(30), anchor: Anchor.center); //String owner, double size)

  final String spriteImage;
  final ToolMenuBloc toolMenuBloc;
  final GamePieceBloc gamePieceBloc;

  bool _isdragging = false;
  bool _selected = false;

  List<GamePieceComponent> collisions = [];
  late ShapeHitbox hitbox;
  late RectangleComponent border;
  final _collisionColor = Colors.red;
  final _selectedColor = Colors.green;
  final _defaultColor = Colors.transparent;

  String toolSelected = '';

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite(spriteImage);

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill;

    hitbox = CircleHitbox(
      radius: (width / 2) - (width * 0.024),
      anchor: Anchor.center,
      position: Vector2(width / 2, width / 2),
    )
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);
    add(TextComponent(
        text: width.toString(),
        anchor: Anchor.center,
        position: Vector2(width / 2, height / 2),
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 20, color: Colors.white),
        )));
    final Paint tokenborder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = _defaultColor;

    border = RectangleComponent.square(
      anchor: Anchor.center,
      size: width,
      position: Vector2(width / 2, width / 2),
      paint: tokenborder,
    );

    add(border);

    add(FlameMultiBlocProvider(
      providers: [
        FlameBlocProvider<ToolMenuBloc, String>.value(value: toolMenuBloc),
        FlameBlocProvider<GamePieceBloc, GamePieceState>.value(value: gamePieceBloc),
      ],
      children: [
        FlameBlocListener<ToolMenuBloc, String>(
          onNewState: (state) => toolSelected = state,
          onInitialState: (state) => toolSelected = state,
        ),
        FlameBlocListener<GamePieceBloc, GamePieceState>(onNewState: (state) {
          var index = state.tokens.indexWhere(
            (element) => element.spriteComponent == this,
          );
          if (index != -1) {
            setSelected(state.tokens[index].selected);
          }
        }),
      ],
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragged ? Colors.green : Colors.purple;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 100;
    _isdragging = true;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isdragging = false;
    priority = 1;
    super.onDragEnd(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_isdragging) {
      return;
    }
    position += event.localDelta;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is GamePieceComponent) {
      collisions.add(other);
      hitbox.paint.color = _collisionColor;
      if (_selected) {
        hitbox.paint.color = _selectedColor;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is GamePieceComponent) {
      collisions.remove(other);
    }
    if (collisions.isEmpty) {
      hitbox.paint.color = _defaultColor;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (toolSelected == 'select') {
      gamePieceBloc.add(GamePieceSelected(piece: this, selected: !_selected));
    }
    super.onTapUp(event);
  }

  void cancelSelect() {
    setSelected(false);
    if (collisions.isEmpty) {
      hitbox.paint.color = _defaultColor;
    } else {
      hitbox.paint.color = _collisionColor;
    }
  }

  void setSelected(bool value) {
    _selected = value;
    border.setColor(_selected ? Colors.black : _defaultColor);
    if (collisions.isEmpty) {
      hitbox.paint.color = _defaultColor;
    } else {
      hitbox.paint.color = _collisionColor;
    }
  }
}
