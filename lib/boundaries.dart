import 'package:flame_forge2d/flame_forge2d.dart';

List<Wall> createBoundaries(Forge2DGame game, {double? strokeWidth}) {
  final worldSize = game.size;
  final topLeft = Vector2.zero();
  final topRight = Vector2(worldSize.x, 0);
  final bottomRight = Vector2(worldSize.x, worldSize.y);
  final bottomLeft = Vector2(0, worldSize.y);

  return [
    Wall(topLeft, topRight, strokeWidth: strokeWidth)..debugMode = true,
    Wall(topRight, bottomRight, strokeWidth: strokeWidth)..debugMode = true,
    Wall(bottomLeft, bottomRight, strokeWidth: strokeWidth)..debugMode = true,
    Wall(topLeft, bottomLeft, strokeWidth: strokeWidth)..debugMode = true,
  ];
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final double strokeWidth;

  Wall(this.start, this.end, {double? strokeWidth})
      : strokeWidth = strokeWidth ?? 1;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: Vector2.zero(),
    );
    paint.strokeWidth = strokeWidth;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
