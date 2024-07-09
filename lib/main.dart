import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sticky_projectiles_box2d/arrow.dart';
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
    await images.loadAllImages();
    final debugCamera =
        DebugCameraController(position: camera.viewport.position.clone());

    add(debugCamera);
    camera.follow(debugCamera);

    return super.onLoad();
  }
}

class ProjectileWorld extends Forge2DWorld
    with HasGameReference<StickyProjectilesGame>, TapCallbacks {
  late PlayerArrow arrow;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll(
      createBoundaries(game),
    );
    arrow = PlayerArrow(Vector2(-55, 30), 0);
    final circle = CirclePolygon(
      arrow: arrow,
      position: Vector2(-55, 30),
      radius: 2,
    );
    add(circle);
  }
}
