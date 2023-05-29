import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RippleAnimation extends StatefulWidget {
  const RippleAnimation(this.endedCallback, {Key? key, required this.size})
      : super(key: key);
  final VoidCallback endedCallback;
  final double size;
  @override
  _RippleControllerState createState() => _RippleControllerState();
}

class _RippleControllerState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Color?> _color;

  late final Animation<double> _scale;

  @override
  void initState() {
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            widget.endedCallback();
          }
        }
      });
    _scale = Tween<double>(begin: 1, end: 3.5).animate(_controller);
    _color = ColorTween(
      begin: Colors.red,
      end: Colors.red.withOpacity(0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    final _size = MediaQuery.of(context).size;
    return Transform.scale(
      scale: _scale.value,
      alignment: Alignment.center,
      child: Container(
        width: (_size.width * widget.size),
        height: (_size.width * widget.size),
        decoration: BoxDecoration(shape: BoxShape.circle, color: _color.value),
      ),
    );
  }
}
