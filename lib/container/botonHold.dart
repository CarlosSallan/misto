import 'package:flutter/material.dart';

void main() => runApp(botonHold());

class botonHold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: Center(child: LoadingButton()),
      ),
    );
  }
}

class LoadingButton extends StatefulWidget {
  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) {
        if (controller.status == AnimationStatus.forward) {
          controller.reverse();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          CircularProgressIndicator(
            value: controller.value,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Icon(Icons.add)
        ],
      ),
    );
  }
}