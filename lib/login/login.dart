import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class login extends StatefulWidget {
  static const String id = 'login';
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Row(
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/MistoLog.png", scale: 0.2,),
              Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              )
            ],
          )
          ),
        ],
      )
    );
  }
}
