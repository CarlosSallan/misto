import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../main_screen/main_screen.dart';

import 'package:google_sign_in/google_sign_in.dart';
import '../funciones.dart';
import '../user.dart';
import 'registro.dart';
import 'login.dart';

class welcome extends StatefulWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  final email = TextEditingController();
  final password = TextEditingController();

  String ema = "";
  String pass = "";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("Tokens:");
    print(googleAuth);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("MISTO", style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 10.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 100,
                    ),),
                      Padding(
                       padding: EdgeInsets.only( top:75, bottom: 10),
                        child:  Text("bienvenido", style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),),
                      ),
                    Text('Misto es una aplicación social para conectar con tus amigos. \n Chatea e interactua con ellos mediante el mapa. \n ¡No esperes más y regístrate!',
                      textAlign:  TextAlign.center,
                      style: TextStyle(
                          color:Colors.black38,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Illustration.png')
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child:  Text("Inicio de sesión", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                    SizedBox(height: 20,),
                    Container(
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
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => registro()),
                          );
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
                    ),
                    SizedBox(height: 20,),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        await signInWithGoogle();
                        User? userGoogle = FirebaseAuth.instance.currentUser;
                        //await addUser(userGoogle, ""); // Esperar a que se agregue el usuario a Firestore
                        //Agregamos User a Firebase
                        Future<bool> Amigos = checkAmigosDoc(userGoogle);
                        addUser(userGoogle, "");
                        if(Amigos == false){
                          addAmistad(userGoogle);
                        }
                        Usuario currentUser = Usuario(
                          id: userGoogle!.uid,
                          email: userGoogle.email!,
                        );

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => main_screen(currentUser: currentUser),
                          ),
                              (Route route) => false,
                        );
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset( // Imagen del icono de Google
                            'assets/googleLogo.png',
                            height: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'Ingresar con Google', // Texto del botón
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}


