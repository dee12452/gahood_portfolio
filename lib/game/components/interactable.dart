import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/text_box.dart';
import 'package:gahood_portfolio/game/game.dart';

abstract class InteractableComponent extends PositionComponent
    with Interactable, HasGameReference<GahoodGame> {
  late final SpriteComponent exclamationMark;
  final int exclamationMarkOffset;

  InteractableComponent({
    required super.position,
    required super.size,
    this.exclamationMarkOffset = 5,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final hitbox = RectangleHitbox();
    add(hitbox);

    final exclamationImage = await Flame.images.load('exclamation_mark.png');
    exclamationMark = SpriteComponent.fromImage(exclamationImage);
    add(exclamationMark);
    exclamationMark.position = Vector2(
      (size.x - exclamationMark.size.x) / 2,
      exclamationMark.position.y - exclamationMarkOffset,
    );
    exclamationMark.priority = -1;
  }

  void interact(Direction direction) {
    final interaction = getInteraction();
    if (interaction.canInteract(direction)) {
      remove(exclamationMark);
      interaction.interact();
    }
  }
}

class BasicInteractable extends InteractableComponent {
  final String interactionId;

  BasicInteractable({
    required this.interactionId,
    required super.position,
    required super.size,
  });

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
  final bool playGameOnFinished;
  late final Direction direction;
  late final List<GahoodTextBoxConfig> configs;

  SelectionInteraction({
    required GahoodGame game,
    required this.parent,
    required String interactionId,
    required Map<String, Function> operations,
    this.playGameOnFinished = true,
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
    final textComponent = GahoodTextBox(
      configs: configs,
      playGameOnFinished: playGameOnFinished,
    );
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
