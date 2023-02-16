import 'package:flutter/material.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({Key? key}) : super(key: key);
  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  static  Color colorBorde = Color(0xFF16354D);
  static Color colorFondo = Color(0xFFD2D2D4);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.height * 0.03,
      ),
      child: 
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorFondo,
            boxShadow: [
              BoxShadow(color: colorBorde, spreadRadius: 3),
            ],
          ),
          child:
            Row(
              children: [

              ],
            )
        )
    );
  }
}
