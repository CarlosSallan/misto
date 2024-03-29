import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:misto/main_screen/main_screen.dart';
import '../mensajes/friends_screen.dart';
import '../profile/UserDetailScreen.dart';
import '../mensajes/mensajes.dart';
import '../ajustes/ajustes.dart';
import '../user.dart';

class menu extends StatefulWidget {
  final int pagina;
  final Usuario currentUser;

  const menu({Key? key, required this.pagina, required this.currentUser}) : super(key: key);

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
                      MaterialPageRoute(builder: (context) => main_screen(currentUser: widget.currentUser)),
                    );
                  }
              ),
              //1
              GButton (
                icon: Icons.chat,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendsScreen(currentUser: widget.currentUser)),
                    );
                  }
              ),
              //2
              GButton(
                icon: Icons.sos,
                  onPressed: () {
                    if(!(widget.pagina == 3)) {

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
                        MaterialPageRoute(builder: (context) => ajustes(currentUser: widget.currentUser)),
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
                        MaterialPageRoute(builder: (context) => UserDetailScreen(currentUser:  widget.currentUser,)),
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
