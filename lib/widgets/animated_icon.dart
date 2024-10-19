import 'package:flutter/material.dart';

class ArrowIcon extends StatefulWidget {
  final double size;
  final Color color;

  const ArrowIcon({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  State<ArrowIcon> createState() => _ArrowIconState();
}

class _ArrowIconState extends State<ArrowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * _animation.value),
          child: Icon(
            Icons.arrow_downward,
            size: widget.size,
            color: widget.color,
          ),
        );
      },
    );
  }
}
