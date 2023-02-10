import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:misto/acceder/welcome_screen.dart';
import 'package:misto/main_screen/main_screen.dart';
import 'package:misto/profile/profileTest.dart';
import '../mensajes/mensajes.dart';
import '../ajustes/ajustes.dart';


class menu extends StatefulWidget {
  const menu({Key? key, required this.pagina}) : super(key: key);

  final int pagina; // 0 -> pagina principal | 1 -> mensajes | 2 -> SOS?? | 3 -> ajustes | 4-> perfil


  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
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
              //0
              GButton(
                  icon: Icons.map,

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => main_screen()),
                    );
                  }
              ),
              //1
              GButton(
                icon: Icons.chat,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => mensajes()),
                    );
                  }
              ),
              //2
              GButton(
                icon: Icons.sos,
                  onPressed: () {
                    if(!(widget.pagina == 3)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => welcomeScreen()),
                      );
                    }
                  }
              ),
              //3
              GButton(
                icon: Icons.settings,
                  onPressed: () {
                    if(!(widget.pagina == 3)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ajustes()),
                      );
                    }
                  }
              ),
              //4
              GButton(
                  icon: IconData(0xf522, fontFamily: 'MaterialIcons'),

                  onPressed: () {
                    if(!(widget.pagina == 4)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => profileTest()),
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
