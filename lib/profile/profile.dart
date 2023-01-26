import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:misto/main_screen/main_screen.dart';
import '../login/login.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(22,53,77,1.000) ,
        padding: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical:  20.0,
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
                  icon: Icons.logout,
                  text:'Inicio',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => main_screen()),
                    );
                  }
              ),
              GButton(
                icon: Icons.chat,
                text:'Like',
              ),
              GButton(
                icon: Icons.sos,

              ),
              GButton(
                icon: Icons.settings,
                text:'Buscar',
              ),
              GButton(
                  icon: IconData(0xf522, fontFamily: 'MaterialIcons'),
                  text:'Usuario',
              ),


            ],
          ),
        ),
      ),
    );
  }
}
