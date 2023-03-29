import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../container/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import '../acceder/login.dart';
import '../profile/UserDetailScreen.dart';
import '../Amigos/seguir.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  final String selectedUserId;
  final Function(GoogleMapController) onMapCreated;

  MyMap(this.user_id, this.selectedUserId, {required this.onMapCreated});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  GoogleMapController? _controller;
  bool _added = false;

  void _zoomToSelectedUserLocation(LatLng userLocation) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 50.0, // Ajusta el nivel de zoom según tus necesidades
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
          final userExists = snapshot.data!.docs.any((element) => element.id == widget.selectedUserId);

          if (!userExists) {
            return Center(child: Text(widget.selectedUserId));
          }

          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                  position: LatLng(
                    snapshot.data!.docs.singleWhere((element) =>
                    element.id == widget.selectedUserId)['latitude'],
                    snapshot.data!.docs.singleWhere((element) =>
                    element.id == widget.selectedUserId)['longitude'],
                  ),
                  markerId: MarkerId(widget.selectedUserId),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta)),
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  snapshot.data!.docs.singleWhere((element) =>
                  element.id == widget.selectedUserId)['latitude'],
                  snapshot.data!.docs.singleWhere((element) =>
                  element.id == widget.selectedUserId)['longitude'],
                ),
                zoom: 14.47),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              widget.onMapCreated(controller);
            },
          );
        },
      );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) =>
              element.id == widget.selectedUserId)['latitude'],
              snapshot.data!.docs.singleWhere((element) =>
              element.id == widget.selectedUserId)['longitude'],
            ),
            zoom: 14.47)));
  }
}

// main_screen widget
class main_screen extends StatefulWidget {
  static const String id = 'main_screen';
  main_screen({Key? key}) : super(key: key);
  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {

  final Completer<GoogleMapController> _controller = Completer();
  String _selectedUserId = 'user1';
  final ValueNotifier<double> _mapHeight = ValueNotifier(0.3);
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyMap(_selectedUserId, _selectedUserId, onMapCreated: (controller) {
          _mapController = controller;
        }),
        DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Material(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                      children: [
                      SizedBox(height: 10.0), // Espacio en la parte superior del DraggableScrollableSheet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () {
                              // Acción del botón chat
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.person_add),
                            onPressed: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => seguir())),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 300, // Aquí puedes especificar la altura que desees para las tarjetas
                        child: buildConnectedUserCards(),
                      ),
                  ],
              ),
            ),
            ),
            );
          },
        ),
        Positioned(
          top: 50.0,
          right: 30.0,
          child: Material(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            child: IconButton(
              icon: Icon(Icons.person, size: 36.0), // Ajusta el tamaño del icono aquí
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDetailScreen()),
                );
              },
              iconSize: 48.0, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),
        Positioned(
          top: 50.0,
          left: 30.0,
          child: Material(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            child: IconButton(
              icon: Icon(Icons.logout, size: 36.0), // Ajusta el tamaño del icono aquí
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              iconSize: 48.0, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),

      ],
    );
  }

  Widget buildUserList() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Material( // Agrega el widget Material aquí
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['name'].toString()),
                  subtitle: Row(
                    children: [
                      Text(snapshot.data!.docs[index]['latitude'].toString()),
                      SizedBox(
                        width: 20,
                      ),
                      Text(snapshot.data!.docs[index]['longitude'].toString()),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.directions),
                    onPressed: () {
                      setState(() {
                        _selectedUserId = snapshot.data!.docs[index].id;
                      });

                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  void _zoomToSelectedUserLocation(LatLng userLocation) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 15.0, // Ajusta el nivel de zoom según tus necesidades
        ),
      ),
    );
  }



  Widget buildConnectedUserCards() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot user = snapshot.data!.docs[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Row(
                      children: [
                        // Image
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              "assets/avatar_prueba.jpg",
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: MediaQuery.of(context).size.height * 0.20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Text and Map button
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text
                                Text(
                                  user.id,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Map button
                                IconButton(
                                  icon: Icon(Icons.map),
                                  onPressed: () {
                                    setState(() {
                                      _selectedUserId = user.id;
                                    });
                                    LatLng userLocation = LatLng(
                                      snapshot.data!.docs.singleWhere(
                                              (element) => element.id == user.id)['latitude'],
                                      snapshot.data!.docs.singleWhere(
                                              (element) => element.id == user.id)['longitude'],
                                    );
                                    _zoomToSelectedUserLocation(userLocation);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }




// Menu widget
  Widget buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width,
          child: menu(
            pagina: 0,
          ),
        ),
      ],
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('location')
          .doc('user1')
          .set({
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
      await FirebaseFirestore.instance
          .collection('location')
          .doc('user1')
          .set({
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

  Future<Map<String, LatLng>> getUsersWithLocation() async {
    QuerySnapshot<Map<String, dynamic>> users =
    await FirebaseFirestore.instance.collection('location').get();
    Map<String, LatLng> usersWithLocation = {};

    for (var user in users.docs) {
      if (user.data().containsKey('latitude') &&
          user.data().containsKey('longitude')) {
        usersWithLocation[user.id] = LatLng(
          user['latitude'],
          user['longitude'],
        );
      }
    }
    return usersWithLocation;
  }
}