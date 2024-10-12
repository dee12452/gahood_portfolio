import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:gahood_portfolio/game/game.dart';

enum Direction {
  up,
  down,
  left,
  right;

  static Direction? fromKey(LogicalKeyboardKey? key) {
    if (key == LogicalKeyboardKey.keyW) {
      return up;
    } else if (key == LogicalKeyboardKey.keyS) {
      return down;
    } else if (key == LogicalKeyboardKey.keyA) {
      return left;
    } else if (key == LogicalKeyboardKey.keyD) {
      return right;
    }
    return null;
  }
}

class Player extends SpriteAnimationComponent
    with HasGameReference<GahoodGame> {
  final int character;
  SpriteSheet? _spriteSheet;
  Direction _prevDirection = Direction.down;

  Player({required this.character})
      : super(
          size: Vector2(16, 16),
          position: Vector2(0, 0),
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final image = await Flame.images.load('characters.png');
    _spriteSheet = SpriteSheet(image: image, srcSize: Vector2(16, 16));
    animation = _spriteSheet?.createAnimation(
      row: character,
      stepTime: 0.2,
      to: 1,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _move(dt);
  }

  void _move(double dt) {
    final direction = Direction.fromKey(game.nextDirectionKey);
    _animate(direction);
  }

  void _animate(Direction? direction) {
    if (direction == null || _prevDirection == direction) {
      return;
    }
    if (direction == Direction.left || _prevDirection == Direction.left) {
      flipHorizontally();
    }
    _prevDirection = direction;
    int from;
    switch (_prevDirection) {
      case Direction.up:
        from = 5;
        break;
      case Direction.down:
        from = 3;
        break;
      case Direction.left:
        from = 7;
        break;
      case Direction.right:
        from = 7;
        break;
    }
    animation = _spriteSheet?.createAnimation(
      row: character,
      stepTime: 0.2,
      from: from,
      to: from + 2,
    );
  }
}
