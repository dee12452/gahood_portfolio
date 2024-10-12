import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gahood_portfolio/game/components/player.dart';
import 'package:gahood_portfolio/game/components/world.dart';
import 'package:gahood_portfolio/game/connection.dart';

class GahoodGame extends FlameGame
    with KeyboardEvents, TapCallbacks, HasCollisionDetection {
  static final Set<LogicalKeyboardKey> _arrowKeys = {
    LogicalKeyboardKey.keyW,
    LogicalKeyboardKey.keyA,
    LogicalKeyboardKey.keyS,
    LogicalKeyboardKey.keyD,
  };

  final int character;
  final String alias;
  final Connection connection;

  final List<LogicalKeyboardKey> _directionKeysDown = [];
  Player? _player;

  GahoodGame({
    required this.alias,
    required this.character,
    required this.connection,
  }) : super(
          world: GahoodWorld(),
          camera: CameraComponent.withFixedResolution(
            width: 800 * 0.3,
            height: 600 * 0.3,
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _player = Player(character: character);
    world.add(_player!);
    camera.follow(_player!);
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

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      return _onKeyDown(event);
    } else if (event is KeyUpEvent) {
      return _onKeyUp(event);
    }

    return super.onKeyEvent(event, keysPressed);
  }

  LogicalKeyboardKey? get nextDirectionKey =>
      _directionKeysDown.isEmpty ? null : _directionKeysDown.last;

  KeyEventResult _onKeyDown(KeyDownEvent event) {
    final key = event.logicalKey;
    if (_arrowKeys.contains(key)) {
      _directionKeysDown.remove(key);
      _directionKeysDown.add(key);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _onKeyUp(KeyUpEvent event) {
    final key = event.logicalKey;
    if (_arrowKeys.contains(key)) {
      if (_directionKeysDown.remove(key)) {
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }
}
