import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
            tabs: const [
              GButton(
                  icon: Icons.logout,
                      text:'Inicio',
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
