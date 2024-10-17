import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/text_box.dart';
import 'package:gahood_portfolio/game/game.dart';

class InteractableComponent extends PositionComponent
    with Interactable, HasGameReference<GahoodGame> {
  final String interactionId;

  InteractableComponent({
    required this.interactionId,
    required super.position,
    required super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final hitbox = RectangleHitbox();
    add(hitbox);
  }

  @override
  Interaction getInteraction() {
    return TextInteraction(
      game: game,
      parent: this,
      textInteractionId: interactionId,
    );
  }
}

abstract class Interaction {
  const Interaction();

  bool canInteract(Direction facingDirection);
  void interact();
}

class TextInteraction extends Interaction {
  final PositionComponent parent;
  late final Direction direction;
  late final List<String> texts;

  TextInteraction({
    required GahoodGame game,
    required this.parent,
    required String textInteractionId,
  }) {
    final interactionDef =
        game.interactionFile[textInteractionId] as Map<String, dynamic>;
    direction = Direction.fromInt(interactionDef['direction'] as int)!;
    texts = (interactionDef['texts'] as List).cast<String>();
  }

  @override
  bool canInteract(Direction facingDirection) {
    return direction == facingDirection;
  }

  @override
  void interact() {
    final textComponent = GahoodTextBox(texts: texts);
    parent.add(textComponent);
  }
}

mixin Interactable {
  Interaction getInteraction();
}
