import 'package:flutter/material.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  static Color colorBorde = Color(0xFF16354D);
  static Color colorFondo = Color(0xFFD2D2D4);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.height * 0.03,
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorFondo,
              boxShadow: [
                BoxShadow(color: colorBorde, spreadRadius: 3),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 1, child: Image.asset('assets/avatar_prueba.jpg')),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Manuel Dominguez'), Text('En línea.')],
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Image.asset('assets/emoji.png')))
              ],
            )));
  }
}
