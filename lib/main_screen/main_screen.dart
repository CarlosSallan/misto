import 'package:flutter/material.dart';
import '../login/login.dart';

class main_screen extends StatefulWidget {
  static const String id = 'main_screen';
  const main_screen({Key? key}) : super(key: key);

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Row(
          children: [
            Expanded(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text('SignUp', style: TextStyle(fontSize: 20.0),),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    }
                ),
              ],
            ),
            ),
          ],
        )
    );
  }
}
