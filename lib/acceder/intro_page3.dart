import 'package:flutter/material.dart';
class introPage3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Colors.white,
      child: Center(
          child: Column(
            children: [
              Container(
                height:125,
              ),
              Container(
                child: Image.asset(
                  "assets/maps.png",
                  scale: 1.7,
                ),

              ),
              Container(
                child: Center(
                  child: Text('Conece la ubicacion ',
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
                  child: Text('de tus amigos.',
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