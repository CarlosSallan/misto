import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../login/login.dart';
import '../profile/profile.dart';
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


        ],
      ),


      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0
        ),
        decoration:
        BoxDecoration(
            color: Color.fromRGBO(22,53,77,1.000),
            borderRadius: BorderRadius.circular(100)
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical:  10.0,

            ),

            child: GNav(

              backgroundColor: Color.fromRGBO(22,53,77,1.000),
              activeColor: Colors.white60,
              color: Colors.white,
             padding: EdgeInsets.all(10),
              gap: 20,
              onTabChange: (index){
                print(index);
              },
              tabs: [
                GButton(
                    icon: Icons.map,

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  }
                ),
                GButton(
                    icon: Icons.chat,

                ),
                GButton(
                    icon: Icons.sos,

                ),
                GButton(
                  icon: Icons.settings,

                ),
                GButton(
                    icon: IconData(0xf522, fontFamily: 'MaterialIcons'),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => profile()),
                      );
                    }
                ),


              ],
            ),
          ),
      ),
    );
  }
}
