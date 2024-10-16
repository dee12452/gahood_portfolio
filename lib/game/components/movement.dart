import 'package:flame/components.dart';
import 'package:gahood_portfolio/game/components/direction.dart';

class MovementContext {
  bool moving = false;
  Direction direction = Direction.down;
  Vector2 previousPosition = Vector2.all(0);
}

mixin MovementController {
  final MovementContext context = MovementContext();

  void undoMove() {
    setPosition(context.previousPosition);
  }

  void move(double dt, double speed, Direction? direction) {
    final previousPosition = getPosition();
    context.previousPosition = Vector2.copy(previousPosition);
    if (direction == null || speed == 0) {
      if (moving) {
        onStopMove();
      }
      context.moving = false;
      return;
    } else if (!moving) {
      onStartMove(direction);
    }
    Vector2 posOffset;
    switch (direction) {
      case Direction.down:
        posOffset = Vector2(0, speed * dt);
        break;
      case Direction.up:
        posOffset = Vector2(0, -speed * dt);
        break;
      case Direction.left:
        posOffset = Vector2(-speed * dt, 0);
        break;
      case Direction.right:
        posOffset = Vector2(speed * dt, 0);
        break;
    }
    setPosition(previousPosition + posOffset);
    context.moving = true;
    if (direction != context.direction) {
      onStartMove(direction);
    }
    context.direction = direction;
  }

  Direction get direction => context.direction;
  bool get moving => context.moving;

  void onStartMove(Direction newDirection);
  void onStopMove();
  Vector2 getPosition();
  void setPosition(Vector2 position);
}
