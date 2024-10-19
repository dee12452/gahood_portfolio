import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingCursor extends StatefulWidget {
  final Duration duration;
  final double fontSize;

  const BlinkingCursor({
    super.key,
    required this.duration,
    required this.fontSize,
  });

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(widget.duration, (timer) {
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visible ? '|' : ' ',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32.0, // adjust to your desired font size
        fontWeight:
            FontWeight.bold, // optional: adjust to your desired font weight
      ),
    );
  }
}
