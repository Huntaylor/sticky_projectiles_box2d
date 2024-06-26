import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sticky_projectiles_box2d/main.dart';

class OutlineComponent extends PositionComponent {
  OutlineComponent({
    super.angle,
    super.position,
    super.priority,
    super.scale,
  }) : super();
}

class CirclePolygon extends BodyComponent<StickyProjectilesGame> {
  CirclePolygon(
    this._position,
    PositionComponent component,
  ) : size = component.size {
    renderBody = true;
    add(component
      ..anchor = Anchor.topLeft
      ..size = Vector2.all(150));
  }
  final Paint _blue = BasicPalette.blue.paint();
  final Vector2 _position;
  final Vector2 size;
  final _upVector = Vector2(0, -1);

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    super.renderCircle(canvas, center, radius);
    final lineRotation = Offset(0, radius);
    canvas.drawLine(center, center + lineRotation, _blue);
  }

  @override
  void update(double dt) {
    // if (isMounted) {
    //   _getAngle();
    // }
    super.update(dt);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 4;
    final fixtureDef = FixtureDef(
      shape,
      userData: this,
    );

    final velocity = (Vector2.random() - Vector2.random()) * 200;
    final bodyDef = BodyDef(
      gravityOverride: Vector2.all(0),
      position: _position,
      angle: velocity.angleTo(Vector2(1, 0)),
      type: BodyType.dynamic,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void _getAngle() {
    // DevKage used this calculation in one of his games, how does it work?
    final dir = game.mousePosition - position;

    bodyDef!.angle =
        (-dir.angleToSigned(_upVector)) * bodyDef!.position.x.sign - (pi * 0.5);
  }
}
