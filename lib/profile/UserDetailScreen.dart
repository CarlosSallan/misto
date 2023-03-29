import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'package:misto/Amigos/seguir.dart';
import '../container/menu.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Stream<DocumentSnapshot> _userStream;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _userStream =
        FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          ////
          print('IDEEEE: ${snapshot.data?.id}');
          ////

          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          String? name = data?['FullName'];
          String? email = user?.email;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FluttermojiCircleAvatar(
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.20,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hola, $name',//FirebaseFirestore.instance.collection("Users").doc(user.uid),
                                  style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                ElevatedButton(
                                  child: Text(
                                    'Editar avatar.',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(22, 53, 77, 1.000),
                                    shadowColor: Color.fromRGBO(22, 53, 77, 1.000),
                                    elevation: 5,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => customizePage())),
                                ),

                              ],
                            ),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.30,
                              width: MediaQuery.of(context).size.width * 0.70,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.03),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _textFieldController,
                                    focusNode: _focusNode,
                                    readOnly: isTextFieldEnable,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: myinputborder(),
                                      focusedBorder: myfocusborder(),
                                      hintText: 'Nombre de usuario',
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height *
                                            0.02),
                                  ),
                                  TextField(
                                    controller: _textFieldController2,
                                    focusNode: _focusNode,
                                    readOnly: isTextFieldEnable,
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
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height *
                                            0.02),
                                  ),
                                  TextButton(
                                      child: Text(
                                        'Cambiar.',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isTextFieldEnable) {
                                            isTextFieldEnable = false;
                                          } else {
                                            isTextFieldEnable = true;
                                          }
                                          print(isTextFieldEnable);
                                        });
                                      }),
                                  ElevatedButton(
                                    child: Text(
                                      'Buscar amigos.',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(22, 53, 77, 1.000),
                                      shadowColor: Color.fromRGBO(22, 53, 77, 1.000),
                                      elevation: 5,
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0)),
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => seguir())),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width,
                        child: menu(
                          pagina: 4,
                        ))
                  ])
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
    //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(40)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0,
      ));
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0,
      ));
}

class customizePage extends StatelessWidget {
  const customizePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(228, 229, 234, 1.000),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(22, 53, 77, 1.0),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FluttermojiCircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Spacer(),
                    FluttermojiSaveWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: false,
                  theme: FluttermojiThemeData(
                    boxDecoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ), //Border.all
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}