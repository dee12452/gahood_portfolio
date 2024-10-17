import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/components/movement.dart';
import 'package:gahood_portfolio/game/components/wall.dart';
import 'package:gahood_portfolio/game/components/world.dart';
import 'package:gahood_portfolio/game/game.dart';

class AnimationContext {
  Direction currentDirection = Direction.down;
}

class Player extends SpriteAnimationComponent
    with HasGameReference<GahoodGame>, CollisionCallbacks, MovementController {
  final int character;
  final double speed;
  late SpriteSheet _idleSpriteSheet;
  late SpriteSheet _walkSpriteSheet;
  late Sprite _questionMarkSprite;
  SpriteComponent? _questionMark;

  Player({required this.character, this.speed = 100})
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
      row: _rowFromDirection(direction),
      stepTime: 0.2,
      to: 4,
    );

    final questionMarkImage = await Flame.images.load('question_mark.png');
    _questionMarkSprite = Sprite(questionMarkImage);

    final hitbox = RectangleHitbox.relative(
      Vector2(0.8, 0.5),
      parentSize: size,
      position: Vector2(size.x * 0.1, size.y * 0.5),
    );
    add(hitbox);
  }

  @override
  void setPosition(Vector2 position) {
    this.position = position;
  }

  @override
  Vector2 getPosition() {
    return position;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.play) {
      stop();
      return;
    }

    final direction = Direction.fromKey(game.nextDirectionKey);
    move(dt, speed, direction);
    final map = (game.world as GahoodWorld).map;
    if (position.x - size.x / 2 < 0 ||
        position.y - size.y / 2 < 0 ||
        position.x + size.x / 2 > map.size.x ||
        position.y + size.y / 2 > map.size.y) {
      undoMove();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Wall) {
      undoMove();
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
        if (interactable.canInteract(direction)) {
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

  @override
  onStartMove(Direction newDirection) {
    animation = _walkSpriteSheet.createAnimation(
      row: _rowFromDirection(newDirection),
      stepTime: 0.2,
      to: 4,
    );
  }

  @override
  onStopMove() {
    animation = _idleSpriteSheet.createAnimation(
      row: _rowFromDirection(direction),
      stepTime: 0.2,
      to: 4,
    );
  }

  int _rowFromDirection(Direction direction) {
    int row;
    switch (direction) {
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
