import 'package:flutter/material.dart';

class HoverImageButton extends StatefulWidget {
  final String imageFile;
  final Function onClick;

  const HoverImageButton({super.key, required this.imageFile, required this.onClick,});

  @override
  State<StatefulWidget> createState() => _HoverImageButtonState(imageFile, onClick);
}

class _HoverImageButtonState extends State<HoverImageButton> {
  final String imageFile;
  final Function onClick;

  bool _isHovering = false;

  _HoverImageButtonState(this.imageFile, this.onClick);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          // handle mouse enter
          _isHovering = true;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          // handle mouse exit
          _isHovering = false;
        });
      },
      child: Material(
        color: _isHovering ? Colors.blueGrey : Colors.grey,
        // set the default background color to transparent
        borderRadius: BorderRadius.circular(45),
        // set the border radius to make it circular
        child: InkWell(
          onTap: () {
            // handle button tap
            onClick();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              imageFile,
              height: 40,
              width: 40,
            ),
          ),
        ),
      ),
    );
  }
}
