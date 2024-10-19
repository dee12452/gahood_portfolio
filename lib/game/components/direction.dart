import 'package:flutter/services.dart';

enum Direction {
  up,
  down,
  left,
  right;

  static Direction? fromKey(LogicalKeyboardKey? key) {
    if (key == LogicalKeyboardKey.keyW || key == LogicalKeyboardKey.arrowUp) {
      return up;
    } else if (key == LogicalKeyboardKey.keyS ||
        key == LogicalKeyboardKey.arrowDown) {
      return down;
    } else if (key == LogicalKeyboardKey.keyA ||
        key == LogicalKeyboardKey.arrowLeft) {
      return left;
    } else if (key == LogicalKeyboardKey.keyD ||
        key == LogicalKeyboardKey.arrowRight) {
      return right;
    }
    return null;
  }

  static Direction? fromInt(int dir) {
    switch (dir) {
      case 1:
        return Direction.up;
      case 2:
        return Direction.down;
      case 3:
        return Direction.left;
      case 4:
        return Direction.right;
      default:
        return null;
    }
  }
}
