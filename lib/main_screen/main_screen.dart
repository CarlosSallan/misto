import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:misto/mensajes/mensajes.dart';
import 'package:misto/profile/perfil2.dart';
import '../container/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart';
import '../acceder/login.dart';
import '../mensajes/friends_screen.dart';
import '../Amigos/seguirUsers.dart';
import '../user.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  final String selectedUserId;
  final Function(GoogleMapController) onMapCreated;

  MyMap(this.user_id, this.selectedUserId, {required this.onMapCreated});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late Location location;
  GoogleMapController? _controller;
  StreamSubscription<LocationData>? _locationSubscription;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    location = Location();
    _requestLocationPermission().then((status) {
      if (status == ph.PermissionStatus.granted) {
        _initLocationUpdates();
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocationUpdates() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) async {
      await _updateLocationInFirebase(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  Future<void> _updateLocationInFirebase(double latitude, double longitude) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user_id)
        .update({'latitude': latitude, 'longitude': longitude});
  }

  Future<ph.PermissionStatus> _requestLocationPermission() async {
    final status = await ph.Permission.location.request();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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
  final Usuario currentUser;
  main_screen({required this.currentUser});

  @override
  _main_screenState createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {

  final ValueNotifier<double> _mapHeight = ValueNotifier(0.3);
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  late String _selectedUserId;

  @override
  Widget build(BuildContext context) {

    Usuario currentUser = widget.currentUser;

    return Stack(
      children: [
        MyMap(currentUser.id, currentUser.id, onMapCreated: (controller) {
          _mapController = controller;
        }),
        DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          maxChildSize: 0.25,
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
                        SizedBox(height: 20.0),
                    Container(
                      height: 5,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(22,53,77,1.000),
                      ),
                    ),
                          Container(
                            height: 20,
                          ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
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
              icon: Icon(Icons.person, size: 36.0, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => perfil2()),
                );
              },
              iconSize: 48.0, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),
        Positioned(
          top: 130.0,
          right: 30.0,
          child: Material(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            child: IconButton(
              icon: Icon(Icons.message, size: 36.0, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => FriendsScreen(currentUser: currentUser,))),
              iconSize: 48.0, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),
        Positioned(
          top: 210.0,
          right: 30.0,
          child: Material(
            color:  Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            child: IconButton(
              icon: Icon(Icons.person_add, size: 36.0, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => seguirUsers())),
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
              icon: Icon(Icons.logout, size: 36.0, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
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

  Widget buildConnectedUserCards() {
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

    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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
                double latitude = double.parse(
                    snapshot.data!.docs.singleWhere((element) => element.id == user.id)['latitude'].toString());

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                  ClipOval(
                                    child: (user.data() as Map<String, dynamic>).containsKey('Avatar') &&
                                        user['Avatar'] != null ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/MistoLog.png',
                                      image: user['Avatar'],
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/MistoLog.png',
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  SizedBox(width: 20),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['FullName'],
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromRGBO(22, 53, 77, 1.000),
                                        ),
                                      ),

                                      Text(
                                        "${user['latitude'] != null
                                            ? (user['latitude'] is String ?
                                        double.parse(user['latitude']) : user['latitude']).toString() : '0.0'} / "
                                            "${user['longitude'] != null ? (user['longitude'] is String ? double.parse(user['longitude']) : user['longitude']).toString() : '0.0'}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),

                                ]
                            ),

                            SizedBox(height: MediaQuery.of(context).size.width * 0.02),

                            Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                                SizedBox(
                                    height: 50, //height of button
                                    width: 150, //width of button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(22,53,77,1.000),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedUserId = user.id;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 200), () {
                                          double latitude = double.parse(
                                              snapshot.data!.docs.singleWhere((element) => element.id == user.id)['latitude'].toString());
                                          double longitude = double.parse(
                                              snapshot.data!.docs.singleWhere((element) => element.id == user.id)['longitude'].toString());

                                          LatLng userLocation = LatLng(latitude, longitude);
                                          _zoomToSelectedUserLocation(userLocation);
                                        });
                                      }, child: Text('Donde esta?'),
                                    ),
                                ),

                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                                SizedBox(
                                    height: 50,
                                    width: 150,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(22,53,77,1.000),
                                        ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedUserId = user.id;
                                      });
                                      Future.delayed(
                                          Duration(milliseconds: 200), () {
                                        double latitude = double.parse(
                                            snapshot.data!.docs.singleWhere((element) => element.id == user.id)['latitude'].toString());
                                        double longitude = double.parse(
                                            snapshot.data!.docs.singleWhere((element) => element.id == user.id)['longitude'].toString());

                                        LatLng userLocation = LatLng(latitude, longitude);
                                        _zoomToSelectedUserLocation(userLocation);
                                      });
                                    }, child: Text('Chat',
                                    style: TextStyle(
                                    color: Color.fromRGBO(22,53,77,1.000),
                                  ),
                                  ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),

    );
  }
}