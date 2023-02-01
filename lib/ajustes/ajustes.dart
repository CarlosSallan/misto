import 'package:flutter/material.dart';
import '../main_screen/main_screen.dart';
import '../container/menu.dart';

class ajustes extends StatefulWidget {
  const ajustes({Key? key}) : super(key: key);
  @override
  State<ajustes> createState() => _ajustesState();
}

class _ajustesState extends State<ajustes> {
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
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Ajustes"),
                            //Boton de ajustes
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height * 0.01
                              ),
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.height * 0.10,
                              child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        "Cerrar sesión.",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        //añadir onpressed
                                      },
                                    ),
                                  ],
                                )
                            )

                          ],
                        )
                    )
                  ],
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
                      menu(pagina: 3,)
                  )
                ]
            )
          ],
        )
    );
  }
}
