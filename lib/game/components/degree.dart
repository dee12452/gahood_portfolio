import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';

class Degree extends InteractableComponent {
  final Vector2 interactionOffset;

  Degree({
    required Vector2 rawPos,
    required this.interactionOffset,
  }) : super(
          position: _fromRawPos(rawPos),
          size: Vector2.all(32),
          exclamationMarkOffset: 20,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final degreeImg = await Flame.images.load('degree.png');
    final plaqueImg = await Flame.images.load('plaque.png');
    final degreeSprite = SpriteComponent.fromImage(degreeImg);
    final plaqueSprite = SpriteComponent.fromImage(plaqueImg);
    add(plaqueSprite);
    add(degreeSprite);

    final interactionHitbox = RectangleHitbox(
      position: interactionOffset + Vector2(0, -4),
      size: Vector2(plaqueSprite.size.x, plaqueSprite.size.y / 2),
    );
    add(interactionHitbox);
  }

  @override
  Interaction getInteraction() {
    return TextInteraction(
      game: game,
      parent: this,
      textInteractionId: 'degree',
    );
  }

  static Vector2 _fromRawPos(Vector2 rawPos) {
    return Vector2(rawPos.x - (rawPos.x % 32), rawPos.y - (rawPos.y % 32));
  }
}
