import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/components/wall.dart';
import 'package:gahood_portfolio/game/direction.dart';
import 'package:gahood_portfolio/game/game.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<GahoodGame>, CollisionCallbacks {
  final int character;
  late SpriteSheet _idleSpriteSheet;
  late SpriteSheet _walkSpriteSheet;
  Direction _prevDirection = Direction.down;
  double speed = 0;
  bool walking = false;
  Vector2? latestAppliedMovement;

  Player({required this.character})
      : super(
          size: Vector2(32, 48),
          position: Vector2(17 * 32, 5 * 32),
          anchor: Anchor.center,
          priority: 1,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final idleImage =
        await Flame.images.load('character_${character}_idle.png');
    final walkImage =
        await Flame.images.load('character_${character}_walk.png');
    _idleSpriteSheet = SpriteSheet(image: idleImage, srcSize: Vector2(32, 48));
    _walkSpriteSheet = SpriteSheet(image: walkImage, srcSize: Vector2(32, 48));
    animation = _idleSpriteSheet.createAnimation(
      row: character,
      stepTime: 0.2,
      to: 4,
    );

    final hitbox = RectangleHitbox.relative(
      Vector2(0.8, 0.5),
      parentSize: size,
      position: Vector2(size.x * 0.1, size.y * 0.5),
    );
    hitbox.debugMode = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final direction = Direction.fromKey(game.nextDirectionKey);
    final moving = _move(dt, direction);
    _animate(direction, !moving);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Wall && latestAppliedMovement != null) {
      position -= latestAppliedMovement!;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Interactable) {
      final interactable = other as Interactable;
      game.onActionPressed = () {
        if (interactable.canInteract(_prevDirection)) {
          interactable.interact();
        }
      };
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Interactable) {
      game.onActionPressed = null;
    }
  }

  bool _move(double dt, Direction? direction) {
    bool stopped = direction == null && speed > 0;
    if (direction == null) {
      speed = 0;
      return !stopped;
    } else {
      speed = 100;
    }
    Vector2 posOffset;
    switch (direction) {
      case Direction.down:
        posOffset = Vector2(0, speed);
        break;
      case Direction.up:
        posOffset = Vector2(0, -speed);
        break;
      case Direction.left:
        posOffset = Vector2(-speed, 0);
        break;
      case Direction.right:
        posOffset = Vector2(speed, 0);
        break;
    }
    latestAppliedMovement = (posOffset * dt);
    position += latestAppliedMovement!;
    return !stopped;
  }

  void _animate(Direction? direction, bool stopped) {
    if (direction == null) {
      if (!stopped) {
        return;
      }
      animation = _idleSpriteSheet.createAnimation(
        row: _rowFromDirection,
        stepTime: 0.2,
        to: 4,
      );
      walking = false;
      return;
    }
    if (_prevDirection == direction && walking) {
      return;
    }
    _prevDirection = direction;
    walking = true;
    animation = _walkSpriteSheet.createAnimation(
      row: _rowFromDirection,
      stepTime: 0.2,
      to: 4,
    );
  }

  int get _rowFromDirection {
    int row;
    switch (_prevDirection) {
      case Direction.up:
        row = 3;
        break;
      case Direction.down:
        row = 0;
        break;
      case Direction.left:
        row = 1;
        break;
      case Direction.right:
        row = 2;
        break;
    }
    return row;
  }
}
