import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sticky_projectiles_box2d/asset_parse.dart';
import 'package:sticky_projectiles_box2d/main.dart';

class PlayerArrow extends BodyComponent<StickyProjectilesGame> with AssetParse {
  PlayerArrow(
    this.initialPosition,
    this.angle, {
    Vector2? size,
    super.bodyDef,
    super.priority,
  }) : size = size ?? Vector2(44, 6);
  @override
  late double angle;
  late SpriteComponent? sprite;

  final Vector2 initialPosition;
  final Vector2 size;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    await super.onLoad();

    final spriteImage = await game.images.load('arrow.png');

    renderBody = false;

    final sprite = SpriteComponent.fromImage(
      spriteImage,
      size: size,
      anchor: Anchor.center,
    );

    add(
      sprite,
    );
  }

  @override
  Body createBody() {
    size.scale(0.3);
    final shape = PolygonShape();

    final vertices = [
      Vector2(-5.4, 0),
      Vector2(0, -1.1),
      Vector2(5.6, 0),
      Vector2(0, 1.1),
    ];

    shape.set(vertices);

    final fixtureDef = FixtureDef(
      shape,
      userData: this, // To be able to determine object in collision
      restitution: 0.4,
    );
    final bodyDef = BodyDef(
      bullet: true,
      angularVelocity: -1,
      position: initialPosition,
      angle: angle,
      linearVelocity: Vector2.all(0),
      type: BodyType.dynamic,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
  //   const speed = 50.0;
  //   final velocity = Vector2(cos(angle), sin(angle)) * speed;

  //   final bodyDef = BodyDef(
  //     bullet: true,
  //     angularVelocity: -1,
  //     position: initialPosition,
  //     angle: angle,
  //     linearVelocity: velocity,
  //     type: BodyType.dynamic,
  //   );
  //   final body = world.createBody(bodyDef)..createFixture(fixtureDef);

  //   const dragConstant = 0.5;

  //   final flightDirection = body.linearVelocity;
  //   final flightSpeed = flightDirection.length;
  //   final pointingDirection = body.worldVector(Vector2(6, 5));
  //   final dot = dot2(flightDirection, pointingDirection);

  //   final dragForceMagnitude =
  //       1 - dot.abs() * flightSpeed * flightSpeed * dragConstant * body.mass;

  //   final arrowTailPosition = body.worldPoint(Vector2(-5.4, -4.4));

  //   final dragForce = flightDirection * -dragForceMagnitude;

  //   body.applyForce(
  //     dragForce,
  //     point: arrowTailPosition,
  //   );

  //   return body;
  // }
}
