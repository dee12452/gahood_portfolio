import 'dart:async';
import 'dart:convert';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gahood_portfolio/game/components/player.dart';
import 'package:gahood_portfolio/game/components/world.dart';
import 'package:gahood_portfolio/game/input.dart';
import 'package:gahood_portfolio/game/state.dart';

class GahoodGame extends FlameGame with KeyboardEvents, TapCallbacks {
  final String alias;
  final int character;
  final KeyUpCubit keyUpCubit = KeyUpCubit();
  final KeyDownCubit keyDownCubit = KeyDownCubit();

  late final Map<String, dynamic> interactionFile;
  GameState state;

  GahoodGame({
    required this.alias,
    required this.character,
    this.state = GameState.play,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final interactionFileStr =
        await rootBundle.loadString('assets/texts/interactions.json');
    interactionFile = json.decode(interactionFileStr);

    camera = CameraComponent.withFixedResolution(width: 500, height: 300);
    world = GahoodWorld(
      camera: camera,
      player: Player(character: character),
      keyUpCubit: keyUpCubit,
      keyDownCubit: keyDownCubit,
    );
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      keyDownCubit.update(event.logicalKey);
      return KeyEventResult.handled;
    } else if (event is KeyUpEvent) {
      keyUpCubit.update(event.logicalKey);
      return KeyEventResult.handled;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
