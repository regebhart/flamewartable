import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flamewartable/src/config.dart';

List<BorderBody> createBoundaries(Forge2DGame game) {
  final topLeft = Vector2(gameWidth * -0.5, gameHeight * -0.5);
  final topRight = Vector2(gameWidth / 2, gameHeight * -0.5);
  final bottomRight = Vector2(gameWidth / 2, gameHeight / 2);
  final bottomLeft = Vector2(gameWidth * -0.5, gameWidth / 2);

  return [
    BorderBody(topLeft, topRight),
    BorderBody(topRight, bottomRight),
    BorderBody(bottomRight, bottomLeft),
    BorderBody(bottomLeft, topLeft),
  ];
}

class BorderBody extends BodyComponent {
  BorderBody(this.start, this.end);

  final Vector2 start;
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this, position: Vector2.zero());

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
