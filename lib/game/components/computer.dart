import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:url_launcher/url_launcher.dart';

class Computer extends PositionComponent
    with Interactable, HasGameReference<GahoodGame> {
  Computer({
    required super.position,
    required super.size,
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
          'https://github.com/dee12452/gahoodrpg_wiki',
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
