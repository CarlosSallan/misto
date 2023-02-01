import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../login/login.dart';
import '../profile/profile.dart';
import '../profile/profile2.dart';
import '../container/menu.dart';

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
      body: Column(
        children: [
          Expanded(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(

                child: Text("SOS"),
                margin : EdgeInsets.fromLTRB(20, 8, 8, 16),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black12,
                ),

              ),
            ],


          ),
          ),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child:
                    menu(pagina: 2,)
                )
              ]
          )


        ],
      ),
    );
  }
}
