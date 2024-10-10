import 'dart:async';

import 'package:dart_enet/dart_enet.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:gahood_portfolio/game/connection.dart';

class GahoodGame extends FlameGame
    with KeyboardEvents, TapCallbacks, HasCollisionDetection {
  final int character;
  final String alias;
  final Connection connection;

  GahoodGame({
    required this.alias,
    required this.character,
    required this.connection,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final initialTextBox = TextBoxComponent(
      text: 'Welcome to the game!',
      boxConfig: const TextBoxConfig(
        maxWidth: 300.0, // Maximum width for the text box
        timePerChar: 0.05, // Speed of character rendering (optional)
      ),
    );
    initialTextBox.position = (size - initialTextBox.size) / 2;
    add(initialTextBox);
  }

  @override
  void update(double dt) {
    connection.update();
    super.update(dt);
  }

  @override
  void onRemove() {
    connection.disconnect();
    super.onRemove();
  }
}
