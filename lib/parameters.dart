import 'package:flame_forge2d/flame_forge2d.dart';

class TargetParameters {
  final double hardness;

  TargetParameters({required this.hardness});
}

class StickyInfo {
  final Body arrowBody;
  final Body targetBody;

  StickyInfo({required this.arrowBody, required this.targetBody});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickyInfo &&
          runtimeType == other.runtimeType &&
          arrowBody == other.arrowBody;

  @override
  int get hashCode => arrowBody.hashCode;

  bool operator <(StickyInfo other) =>
      arrowBody.hashCode < other.arrowBody.hashCode;
}
