import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main_screen/main_screen.dart';
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
          Expanded(child:
            Column(

            ),
          ),
          Expanded(
              child:
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/MistoLog.png", scale: 0.2,),
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, top: MediaQuery.of(context).size.height * 0.02),
                child:
                Column(
                  children: [
                    const TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre de usuario',
                      ),
                    )
                  ],
                )
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
              TextButton(
                child: Text('SignUp', style: TextStyle(fontSize: 20.0),),
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
      )
    );
  }
}
