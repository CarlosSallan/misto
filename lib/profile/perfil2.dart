
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../Amigos/aceptarUsers.dart';
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
                  icon: Icon(Icons.supervised_user_circle, size: 36.0), // Ajusta el tamaño del icono aquí
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => aceptarUsers())),
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
              top: 210.0,
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
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  iconSize: 48.0, // Ajusta el tamaño del botón aquí
                  padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
                ),
              ),
            ),


            /* imagen de perfil */

      //    Positioned(child: Container),








            /* button */

          ],

        );
      },
    ),

    );
  }
}
