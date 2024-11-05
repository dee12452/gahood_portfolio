import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/components/movement.dart';
import 'package:gahood_portfolio/game/components/wall.dart';
import 'package:gahood_portfolio/game/components/world.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:gahood_portfolio/game/input.dart';
import 'package:gahood_portfolio/game/state.dart';

class AnimationContext {
  Direction currentDirection = Direction.down;
}

class Player extends SpriteAnimationComponent
    with HasGameReference<GahoodGame>, CollisionCallbacks, MovementController {
  static const double _walkAnimationSpeed = 0.15;
  static const double _idleAnimationSpeed = 0.25;

  final int character;
  final double speed;
  final List<InteractableComponent> _interactables = [];
  late SpriteSheet _idleSpriteSheet;
  late SpriteSheet _walkSpriteSheet;
  late Sprite _questionMarkSprite;
  SpriteComponent? _questionMark;
  Direction? _nextMoveDirection;

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
      stepTime: _idleAnimationSpeed,
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

    final playerInputListener =
        FlameBlocListener<PlayerInputCubit, PlayerInput>(
      onNewState: (state) {
        if (state is PlayerMovementInput) {
          _nextMoveDirection = state.direction;
        } else if (state is PlayerActionInput) {
          _onAction();
        } else {
          _nextMoveDirection = null;
        }
      },
    );
    await add(playerInputListener);
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

    move(dt, speed, _nextMoveDirection);
    _checkOutsideMap();
    _checkInteractionSprite();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Wall) {
      _nextMoveDirection = null;
      undoMove();
    } else if (other is InteractableComponent) {
      _interactables.add(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Interactable) {
      _interactables.remove(other as Interactable);
    }
  }

  @override
  onStartMove(Direction newDirection) {
    animation = _walkSpriteSheet.createAnimation(
      row: _rowFromDirection(newDirection),
      stepTime: _walkAnimationSpeed,
      to: 4,
    );
  }

  @override
  onStopMove() {
    animation = _idleSpriteSheet.createAnimation(
      row: _rowFromDirection(direction),
      stepTime: _idleAnimationSpeed,
      to: 4,
    );
  }

  void _onAction() {
    if (game.state != GameState.play || _interactables.isEmpty) {
      return;
    }

    final interaction = _interactables.last;
    interaction.interact(direction);
  }

  void _checkOutsideMap() {
    final map = (game.world as GahoodWorld).map;
    if (position.x - size.x / 2 < 0 ||
        position.y - size.y / 2 < 0 ||
        position.x + size.x / 2 > map.size.x ||
        position.y + size.y / 2 > map.size.y) {
      undoMove();
    }
  }

  void _checkInteractionSprite() {
    if (_interactables.isEmpty) {
      return;
    }

    final interactable = _interactables.last.getInteraction();
    if (!interactable.canInteract(direction) && _questionMark != null) {
      remove(_questionMark!);
      _questionMark = null;
    } else if (interactable.canInteract(direction) && _questionMark == null) {
      _questionMark = SpriteComponent(sprite: _questionMarkSprite);
      _questionMark!.position =
          Vector2((size.x - _questionMarkSprite.srcSize.x) / 2, -2);
      add(_questionMark!);
    }
  }

  static int _rowFromDirection(Direction direction) {
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
