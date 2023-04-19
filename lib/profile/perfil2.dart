
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../user.dart';
import '../Amigos/seguirUsers.dart';
import '../acceder/login.dart';
import 'UserDetailScreen.dart';


class perfil2 extends StatefulWidget {
  final Usuario currentUser;
  const perfil2({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<perfil2> createState() => _perfil2State();
}

class _perfil2State extends State<perfil2> {

  late Stream<DocumentSnapshot> _userStream;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  bool isTextFieldEnable = true;
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _userStream = FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();
    super.initState();

  }
  Widget build(BuildContext context) {
    Usuario currentUser = widget.currentUser; //
    return Scaffold(

    body:StreamBuilder<DocumentSnapshot>(
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
        return Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
              top: 50.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.settings, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 130.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.supervised_user_circle, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => seguirUsers())),
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 210.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.map, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => main_screen(currentUser: currentUser)),
                    );
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 290.0,
              right: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(Icons.chat, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 30.0,
              child: Material(
                color:  Color.fromRGBO(228,229,234,1.000),
                borderRadius: BorderRadius.circular(10.0),
                child: IconButton(
                  icon: Icon(LineAwesomeIcons.angle_left), // Ajusta el tamaño del icono aquí
                  onPressed: () {
                    // Acción del botón
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),


            /* imagen de perfil */


            Positioned(
              top: 250,
              left: 150,

              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(228,229,234,1.000),
                      radius: 150.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar_prueba.jpg'),
                        radius: 140.0,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hola, $name',//FirebaseFirestore.instance.collection("Users").doc(user.uid),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Container(
                      height: 300,
                      width: 500,
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

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (isTextFieldEnable) {
                                  isTextFieldEnable = false;
                                } else {
                                  isTextFieldEnable = true;
                                }
                                print(isTextFieldEnable);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              ),
                              primary: Color.fromRGBO(22,53,77,1.000),
                            ),
                            child: Text(
                              "EDITAR",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),



                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),




            /* button */

          ],

        );
      },
    ),

    );
  }
}
