import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sticky_projectiles_box2d/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.arrow).existsSync(), isTrue);
  });
}
