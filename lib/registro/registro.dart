import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class registro extends StatefulWidget{
  const registro({Key? key}) : super(key: key);

  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {
  final email = TextEditingController();
  final password = TextEditingController();

  String ema = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {

    void addUser(String email, String pass) async{
      var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      await FirebaseFirestore.instance.collection('Users')
          .doc(user?.uid).set({
        'firstName': "Manuel",
        'timestamp': timestamp.toString()
          });
    }

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




                            addUser(ema, pass);

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
