import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../login/login.dart';
import '../container/menu.dart';
import '../container/menuWidget.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          Row(
            children: [
              Expanded(child:
              Column(

              ),
              ),
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
                    const TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre de usuario',
                      ),
                    ),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                    ),
                    TextButton(
                        child: Text('Cambiar.', style: TextStyle(fontSize: 20.0),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => main_screen()),
                          );
                        }
                    ),
                  ],

                ),
              ),
              Expanded(child:
              Column(

              ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  menu()
                ],
              )
            ],
          )
        ],
      )

    );
  }
}


