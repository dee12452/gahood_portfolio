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

class SelectionInteraction extends Interaction {
  final PositionComponent parent;
  late final Direction direction;
  late final List<GahoodTextBoxConfig> configs;

  SelectionInteraction({
    required GahoodGame game,
    required this.parent,
    required String interactionId,
    required Map<String, Function> operations,
  }) {
    final interactionDef =
        game.interactionFile[interactionId] as Map<String, dynamic>;
    direction = Direction.fromInt(interactionDef['direction'] as int)!;
    final texts = (interactionDef['texts'] as List).cast<String>();
    final selections =
        (interactionDef['selections'] as List).cast<Map<String, dynamic>>();
    configs = [];
    for (final text in texts) {
      configs.add(GahoodTextBoxConfig(text: text));
    }
    for (final selection in selections) {
      final text = selection['text'] as String;
      final options = (selection['options'] as List).cast<String>();
      final textBoxSelections = <GahoodTextBoxSelection>[];
      for (final option in options) {
        textBoxSelections.add(
          GahoodTextBoxSelection(
            text: option,
            onSelect: operations[option]!,
          ),
        );
      }
      configs
          .add(GahoodTextBoxConfig(text: text, selections: textBoxSelections));
    }
  }

  @override
  bool canInteract(Direction facingDirection) {
    return direction == facingDirection;
  }

  @override
  void interact() {
    final textComponent = GahoodTextBox(configs: configs);
    parent.add(textComponent);
  }
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
    final textComponent = GahoodTextBox.textOnly(texts: texts);
    parent.add(textComponent);
  }
}

mixin Interactable {
  Interaction getInteraction();
}
