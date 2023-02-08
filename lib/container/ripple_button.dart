import 'dart:async';
import 'dart:math';
import '../login/login.dart';
import 'package:flutter/material.dart';
import '../container/RippleAnimation.dart';
import 'package:vibration/vibration.dart';

class RippleButton extends StatefulWidget {
  const RippleButton({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RippleButton> {
  List<Widget> _anims = [];

  int _animationsRunning = 0;
  var _pressed = false;

  void animationEnded() {
    _animationsRunning--;
    if (_animationsRunning == 0) {
      setState(() {
        _anims = [];
      });
    }
  }

  Timer? timer;
  void _runRipple() {
    timer = Timer.periodic(const Duration(milliseconds: 650), (Timer t) {
      if (_pressed) {
        _startAnimation();
      } else {
        timer!.cancel();
      }
    });
  }

  void _startAnimation() {
    setState(() {
      _anims.add(RippleAnimation(
        animationEnded,
        key: UniqueKey(),
        size: widget.size,
      ));

      _animationsRunning++;
    });
  }

  /*
  Future<bool> checkVibration(){

    if (await Vibration.hasVibrator()) {
      return true;
    }
    return false;
  }
  */

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Center(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                _pressed = true;
              });
              _runRipple();
            },
            onLongPressEnd: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login()),
              );
              setState(() {
                _anims = [];
                _pressed = false;
              });
            },
            child: Container(
              width: (_size.width * widget.size),
              height: (_size.width * widget.size),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.pink),
            ),
          ),
        ),
        ..._anims,
      ],
    );
  }
}