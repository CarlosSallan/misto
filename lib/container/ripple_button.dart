import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter/material.dart';
import '../container/RippleAnimation.dart';
import '../main_screen/models/Usuario.dart' as UserApp;
import 'package:location/location.dart' as loc;


class RippleButton extends StatefulWidget {
  const RippleButton({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RippleButton> {

  late Stream<List<UserApp.Usuario>> _userStream;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _userStream = getStreamAmigos(user?.uid);
  }



  Stream<List<UserApp.Usuario>> getStreamAmigos(String? uid) {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');

    amistadCollection.doc();


    return amistadCollection.doc(uid).get().asStream().map((doc) {
      final ArraySoli = (doc.data() ?? {})['ArrayAmigos'] as List<dynamic>?;
      if (ArraySoli == null || ArraySoli.isEmpty) {
        return []; // si no hay solicitudes pendientes, devuelve una lista vacía
      } else {
        return ArraySoli; // devuelve la lista de uid de los usuarios con solicitudes pendientes
      }
    }).asyncMap((soliList) async {
      final userList = <UserApp.Usuario>[]; // lista de usuarios a devolver

      for (final uid in soliList) {
        final userDoc = await userCollection.doc(uid).get();
        if (userDoc.exists) {
          final fullName = userDoc.data()?['FullName'] as String;

          final double latitude = double.parse(userDoc.data()!['latitude'].toString());
          final double longitude = double.parse(userDoc.data()!['longitude'].toString());
          final String image = userDoc.data()!['Avatar'];
          final String email = userDoc.data()!['Email'];
          print('El URL del avatar de $fullName es $image');
          print('El email es $email');

          if (fullName != null) {
            userList.add(UserApp.Usuario(fullName, uid, true, latitude, longitude, image, email));
          }
        }
      }

      return userList; // devuelve la lista final de usuarios
    });
  }

  void _enviarCorreos(List<UserApp.Usuario> users) async {
    loc.Location location = new loc.Location();
    loc.LocationData _locationData;

    _locationData = await location.getLocation();
    double latitude = _locationData.latitude!;
    double longitude = _locationData.longitude!;

    for(UserApp.Usuario user in users){
      sendMail(user.getEmail, latitude, longitude, user.FullName);
    }
  }




  List<Widget> _anims = [];

  int _animationsRunning = 0;
  var _pressed = false;

  Future sendMail(String correo, double latitude, double longitude, String name) async {
    print('Enviando correo a $correo');
    String username = 'appmisto@gmail.com';
    String password = 'jyoyuvhjuvljqmie';

    final smtpServer = gmail(username, password);

    // Crear el enlace de Google Maps
    String googleMapsLink = "https://www.google.com/maps/?q=$latitude,$longitude";

    final message = Message()
      ..from = Address(username, 'Misto')
      ..recipients.add(correo)
      ..subject = '${DateTime.now()}'
      ..text = ''
      ..html = "<table cellspacing='0' cellpadding='0' width='100%'>"
          "<tbody>"
          "<tr>"
          "<td class='es-p20t es-p20r es-p20l esd-structure' align='left' bgcolor='#16354D' style='background-color: #16354d;'>"
          "<table cellspacing='0' cellpadding='0' width='100%'>"
          "<tbody>"
          "<tr>"
          "<td class='es-m-p0r esd-container-frame' width='560' valign='top' align='center'>"
          "<table width='100%' cellspacing='0' cellpadding='0'>"
          "<tbody>"
          "<tr>"
          "<td align='center' class='esd-block-image' style='font-size: 0px;'>"
          "<a target='_blank'>"
          "<img class='adapt-img' src='https://xccpwv.stripocdn.email/content/guids/CABINET_a887509391999bb3dd70f0e62a113928398a920ef1885b9ba0d9b6492f8cbb53/images/mistoentradablanc_1673557831352_1673557831417_666921.png' alt style='display: block;' width='100'>"
          "</a>"
          "</td>"
          "</tr>"
          "</tbody>"
          "</table>"
          "</td>"
          "</tr>"
          "</tbody>"
          "</table>"
          "</td>"
          "</tr>"
          "<tr>"
          "<td>"
          "<h1>¡Tu amigo necesita ayuda!</h1>\n"
          "<p>Amigo: $name</p>\n"
          "<p>Latitud: $latitude, Longitud: $longitude</p>\n"
          "<p><a href='$googleMapsLink'></a>$googleMapsLink</p>"
          "</td>"
          "</tr>"
          "</tbody>"
          "</table>";




    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }


  void animationEnded() {
    _animationsRunning--;
    if (_animationsRunning == 0) {
      setState(() {
        _anims = [];
      });
    }
  }

  Timer? timer;
  void _runRipple() {
    timer = Timer.periodic(const Duration(milliseconds: 650), (Timer t) {
      if (_pressed) {
        _startAnimation();
      } else {
        timer!.cancel();
      }
    });
  }

  void _startAnimation() {
    setState(() {
      _anims.add(RippleAnimation(
        animationEnded,
        key: UniqueKey(),
        size: widget.size,
      ));

      _animationsRunning++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return StreamBuilder<List<UserApp.Usuario>>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<UserApp.Usuario> amigos = snapshot.data!;
          final List<UserApp.Usuario> emails = amigos.toList();

          return Stack(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onLongPress: () {
                    _enviarCorreos(emails);
                    setState(() {
                      _pressed = true;
                    });
                    _runRipple();
                  },
                  onLongPressEnd: (_) {
                    _enviarCorreos(emails);
                    setState(() {
                      _anims = [];
                      _pressed = false;
                    });
                  },
                  child: Container(
                    width: (_size.width * widget.size),
                    height: (_size.width * widget.size),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              ..._anims,
            ],
          );
        } else {
          // Si no hay datos, muestra un widget de reemplazo (por ejemplo, un Container vacío)
          return Container();
        }
      },
    );
  }
}
