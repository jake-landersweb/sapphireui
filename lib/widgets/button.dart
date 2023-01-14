import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Used for wrapping a child in a very basic hit detection
/// widget. This widget will change the opacity of the widget to
/// be [tappedOpacity] when pressed. Can optionally specify the
/// speed of the transition with [duration].
class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.onTap,
    required this.child,
    this.duration = const Duration(milliseconds: 50),
    this.tappedOpacity = 0.4,
  });

  final VoidCallback onTap;
  final Widget child;
  final Duration duration;
  final double tappedOpacity;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: ((details) {
        setState(() {
          _isPressed = false;
        });
      }),
      child: AnimatedOpacity(
        opacity: _isPressed ? widget.tappedOpacity : 1,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
