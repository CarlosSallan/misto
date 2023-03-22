import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../funciones.dart';
import 'login.dart';

class registro extends StatefulWidget {
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
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Registrarse", style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 40,
                      ),),
                      Text("¡Registrate en Misto!", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        makeInput(label: "Email"),
                        makeInput3(label: "Nombre de usuario"),
                        makeInput2(label: "Password", obscureText: true),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child:                     Container(
                        padding:  EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),

                            )
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
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

                                addUser(userCredentials.user, nickname.text);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              } catch (e) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            },
                          color: Color.fromRGBO(22,53,77,1.000),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child:  Text("Registrarse", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          ),),
                        ),
                      )
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,

                  ),
                ),
              ),

            )


          ],
        ) ,

      ),
    );
  }
  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: email,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
  Widget makeInput3({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: nickname,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
  Widget makeInput2({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          controller: password,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}
