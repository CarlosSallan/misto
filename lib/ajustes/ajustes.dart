import 'package:flutter/material.dart';
import '../main_screen/main_screen.dart';
import '../container/menu.dart';

class ajustes extends StatefulWidget {
  const ajustes({Key? key}) : super(key: key);
  @override
  State<ajustes> createState() => _ajustesState();
}


class _ajustesState extends State<ajustes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Color.fromRGBO(22,53,77,1.000),
          expandedHeight: 20,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Text('Ajustes'),
        ),

        SliverToBoxAdapter(
          child: Container(
            height: 660,
            color: Colors.green,
          ),
        )


      ],
    ),


    );
  }
}
