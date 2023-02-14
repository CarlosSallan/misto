import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main_screen/main_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class login extends StatefulWidget {
  static const String id = 'login';
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final email = TextEditingController();
  final password = TextEditingController();

  String ema = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body:
      Row(
        children: [
          Container(
            width: 120,
          ),
          Expanded(
              child:
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: Image.asset(
                  "assets/MistoLog.png",
                  scale: 0.1,
                ),
              ),


              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, top: MediaQuery.of(context).size.height * 0.02),
                child:
                Column(
                  children: [
                    TextField(
                      controller: email,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: 'Nombre de usuario',
                      ),
                    ),
                  ],
                )
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                  hintText: 'Contraseña',
                ),
              ),

              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(22,53,77,1.000),),
                ),
                onPressed: () { },
                child: Text('olvidaste la contraseña?',  textAlign: TextAlign.right,),
              ),

              Container(
                height:50, //height of button
                width:150,
                margin: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    child: Text('Entrar', style: TextStyle(fontSize: 20.0),),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(22,53,77,1.000),
                      shadowColor: Color.fromRGBO(22,53,77,1.000),
                      elevation: 5,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                    ),
                    onPressed: () async {
                      print("hola");
                      ema = email.text;
                      pass = password.text;

                      if (ema.isEmpty || pass.isEmpty) {
                        print("Email and password fields cannot be empty");
                        return;
                      }

                      if (!ema.contains("@") || !ema.endsWith(".com")) {
                        print("Email is not valid");
                        return;
                      }

                      if (pass.length < 6) {
                        print("Password must be at least 6 characters");
                        return;
                      }

                      try {
                        final userSnapshot = FirebaseDatabase.instance
                            .reference()
                            .child("users")
                            .orderByChild("email")
                            .equalTo(ema)
                            .once();


                        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: ema,
                              password: pass,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => main_screen()),
                            );
                      } catch (e) {
                        if (e == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    }

                ),
              ),




              TextButton(

                style: ButtonStyle(

                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(22,53,77,1.000),),
                ),
                onPressed: () { },
                child: Text('¿No tinenes cuenta creada? registrate !!'),
              ),

            ],

          ),
          ),

          Container(
            width: 120,
          ),
        ],



      )
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(
          color:Colors.white,
          width: 0,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(
          color:Colors.white,
          width: 0,
        )
    );
  }
}
