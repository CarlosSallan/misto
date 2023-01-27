import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../login/login.dart';
import '../profile/profile.dart';

Widget _menuBar(BuildContext context){
  return
    Container(
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
    );
}