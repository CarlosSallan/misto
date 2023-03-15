import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class userConected extends StatelessWidget {
  const userConected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(228, 229, 234, 1.000),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 6,
            child:ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset(
                "assets/avatar_prueba.jpg",
                scale: 0.1,
              ),
            )
            ),
        Expanded(flex: 1, child: Text(
          'Pepito',
          style: TextStyle(fontSize: 20.0),
        )),
      ],
    ));
  }
}
