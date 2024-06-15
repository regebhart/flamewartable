import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flamewartable/bloc/toolmenu/tool_menu_bloc.dart';
import 'package:flutter/material.dart';

import '../game/game.dart';

class GamePieceComponent extends SpriteComponent with TapCallbacks, DragCallbacks, CollisionCallbacks, HasGameReference<WartableGame> {
  @override
  bool debugMode = false;
  GamePieceComponent({required this.spriteImage, required this.toolMenuBloc, required this.gamePieceBloc})
      : super(size: Vector2.all(30), anchor: Anchor.center); //String owner, double size)

  final String spriteImage;
  final ToolMenuBloc toolMenuBloc;
  final GamePieceBloc gamePieceBloc;

  bool _isdragging = false;
  bool _selected = false;

  List<GamePieceComponent> collisions = [];
  late ShapeHitbox hitbox;
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
      radius: 29.9,
      anchor: Anchor.center,
      position: Vector2(30, 30),
    )
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);

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
    print('dragging piece true');
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isdragging = false;
    // priority = 1;
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
      _selected = !_selected;
      hitbox.paint.color = _selected
          ? _selectedColor
          : collisions.isEmpty
              ? _defaultColor
              : _collisionColor;
    }
    print('gamepiece tapped');
    super.onTapUp(event);
  }

  void cancelSelect() {
    _selected = false;
    if (collisions.isEmpty) {
      hitbox.paint.color = _defaultColor;
    } else {
      hitbox.paint.color = _collisionColor;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
