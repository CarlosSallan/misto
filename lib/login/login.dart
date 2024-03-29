import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main_screen/main_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import '../registro/registro.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../funciones.dart';
import '../user.dart';

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
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body:
      Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
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
                child: Text('olvidaste la contraseña?',  textAlign: TextAlign.right,),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  height:50, //height of button
                  width:125,
                  margin: const EdgeInsets.only(top: 20.0, right: 2.0),
                  child: ElevatedButton(
                      child: Text('Entrar', style: TextStyle(fontSize: 20.0),),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(22,53,77,1.000),
                        shadowColor: Color.fromRGBO(22,53,77,1.000),
                        elevation: 5,
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
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
                      }

                  ),
                ),
              ],),

              ElevatedButton(
                onPressed: () async {
                  await signInWithGoogle();
                  User? userGoogle = FirebaseAuth.instance.currentUser;
                  await addUser(userGoogle, "", ema); // Esperar a que se agregue el usuario a Firestore
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Color de fondo del botón
                  shape: RoundedRectangleBorder( // Forma del botón
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 2.0, // Elevación del botón
                ),
                child: Row(
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
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),


              TextButton(

                style: ButtonStyle(

                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(22,53,77,1.000),),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => registro()),
                  );
                },
                child: Text('¿No tinenes cuenta creada? registrate !!'),
              ),

            ],

          ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.10,
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
