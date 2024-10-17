import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:gahood_portfolio/game/game.dart';

class _ActualTextBox extends TextBoxComponent {
  final bgPaint = Paint()..color = Colors.black;
  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;
  final Vector2 parentSize;

  _ActualTextBox(String text, this.parentSize)
      : super(
          text: text,
          boxConfig: const TextBoxConfig(timePerChar: 0.03),
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
      (parentSize.x - size.x) / 2,
      parentSize.y - size.y - (parentSize.y * .05),
    );
  }

  @override
  void render(Canvas canvas) {
    Rect rect = const Rect.fromLTWH(0, 0, 210, 60);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(1), borderPaint);
    super.render(canvas);
  }
}

class GahoodTextBox extends PositionComponent
    with HasGameReference<GahoodGame> {
  final List<String> texts;
  late _ActualTextBox _currentTextBox;
  int index = 0;

  GahoodTextBox({required this.texts});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    game.state = GameState.freeze;

    final camera = game.camera;
    _addNextTextBox(camera, index);

    game.onActionPressed = () {
      if (_currentTextBox.finished) {
        _currentTextBox.removeFromParent();
        _addNextTextBox(camera, ++index);
      }
    };
  }

  @override
  void onRemove() {
    super.onRemove();
    game.onActionPressed = null;
    game.state = GameState.play;
  }

  void _addNextTextBox(CameraComponent camera, int nextIndex) {
    if (nextIndex >= texts.length) {
      removeFromParent();
      return;
    }

    _currentTextBox =
        _ActualTextBox(texts[nextIndex], camera.viewport.virtualSize);
    camera.viewport.add(_currentTextBox);
    _currentTextBox.onComplete = () {};
  }
}
