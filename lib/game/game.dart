import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class GahoodGame extends FlameGame
    with KeyboardEvents, TapCallbacks, HasCollisionDetection {
  final int character;
  final String alias;
  final String state;

  GahoodGame({
    required this.alias,
    required this.character,
    required this.state,
  });

  @override
  FutureOr<void> onLoad() {
    add(TextBoxComponent(
      text: state,
      boxConfig: const TextBoxConfig(
        maxWidth: 300.0, // Maximum width for the text box
        timePerChar: 0.05, // Speed of character rendering (optional)
      ),
    ));
    add(TextBoxComponent(
      text: 'I wonder if this goes away and comes back...',
      boxConfig: const TextBoxConfig(
        maxWidth: 300.0, // Maximum width for the text box
        timePerChar: 0.05, // Speed of character rendering (optional)
      ),
      position: Vector2(100, 100),
    ));
    return super.onLoad();
  }
}
