import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:sticky_projectiles_box2d/arrow.dart';
import 'package:sticky_projectiles_box2d/main.dart';

class CirclePolygon extends CircleComponent
    with HasGameRef<StickyProjectilesGame> {
  CirclePolygon(
      {super.position, super.angle, super.radius, required this.arrow})
      : super(
          paint: BasicPalette.blue.paint(),
          anchor: Anchor.center,
        );
  final _upVector = Vector2(0, 1);
  final PlayerArrow arrow;

  @override
  Future<void> onLoad() {
    add(arrow);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _getAngle();
    super.update(dt);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    canvas.drawLine(
      const Offset(2, 2),
      const Offset(0, 2),
      BasicPalette.yellow.paint(),
    );
  }

  void _getAngle() {
    // DevKage used this calculation in one of his games, how does it work?
    final dir = game.mousePosition - position;
    angle = (-dir.angleToSigned(_upVector)) * scale.x.sign - (pi * 0.5);
  }
}
