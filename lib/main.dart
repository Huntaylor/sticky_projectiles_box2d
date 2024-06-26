import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sticky_projectiles_box2d/boundaries.dart';
import 'package:sticky_projectiles_box2d/circle_component.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GameWidget<StickyProjectilesGame>.controlled(
          gameFactory: () => StickyProjectilesGame(),
        ),
      ),
    );
  }
}

class StickyProjectilesGame extends Forge2DGame with MouseMovementDetector {
  StickyProjectilesGame()
      : super(
          world: ProjectileWorld(),
        );
  final Vector2 mousePosition = Vector2.zero();
  final circleVector = Vector2.zero();

  @override
  void onMouseMove(PointerHoverInfo info) {
    mousePosition.setFrom(camera.globalToLocal(info.eventPosition.global));
    circleVector.setFrom(info.eventPosition.global);
    super.onMouseMove(info);
  }

  @override
  FutureOr<void> onLoad() async {
    await _drawPolygons();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(800, 600));
    return super.onLoad();
  }

  _drawPolygons() {
    add(
      CirclePolygon(
        Vector2(100, 900),
        OutlineComponent(),
      ),
    );
  }
}

class ProjectileWorld extends Forge2DWorld
    with HasGameReference<Forge2DGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll(createBoundaries(game, strokeWidth: 2));
    add(Ground());
  }
}

class Ground extends PositionComponent {
  Ground() : super(size: Vector2(1000, 30));

  final Paint groundPaint = Paint();

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), groundPaint);
  }
}
