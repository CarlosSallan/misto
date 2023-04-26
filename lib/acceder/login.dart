import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:misto/acceder/welcome.dart';

import '../main_screen/main_screen.dart';
import '../user.dart';




class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  String ema = "";
  String pass = "";






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => welcome()), (Route route) => false);
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
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Text("Inicio de sesión", style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 40,
                        ),),
                        Text("¡Ingrese a su cuenta!", style: TextStyle(
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
                        makeInput2(label: "Password", obscureText: true),
                      ],
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () async{
                      ema = email.text;
                      pass = password.text;

                      if (ema.isEmpty) {
                        print("Email field cannot be empty");
                        return;
                      }

                      if (!ema.contains("@") || !ema.endsWith(".com")) {
                        print("Email is not valid");
                        return;
                      }

                      try {
                        final userSnapshot = FirebaseDatabase.instance
                            .reference()
                            .child("users")
                            .orderByChild("email")
                            .equalTo(ema)
                            .once();


                        final user = await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: ema,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Correo de recuperación enviado.'),
                          ),
                        );
                      } catch (e) {

                        if (e == 'user-not-found') {
                          print('No user found for that email.');
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: Text('¿olvidaste la contraseña?',  textAlign: TextAlign.right,),
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
                            final user;
                            try {
                              final userSnapshot = FirebaseDatabase.instance
                                  .reference()
                                  .child("users")
                                  .orderByChild("email")
                                  .equalTo(ema)
                                  .once();


                              user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: ema,
                                password: pass,
                              );

                              Usuario currentUser = Usuario(
                                id: user.user!.uid,
                                email: ema,
                              );

                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => main_screen(currentUser: currentUser),
                                ),
                                    (Route route) => false,
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
                          },
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child:  Text("Login", style: TextStyle(
                          color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: <Widget>[
                      Text("¿No tienes una cuenta?"),
                      Text(" Registrarse")
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill,

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
