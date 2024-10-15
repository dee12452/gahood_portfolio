import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wall extends PositionComponent {
  Wall({
    required super.position,
    required super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(isSolid: true));
  }
}
