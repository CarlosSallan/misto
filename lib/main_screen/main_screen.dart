import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../container/menu.dart';
import '../container/ripple_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import '../container/userConected.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (_added) {
              mymap(snapshot);
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                    position: LatLng(
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['longitude'],
                    ),
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta)),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['latitude'],
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['longitude'],
                  ),
                  zoom: 14.47),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            );
          },
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
        ),
        zoom: 14.47)));
  }
}

class main_screen extends StatefulWidget {
  static const String id = 'main_screen';
  main_screen({Key? key}) : super(key: key);

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
    final Completer<GoogleMapController> _controller = Completer();
    String _selectedUserId = 'user1'; // Asigna un valor predeterminado válido.

    final loc.Location location = loc.Location();
    StreamSubscription<loc.LocationData>? _locationSubscription;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(228, 229, 234, 1.000),
            body: Column(
            children: [
            Expanded(
              child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('location')
                  .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                  }
                    return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                        return ListTile(
                        title: Text(
                        snapshot.data!.docs[index]['name'].toString()),
                          subtitle: Row(
                          children: [
                            Text(snapshot.data!.docs[index]['latitude']
                                .toString()),
                            SizedBox(
                              width: 20,
                            ),
                            Text(snapshot.data!.docs[index]['longitude']
                                .toString()),
                          ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              setState(() {
                                _selectedUserId =
                                    snapshot.data!.docs[index].id;
                              });
                            },
                          ),
                        );
                    });
                },
          ),
      ),
      // Agrega el widget MyMap y utiliza la variable _selectedUserId
      Expanded(
        child: MyMap(_selectedUserId),
      ),
          //Deslizar amigos
          Container(
            color: Color.fromRGBO(22,53,77,1.000),
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.height * 0.20,
                          child: userConected(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                    height: MediaQuery.of(context).size.height * 0.13,
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
  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'john'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'john'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

