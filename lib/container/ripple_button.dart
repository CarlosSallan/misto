import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../login/login.dart';
import 'package:flutter/material.dart';
import '../container/RippleAnimation.dart';
import 'package:vibration/vibration.dart';
import '../main_screen/models/Usuario.dart' as UserApp;

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
          print('El URL del avatar de $fullName es $image');

          if (fullName != null) {
            userList.add(UserApp.Usuario(fullName, uid, true, latitude, longitude, image));
          }
        }
      }

      return userList; // devuelve la lista final de usuarios
    });
  }


  List<Widget> _anims = [];

  int _animationsRunning = 0;
  var _pressed = false;

  Future sendMail() async {
    String username = 'appmisto@gmail.com';
    String password = 'jyoyuvhjuvljqmie';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('kogutsofia04@gmail.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

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
    return Stack(
      children: <Widget>[
        Center(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                _pressed = true;
              });
              _runRipple();
            },
            onLongPressEnd: (_) {
              sendMail();
              setState(() {
                _anims = [];
                _pressed = false;
              });
            },
            child: Container(
              width: (_size.width * widget.size),
              height: (_size.width * widget.size),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.pink),
            ),
          ),
        ),
        ..._anims,
      ],
    );
  }
}