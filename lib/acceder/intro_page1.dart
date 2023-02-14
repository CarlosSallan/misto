import 'package:flutter/material.dart';

import 'dart:math';

class introPage1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      child: Center(
        child: Column(
          children: [
            Container(
              height:125,
            ),
            Container(
              child: Image.asset(
                "assets/welcome.png",
                scale: 2.0,
              ),

            ),
            Container(
              child: Center(
                child: Text('Bienvenido a misto ',

                    style: TextStyle(

                    color: Color.fromRGBO(22,53,77,1.000),
                decoration: TextDecoration.none,
                fontSize: 35.0, fontWeight: FontWeight.bold,

              ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text('disfruta con la comunidad.',
                  style: TextStyle(
                    color: Color.fromRGBO(22,53,77,1.000),
                    decoration: TextDecoration.none,
                    fontSize: 35.0, fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
