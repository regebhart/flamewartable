import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flamewartable/bloc/toolmenu/tool_menu_bloc.dart';
import 'package:flamewartable/components/border.dart';
import 'package:flamewartable/src/config.dart';
import 'package:flutter/material.dart';

class GamePieceBody extends BodyComponent with TapCallbacks, DragCallbacks, CollisionCallbacks {
  GamePieceBody({
    required this.diameter,
    required this.spriteImage,
    required this.toolMenuBloc,
    required this.gamePieceBloc,
  }) : super(
            renderBody: false,
            bodyDef: BodyDef()
              ..position = Vector2(60, 60)
              ..type = BodyType.dynamic,
            fixtureDefs: [
              FixtureDef(CircleShape()..radius = diameter / 2)
                ..restitution = 1
                ..density = 0
                ..friction = 0
            ]); //String owner, double size)

  // @override
  // bool debugMode = true;

  final double diameter;
  final String spriteImage;
  final ToolMenuBloc toolMenuBloc;
  final GamePieceBloc gamePieceBloc;

  bool _isdragging = false;
  bool _selected = false;

  late RectangleComponent border;
  late SpriteComponent _spriteComponent;
  late Vector2 velocity;

  MouseJoint? mouseJoint;

  String toolSelected = '';

  @override
  Future<void> onLoad() async {
    velocity = Vector2.zero();

    var sprite = await game.loadSprite(spriteImage);
    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      sprite: sprite,
      size: Vector2(diameter, diameter),
      position: Vector2(0, 0),
    );
    add(_spriteComponent);

    add(TextComponent(
        text: diameter.toString(),
        anchor: Anchor.center,
        position: Vector2(0, 0),
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 20, color: Colors.white),
        )));

    final Paint tokenborder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.transparent;

    border = RectangleComponent.square(
      anchor: Anchor.center,
      size: diameter,
      position: Vector2(0, 0),
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
            (element) => element.bodyComponent == this,
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
    body.applyLinearImpulse(event.deviceDelta * 7500);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (toolSelected == 'select') {
      gamePieceBloc.add(GamePieceSelected(piece: this, selected: !_selected));
    }
    super.onTapUp(event);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BorderBody) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= gameWidth) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= gameHeight) {
        velocity.y = -velocity.y;
      }
      velocity.add(Vector2.all(50000));
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void cancelSelect() {
    // setSelected(false);
    // if (collisions.isEmpty) {
    //   hitbox.paint.color = _defaultColor;
    // } else {
    //   // hitbox.paint.color = _collisionColor;
    // }
  }

  void setSelected(bool value) {
    _selected = value;
    border.setColor(_selected ? Colors.black : Colors.transparent);
    // if (collisions.isEmpty) {
    //   hitbox.paint.color = _defaultColor;
    // } else {
    //   // hitbox.paint.color = _collisionColor;
    // }
  }
}
