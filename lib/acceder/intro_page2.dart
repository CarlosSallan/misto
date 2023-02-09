import 'package:flutter/material.dart';
class introPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Center(
            child: Column(
              children: [
                Container(
                  height:125,
                ),
                Container(
                  child: Image.asset(
                    "assets/frends.png",
                    scale: 2.0,
                  ),

                ),
                Container(
                  child: Center(
                    child: Text('Podras añadir a sus amigos ',
                      style: TextStyle(
                          color: Color.fromRGBO(22,53,77,1.000),
                          decoration: TextDecoration.none,
                          fontSize: 35.0, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('para poder chatear con ellos.',
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
      ),
    );
  }
}