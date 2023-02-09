import 'package:flutter/material.dart';
import '../container/menu.dart';
import '../container/ChatButton.dart';

class mensajes extends StatefulWidget {
  static const String id = 'mensajes';
  const mensajes({Key? key}) : super(key: key);

  @override
  State<mensajes> createState() => _mensajesState();
}

class _mensajesState extends State<mensajes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body: Column(
        children: [
          Expanded(child:
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child:
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width * 90,
                          color: Colors.blue,
                        child: ChatButton()
                      )
                    ],
                  )
              )
            ],
          ),
          ),
          //Menu
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child:
                    menu(pagina: 4,)
                )
              ]
          )
        ],
      )
    );
  }
}
