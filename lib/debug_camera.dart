import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticky_projectiles_box2d/main.dart';

class DebugCameraController extends PositionComponent
    with KeyboardHandler, HasGameRef<StickyProjectilesGame> {
  final double moveSpeed;
  final double zoomSpeed;

  // final _direction = Vector2.zero();
  // late final TextComponent _text;
  final double _speed = 300;

  double get speed => _speed;

  DebugCameraController({
    super.position,
    this.moveSpeed = 10,
    this.zoomSpeed = 0.1,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // add(
    //   _text = TextComponent(
    //     anchor: Anchor.center,
    //     position: size / 2,
    //   ),
    // );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final delta = 1 / game.camera.viewfinder.zoom;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      game.camera.moveBy(Vector2(-moveSpeed * delta, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      game.camera.moveBy(Vector2(moveSpeed * delta, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      game.camera.moveBy(Vector2(0, -moveSpeed * delta));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      game.camera.moveBy(Vector2(0, moveSpeed * delta));
    }
    if (keysPressed.contains(LogicalKeyboardKey.minus)) {
      game.camera.viewfinder.zoom = game.camera.viewfinder.zoom - zoomSpeed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.equal)) {
      // '+' key is usually 'equal' when not shifted
      game.camera.viewfinder.zoom = game.camera.viewfinder.zoom + zoomSpeed;
    }

    return false;
  }
}

class CameraBounds extends PositionComponent {
  CameraBounds({
    required this.reference,
    required this.bound,
    this.showBounds = false,
  });

  final PositionComponent reference;
  final double bound;
  final bool showBounds;

  late final Vector2 referenceOffset;

  double translateValue = 0;
  double translatedValue = 0;

  void _updatePosition(double dt) {
    position.x = reference.position.x + referenceOffset.x;

    final playerPosition = reference.position.y + referenceOffset.y;
    final difference = playerPosition - position.y;
    if (difference.abs() > bound) {
      translateValue = difference;
    }

    if (translateValue.abs() > 0) {
      final translationDifference =
          (translateValue.abs() - translatedValue.abs()) / translateValue.abs();
      var speed = 1.0 - translationDifference;
      speed = 1 - speed * speed * speed * speed;

      final step = (800 * speed) * dt * translateValue.sign;

      position.y += step;
      translatedValue += step.abs();

      if (translateValue.abs() - translatedValue.abs() < 10) {
        translateValue = 0;
        translatedValue = 0;
      }
    }
  }

  @override
  void onMount() {
    super.onMount();

    referenceOffset = Vector2(
      reference.size.x,
      reference.size.y,
    );
    position.y = reference.position.y + referenceOffset.y;

    _updatePosition(0);

    if (showBounds) {
      const referenceLine = 150.0;
      add(
        RectangleComponent(
          position: Vector2(
            -referenceLine / 2,
            -bound,
          ),
          size: Vector2(
            referenceLine,
            2,
          ),
          paint: Paint()..color = Colors.red,
        ),
      );

      add(
        RectangleComponent(
          position: Vector2(
            -referenceLine / 2,
            0,
          ),
          size: Vector2(
            referenceLine,
            2,
          ),
          paint: Paint()..color = Colors.green,
        ),
      );

      add(
        RectangleComponent(
          position: Vector2(
            -referenceLine / 2,
            bound,
          ),
          size: Vector2(
            referenceLine,
            2,
          ),
          paint: Paint()..color = Colors.red,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updatePosition(dt);
  }
}

class DebugCameraAnchor extends Component
    with ParentIsA<PositionComponent>, HasGameRef<StickyProjectilesGame>
    implements ReadOnlyPositionProvider {
  DebugCameraAnchor({
    required this.levelSize,
    required this.cameraViewport,
    this.showCameraBounds = false,
  });

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  final Vector2 _anchor = Vector2.zero();
  late final PositionComponent _bounds;
  final bool showCameraBounds;

  late final Vector2 _cameraMin = Vector2(
    cameraViewport.x * .4,
    cameraViewport.y / 2,
  );

  late final Vector2 _cameraMax = Vector2(
    levelSize.x - cameraViewport.x / 2,
    levelSize.y - cameraViewport.y / 2,
  );

  late final _cameraXOffset = cameraViewport.x * .3;
  late final _cameraYOffset = cameraViewport.y * .2;

  @override
  Vector2 get position => _anchor;

  void _setAnchor(double x, double y) {
    _anchor
      ..x = x.clamp(_cameraMin.x, _cameraMax.x) + _cameraXOffset
      ..y = y.clamp(_cameraMin.y, _cameraMax.y) - _cameraYOffset;
  }

  @override
  void onMount() {
    super.onMount();

    _bounds = CameraBounds(
      reference: parent,
      bound: 128,
      showBounds: showCameraBounds,
    );
    gameRef.world.add(_bounds);

    final value = parent.position.clone();
    _setAnchor(value.x, value.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _setAnchor(
      _bounds.position.x,
      _bounds.position.y,
    );
  }
}
