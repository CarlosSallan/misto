import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../funciones.dart';

class registro extends StatefulWidget{
  const registro({Key? key}) : super(key: key);

  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {
  final nickname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String ema = "";
  String pass = "";
  String nick = "";

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
                            controller: nickname,
                            obscureText: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                              hintText: 'Nombre de usuario',
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10), child: TextField(
                            controller: email,
                            obscureText: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                              hintText: 'Correo Gmail',
                            ),
                          ),),
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

                        ],
                      )
                  ),


                  Container(
                    height:50, //height of button
                    width:150,
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        child: Text('Registrarse', style: TextStyle(fontSize: 20.0),),
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
                          nick = nickname.text;

                          if (nick.isEmpty) {
                            print("Nickname cannot be empty");
                            return;
                          }
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Contraseña no válida"),
                              ),
                            );
                            return;
                          }

                          try {
                            final userSnapshot = FirebaseDatabase.instance
                                .reference()
                                .child("users")
                                .orderByChild("email")
                                .equalTo(ema)
                                .once();


                            final userCredentials = await auth.createUserWithEmailAndPassword(
                              email: ema,
                              password: pass,
                            );

                            addUser(userCredentials.user, nickname.text, ema);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => login()),
                            );
                          } catch (e) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }

                    ),
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
