import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/components/text_box.dart';

class Degree extends PositionComponent with Interactable {
  final Direction interactionDirection;
  final Vector2 interactionPosition;

  Degree({
    required Vector2 rawPos,
    required this.interactionDirection,
    required this.interactionPosition,
  }) : super(position: _fromRawPos(rawPos));

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    final degreeImg = await Flame.images.load('degree.png');
    final plaqueImg = await Flame.images.load('plaque.png');
    final degreeSprite = SpriteComponent.fromImage(degreeImg);
    final plaqueSprite = SpriteComponent.fromImage(plaqueImg);
    add(plaqueSprite);
    add(degreeSprite);

    final interactionHitbox = RectangleHitbox(
      position: interactionPosition,
      size: plaqueSprite.size,
    );
    add(interactionHitbox);
  }

  @override
  bool canInteract(Direction facingDirection) {
    return interactionDirection == facingDirection;
  }

  @override
  void interact() {
    final textComponent = GahoodTextBox(
      'Hey, it\'s my Bachelor\'s Degree in Computer and Science!',
    );
    textComponent.onComplete = () => remove(textComponent);
    add(textComponent);
  }

  static Vector2 _fromRawPos(Vector2 rawPos) {
    return Vector2(rawPos.x - (rawPos.x % 32), rawPos.y - (rawPos.y % 32));
  }
}
