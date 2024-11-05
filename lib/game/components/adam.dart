import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';

class Adam extends InteractableComponent {
  late SpriteSheet _idleSpriteSheet;

  Adam({
    required Vector2 rawPos,
  }) : super(
          position: _fromRawPos(rawPos),
          size: Vector2.all(32),
          exclamationMarkOffset: 20,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final hitbox =
        RectangleHitbox(position: Vector2(4, 2), size: Vector2(24, 38));
    add(hitbox);

    final idleImage = await Flame.images.load('adam_idle.png');
    _idleSpriteSheet = SpriteSheet(
      image: idleImage,
      srcSize: Vector2(32, 48),
    );
    final animation = _idleSpriteSheet.createAnimation(
      row: _rowFromDirection(Direction.down),
      stepTime: 0.3,
      to: 4,
    );
    final SpriteAnimationComponent adam =
        SpriteAnimationComponent(animation: animation);
    adam.position = adam.position - Vector2(0, 16);
    add(adam);
  }

  @override
  Interaction getInteraction() {
    final operations = <String, Function>{
      'Yes': () => game.exitGame(),
      'No': () {},
    };
    return SelectionInteraction(
      game: game,
      parent: this,
      interactionId: 'adam',
      operations: operations,
    );
  }

  static Vector2 _fromRawPos(Vector2 rawPos) {
    return Vector2(rawPos.x - (rawPos.x % 32), rawPos.y - (rawPos.y % 32));
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
