import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../login/login.dart';
import '../container/menu.dart';

class profile2 extends StatefulWidget{
  const profile2({Key? key}) : super(key: key);

  @override
  State<profile2> createState() => _profile2State();
}

class _profile2State extends State<profile2> {
  @override
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();
  Widget build(BuildContext context) {
    bool editable = false;
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
                children: [
                  Expanded(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Perfil"),
                        Container(
                          height:175,
                          width: 175,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(100)
                            //more than 50% of width makes circle
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                          child: TextButton(
                            child: Text(
                              "Cambiar avatar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              //añadir onpressed
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: (MediaQuery.of(context).size.width * 0.05), bottom: (MediaQuery.of(context).size.width * 0.05)),
                          width: MediaQuery.of(context).size.width * 0.70,
                          child:
                          Column(
                            children: [
                              TextField(
                                controller: _textFieldController,
                                focusNode: _focusNode,
                                readOnly: isTextFieldEnable,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombre de usuario',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: (MediaQuery.of(context).size.width * 0.025)),
                              ),
                              TextField(
                                controller: _textFieldController2,
                                focusNode: _focusNode,
                                readOnly: isTextFieldEnable,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contraseña',
                                ),
                              ),
                            ],
                          )
                        ),

                        TextButton(
                            child: Text('Cambiar.', style: TextStyle(fontSize: 20.0),),
                            onPressed: () {
                              setState(() {
                                if(isTextFieldEnable){
                                  isTextFieldEnable = false;
                                }else{
                                  isTextFieldEnable = true;
                                }
                                print(isTextFieldEnable);
                              });
                            }
                        ),
                      ],
                    ),
                  ),
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
                    menu(pagina: 4,)
                )
              ]
            )
          ],
        )

    );
  }
}