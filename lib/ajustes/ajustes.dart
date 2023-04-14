import 'package:flutter/material.dart';
import '../main_screen/main_screen.dart';
import '../container/menu.dart';
import '../user.dart';

class ajustes extends StatefulWidget {
  final Usuario currentUser;

  const ajustes({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ajustes> createState() => _ajustesState();
}

class _ajustesState extends State<ajustes> {
  @override
  Widget build(BuildContext context) {
    Usuario currentUser = widget.currentUser; // Añade esta línea

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Color.fromRGBO(22,53,77,1.000),
            expandedHeight: 20,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => main_screen(currentUser: currentUser)),
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: Text('Ajustes'),
          ),
          SliverToBoxAdapter(
              child:
              Column(
                children: [
                  Container(
                      color: Colors.amber,
                      height: 800
                  ),
                  Container(
                      color: Colors.black,
                      height: 800
                  ),
                  Container(
                      color: Colors.green,
                      height: 800
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}

