import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:url_launcher/url_launcher.dart';

class Computer extends InteractableComponent {
  Computer({
    required super.position,
    required super.size,
    super.exclamationMarkOffset = 8,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  Interaction getInteraction() {
    final operations = <String, Function>{
      'Yes': () {
        final resumeUri = Uri.parse(
          'https://github.com/dee12452/gahood_portfolio',
        );
        launchUrl(resumeUri);
      },
      'No': () {},
    };
    return SelectionInteraction(
      game: game,
      parent: this,
      interactionId: 'computer',
      operations: operations,
    );
  }
}
