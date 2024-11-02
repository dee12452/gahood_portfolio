import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:gahood_portfolio/game/input.dart';
import 'package:gahood_portfolio/game/state.dart';

class _ActualTextBox extends TextBoxComponent {
  static const double _width = 250;
  static const double _height = 75;

  final bgPaint = Paint()..color = Colors.black;
  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;
  final Vector2 parentSize;

  _ActualTextBox(String text, this.parentSize)
      : super(
          text: text,
          boxConfig: const TextBoxConfig(timePerChar: 0.025),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = Vector2(
      (parentSize.x - _width) / 2,
      parentSize.y - _height - (parentSize.y * .05),
    );
  }

  @override
  void render(Canvas canvas) {
    Rect rect = const Rect.fromLTWH(0, 0, _width, _height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(1), borderPaint);
    super.render(canvas);
  }
}

class _SelectionTextBox extends _ActualTextBox {
  int selection = 0;
  late final SpriteComponent selectorArrow;
  final int maxOptions;

  _SelectionTextBox(
    String initialText,
    List<GahoodTextBoxSelection> options,
    Vector2 parentSize,
  )   : maxOptions = options.length - 1,
        super(
          '$initialText\n${options.map((e) => '${' ' * 8}${e.text}').join('\n')}',
          parentSize,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await Flame.images.load('ui.png');
    selectorArrow = SpriteComponent.fromImage(
      image,
      srcSize: Vector2.all(32),
      srcPosition: Vector2(32 * 1, 32 * 8),
    );
    selectorArrow.position = Vector2(0, 15 + selection * 15);
    onComplete = () => add(selectorArrow);
  }

  void changeSelection(Direction direction) {
    if (!finished) {
      return;
    }
    int selectionChange = 0;
    if (direction == Direction.up) {
      selectionChange--;
    } else if (direction == Direction.down) {
      selectionChange++;
    } else {
      return;
    }
    selection = min(max(selection + selectionChange, 0), maxOptions);
    selectorArrow.position = Vector2(0, 15 + selection * 15);
  }
}

class GahoodTextBoxSelection {
  final String text;
  final Function onSelect;

  GahoodTextBoxSelection({required this.text, required this.onSelect});
}

class GahoodTextBoxConfig {
  final String text;
  final List<GahoodTextBoxSelection>? selections;

  GahoodTextBoxConfig({required this.text, this.selections});
}

class GahoodTextBox extends PositionComponent
    with
        HasGameReference<GahoodGame>,
        FlameBlocListenable<PlayerInputCubit, PlayerInput> {
  final List<GahoodTextBoxConfig> configs;
  final bool playGameOnFinished;
  late _ActualTextBox _currentTextBox;
  late Vector2 viewportSize;
  int index = 0;

  GahoodTextBox.textOnly({required List<String> texts})
      : this(configs: texts.map((t) => GahoodTextBoxConfig(text: t)).toList());
  GahoodTextBox({
    required this.configs,
    this.playGameOnFinished = true,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    viewportSize = game.camera.viewport.virtualSize;
    game.state = GameState.freeze;

    _addNextTextBox(index);
  }

  @override
  void onNewState(PlayerInput state) {
    if (state is PlayerMovementInput && _currentTextBox is _SelectionTextBox) {
      (_currentTextBox as _SelectionTextBox).changeSelection(state.direction);
      return;
    }

    if (state is! PlayerActionInput || !_currentTextBox.finished) {
      return;
    }

    if (_currentTextBox is _SelectionTextBox) {
      final int selection = (_currentTextBox as _SelectionTextBox).selection;
      configs[index].selections?[selection].onSelect();
    }

    _currentTextBox.removeFromParent();
    _addNextTextBox(++index);
  }

  @override
  void onRemove() {
    super.onRemove();
    if (playGameOnFinished) {
      game.state = GameState.play;
    }
  }

  void _addNextTextBox(int nextIndex) {
    if (nextIndex >= configs.length) {
      removeFromParent();
      return;
    }

    final nextConfig = configs[nextIndex];
    if ((nextConfig.selections?.length ?? 0) != 0) {
      _currentTextBox = _SelectionTextBox(
        nextConfig.text,
        nextConfig.selections!,
        viewportSize,
      );
    } else {
      _currentTextBox = _ActualTextBox(nextConfig.text, viewportSize);
    }
    game.camera.viewport.add(_currentTextBox);
  }
}
