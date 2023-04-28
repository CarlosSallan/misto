import 'package:flutter/material.dart';
import 'package:misto/acceder/welcome.dart';
import 'package:misto/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:misto/profile/perfil2.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: login.id,
      routes: {
        login.id: (context) => const welcome(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}