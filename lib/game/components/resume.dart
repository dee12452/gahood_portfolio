import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:url_launcher/url_launcher.dart';

class Resume extends InteractableComponent {
  final Vector2 interactionOffset;

  Resume({
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
    final resumeImg = await Flame.images.load('resume.png');
    final resumeSprite = SpriteComponent.fromImage(resumeImg);
    add(resumeSprite);

    final interactionHitbox = RectangleHitbox(
      position: interactionOffset + Vector2(0, -4),
      size: Vector2(resumeSprite.size.x, resumeSprite.size.y / 2),
    );
    add(interactionHitbox);
  }

  @override
  Interaction getInteraction() {
    final operations = <String, Function>{
      'Yes': () {
        final resumeUri = Uri.parse(
          'https://drive.google.com/file/d/1h-eGaxUhrtfKj304whRNwAl0X4qD2Qhj/view?usp=sharing',
        );
        launchUrl(resumeUri);
      },
      'No': () {},
    };
    return SelectionInteraction(
      game: game,
      parent: this,
      interactionId: 'resume',
      operations: operations,
    );
  }

  static Vector2 _fromRawPos(Vector2 rawPos) {
    return Vector2(rawPos.x - (rawPos.x % 32), rawPos.y - (rawPos.y % 32));
  }
}
