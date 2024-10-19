import 'package:flutter/cupertino.dart';

class DescriptionText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const DescriptionText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: 1.2,
        height: 1.5,
      ),
    );
  }
}
