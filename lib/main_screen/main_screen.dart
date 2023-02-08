import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../container/menu.dart';
import '../container/ripple_button.dart';

class main_screen extends StatefulWidget {
  static const String id = 'main_screen';
  const main_screen({Key? key}) : super(key: key);

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(228,229,234,1.000),
      body: Column(
        children: [
          //Mapa
          Expanded(
            child:
              Row(
                children: [
                  Expanded(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 14.5),

                      ),

                  )
                ],
              )
          ),
          //Deslizar amigos
          Container(
            color: Colors.amber,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            child:
              Row()
          ),
          //Boton SOS
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RippleButton(size: 0.3)
              ],
            )
          ),
          //Menu
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child:
                    menu(pagina: 0,)
                )
              ]
          )
        ],
      ),
    );
  }
}
