import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:gahood_portfolio/game/input.dart';
import 'package:gahood_portfolio/game/state.dart';

class _ActualTextBox extends TextBoxComponent {
  static const double _width = 210;
  static const double _height = 60;

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
              fontSize: 12,
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

class GahoodTextBox extends PositionComponent
    with
        HasGameReference<GahoodGame>,
        FlameBlocListenable<PlayerInputCubit, PlayerInput> {
  final List<String> texts;
  late _ActualTextBox _currentTextBox;
  late Vector2 viewportSize;
  int index = 0;

  GahoodTextBox({required this.texts});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    viewportSize = game.camera.viewport.virtualSize;
    game.state = GameState.freeze;

    _addNextTextBox(index);
  }

  @override
  void onNewState(PlayerInput state) {
    if (state is! PlayerActionInput) {
      return;
    }

    if (_currentTextBox.finished) {
      _currentTextBox.removeFromParent();
      _addNextTextBox(++index);
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    game.state = GameState.play;
  }

  void _addNextTextBox(int nextIndex) {
    if (nextIndex >= texts.length) {
      removeFromParent();
      return;
    }

    _currentTextBox = _ActualTextBox(texts[nextIndex], viewportSize);
    game.camera.viewport.add(_currentTextBox);
  }
}
