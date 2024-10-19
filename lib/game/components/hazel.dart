import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/game.dart';

class _HazelInteraction extends TextInteraction {
  _HazelInteraction({required super.game, required super.parent})
      : super(textInteractionId: 'hazel');

  @override
  void interact() {
    super.interact();
    FlameAudio.play('dog_bark.ogg', volume: 0.1);
  }
}

class Hazel extends PositionComponent
    with Interactable, HasGameReference<GahoodGame> {
  late SpriteSheet _idleSpriteSheet;

  Hazel({
    required Vector2 rawPos,
  }) : super(position: _fromRawPos(rawPos), size: Vector2.all(32));

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await FlameAudio.audioCache.load('dog_bark.ogg');

    final hitbox =
        RectangleHitbox(position: Vector2(4, 2), size: Vector2(24, 38));
    add(hitbox);

    final idleImage = await Flame.images.load('dog_idle.png');
    _idleSpriteSheet = SpriteSheet(
      image: idleImage,
      srcSize: Vector2(96, 48),
    );
    final animation = _idleSpriteSheet.createAnimation(
      row: _rowFromDirection(Direction.down),
      stepTime: 0.3,
      to: 4,
    );
    final SpriteAnimationComponent dog =
        SpriteAnimationComponent(animation: animation);
    dog.position = dog.position - Vector2(32, 16);
    add(dog);
  }

  @override
  Interaction getInteraction() {
    return _HazelInteraction(
      game: game,
      parent: this,
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
