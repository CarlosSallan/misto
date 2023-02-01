import 'package:flutter/material.dart';
import '../container/menu.dart';

class mensajes extends StatefulWidget {
  const mensajes({Key? key}) : super(key: key);

  @override
  State<mensajes> createState() => _mensajesState();
}

class _mensajesState extends State<mensajes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child:
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.amber,
                child:
                Row(
                )
            ),

            ),
            //Menu
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child:
                      menu(pagina: 1,)
                  )
                ]
            )
          ],
        )
    );
  }
}
