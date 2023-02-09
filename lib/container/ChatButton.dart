import 'package:flutter/material.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Image.asset(
      "assets/MistoLog.png",
      scale: 0.1,
    ),
    );
  }
}
