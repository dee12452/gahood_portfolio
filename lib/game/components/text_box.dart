import 'dart:ui';

import 'package:flame/components.dart';

class GahoodTextBox extends TextBoxComponent {
  final bgPaint = Paint()..color = const Color(0xFFFF00FF);
  final borderPaint = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.stroke;

  GahoodTextBox(String text)
      : super(
          text: text,
          boxConfig: const TextBoxConfig(timePerChar: 0.05),
        );

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(1), borderPaint);
    super.render(canvas);
  }
}
