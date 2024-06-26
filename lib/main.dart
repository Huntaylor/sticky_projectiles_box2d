import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sticky_projectiles_box2d/boundaries.dart';
import 'package:sticky_projectiles_box2d/circle_component.dart';
import 'package:sticky_projectiles_box2d/debug_camera.dart';

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

class StickyProjectilesGame extends Forge2DGame
    with MouseMovementDetector, HasKeyboardHandlerComponents {
  static final _cameraViewport = Vector2(800, 600);
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
    final debugAnchor = DebugCameraAnchor(
        levelSize: Vector2(
          1600,
          1200,
        ),
        cameraViewport: _cameraViewport);
    debugMode = true;
    await _drawPolygons();
    final debugCamera =
        DebugCameraController(position: camera.viewport.position.clone());

    // add(debugCamera);
    add(debugCamera);
    // debugCamera.add(debugAnchor);
    // camera.follow(debugAnchor);

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
    final groundWidth = game.size.x - 1; // 1 pixel less than game width
    add(Ground(
        size: Vector2(groundWidth, 50),
        position: Vector2(0, game.size.y + 50)));
  }
}

class Ground extends PositionComponent {
  Ground({super.position, super.size});

  final Paint groundPaint = Paint();
  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), groundPaint);
  }
}
