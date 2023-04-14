import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../container/menu.dart';
import '../container/ripple_button.dart';
import '../user.dart';

class dashboard extends StatefulWidget {
  final Usuario currentUser;

  dashboard({required this.currentUser});
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    Usuario currentUser = widget.currentUser;
    return  Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, color: Color.fromRGBO(22,53,77,1.000), size: 50.0,),
                  Image.asset("assets/dashboard/hombre.png", width: 50.0),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(18.0),
              child: Text(
                "Dashboard Misto",
                style: TextStyle(
                  color: Color.fromRGBO(22,53,77,1.000),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start
                ,
              ),
            ),
            Container(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    SizedBox(
                      width: 700.0,
                      height: 360.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/chat.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/chat.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/mensaje.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/chat.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/chat.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    SizedBox(
                      width: 260.0,
                      height: 260.0,
                      child: Card(
                        color: Color.fromRGBO(22,53,77,1.000),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10000)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset("assets/dashboard/chat.png",width: 64, ),
                                SizedBox(height: 10.0),
                                Text("Maps", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),),
                                SizedBox(height: 5.0),
                                Text("2 Items", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ),

            Container(
              height: 60,
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width,
                      child:
                      menu(pagina: 0, currentUser: widget.currentUser,)
                  )
                ]
            )
          ],
        ),
      ),
    );
  }
}
