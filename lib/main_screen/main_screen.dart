import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart' as Loca;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:misto/mensajes/mensajes.dart';
import 'package:misto/profile/perfil2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../acceder/login.dart';
import '../container/ripple_button.dart';
import '../mensajes/friends_screen.dart';
import '../Amigos/seguirUsers.dart';
import 'models/Usuario.dart' as UserApp;
import '../user.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  final String selectedUserId;
  final Function(GoogleMapController) onMapCreated;
  Set<Marker> mmarkers = {};

  MyMap(this.user_id, this.selectedUserId, this.mmarkers, {required this.onMapCreated});

  @override
  _MyMapState createState() => _MyMapState();
}


class _MyMapState extends State<MyMap> {
  late Loca.Location location;
  GoogleMapController? _controller;
  StreamSubscription<Loca.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    location = Loca.Location();
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

    _locationSubscription = location.onLocationChanged.listen((Loca.LocationData currentLocation) async {
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
          markers: widget.mmarkers,
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
}

// main_screen widget
class main_screen extends StatefulWidget {
  final Usuario currentUser;
  main_screen({required this.currentUser});

  @override
  _main_screenState createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {

  final Loca.Location location = Loca.Location();
  GoogleMapController? _mapController;
  late String _selectedUserId;
  late DocumentSnapshot friend;
  late Stream<List<UserApp.Usuario>> _userStream;

  Set<Marker> _markers = {};
  bool? _serviceEnabled;
  Loca.LocationData? _locationData;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _userStream = getStreamAmigos(user?.uid);

    _getLocation().then((locationData) {
      if (locationData != null) {
        _zoomToSelectedUserLocation(LatLng(locationData.latitude!, locationData.longitude!));
      }
    });

  }

  Future<Loca.LocationData?> _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }


  Stream<List<UserApp.Usuario>> getStreamAmigos(String? uid) {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');

    return amistadCollection.doc(uid).get().asStream().map((doc) {
      final ArraySoli = (doc.data() ?? {})['ArrayAmigos'] as List<dynamic>?;
      if (ArraySoli == null || ArraySoli.isEmpty) {
        return []; // si no hay solicitudes pendientes, devuelve una lista vacía
      } else {
        return ArraySoli; // devuelve la lista de uid de los usuarios con solicitudes pendientes
      }
    }).asyncMap((soliList) async {
      final userList = <UserApp.Usuario>[]; // lista de usuarios a devolver

      for (final uid in soliList) {
        final userDoc = await userCollection.doc(uid).get();
        if (userDoc.exists) {
          final fullName = userDoc.data()?['FullName'] as String;

          final double latitude = double.parse(userDoc.data()!['latitude'].toString());
          final double longitude = double.parse(userDoc.data()!['longitude'].toString());
          final String image = userDoc.data()!['Avatar'];
          final String email = userDoc.data()!['Email'];

          print('El URL del avatar de $fullName es $image');
          print('El email es $email');
          if (fullName != null) {
            userList.add(UserApp.Usuario(fullName, uid, true, latitude, longitude, image, email));
          }
        }
      }

      return userList; // devuelve la lista final de usuarios
    });
  }

  @override
  Widget build(BuildContext context) {

    Usuario currentUser = widget.currentUser;

    return Stack(
      children: [
        MyMap(currentUser.id, currentUser.id, _markers, onMapCreated: (controller) {
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
              icon: Icon(Icons.person, size: MediaQuery.of(context).size.height * 0.04, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => perfil2()),
                );
              },
              iconSize: MediaQuery.of(context).size.height * 0.05, // Ajusta el tamaño del botón aquí
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
              icon: Icon(Icons.message, size: MediaQuery.of(context).size.height * 0.04, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => FriendsScreen(currentUser: currentUser,))),
              iconSize: MediaQuery.of(context).size.height * 0.05, // Ajusta el tamaño del botón aquí
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
              icon: Icon(Icons.person_add, size: MediaQuery.of(context).size.height * 0.04, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => seguirUsers())),
              iconSize: MediaQuery.of(context).size.height * 0.05, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),

        Positioned(
          top: 50.0,
          right: 90.0,
          child: Material(
            color:  Colors.white.withOpacity(0.0),
            borderRadius: BorderRadius.circular(10.0),
            child: IconButton(
              icon: Icon(Icons.man, size: MediaQuery.of(context).size.height * 0.04, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () async {
                Loca.Location location = new Loca.Location();
                Loca.LocationData _locationData;

                _locationData = await location.getLocation();
                double latitude = _locationData.latitude!;
                double longitude = _locationData.longitude!;

                LatLng userLocation = LatLng(latitude, longitude);
                _zoomToSelectedUserLocation(userLocation);

              },
              iconSize: MediaQuery.of(context).size.height * 0.05, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.27,
          right: 30.0,
          child: Material(
            color:  Colors.white.withOpacity(0.0),
            borderRadius: BorderRadius.circular(10.0),
            child: Container( // ajusta el ancho según tus necesidades
              child: RippleButton(size: 0.12),
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
              icon: Icon(Icons.logout, size: MediaQuery.of(context).size.height * 0.04, color: Color.fromRGBO(22,53,77,1.000),), // Ajusta el tamaño del icono aquí
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              iconSize: MediaQuery.of(context).size.height * 0.05, // Ajusta el tamaño del botón aquí
              padding: EdgeInsets.all(8.0), // Ajusta el padding para aumentar el área de toque del botón
            ),
          ),
        ),

      ],
    );
  }

  void _zoomToSelectedUserLocation(LatLng userLocation) async {
    // Crear un nuevo marcador con la ubicación del usuario
    final Marker userMarker = Marker(
      markerId: MarkerId(widget.currentUser.id),
      position: userLocation,
    );

    // Actualiza el conjunto de marcadores del mapa
    setState(() {
      _markers.add(userMarker);
    });

    // Mover la cámara del mapa a la ubicación del usuario
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
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<UserApp.Usuario>>(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<List<UserApp.Usuario>> snapshot) {
          if (snapshot.hasError) {
            return Text('');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<UserApp.Usuario> userList = snapshot.data ?? [];

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserApp.Usuario? user = snapshot.data?.elementAt(index);
                /*
                double latitude = double.parse(
                    snapshot.data!.docs.singleWhere((element) => element.id == user.id)['latitude'].toString());

                 */

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
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
                                    child: user?.image != null
                                        ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          user?.image as String),
                                      radius: MediaQuery.of(context).size.height * 0.03,
                                    )
                                        : CircleAvatar(
                                      backgroundImage:
                                      AssetImage('assets/MistoLogo.png',),
                                      radius: MediaQuery.of(context).size.height * 0.03,
                                    ),
                                  ),

                                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user?.FullName ?? "Usuario"}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * 0.025,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromRGBO(22, 53, 77, 1.000),
                                        ),
                                      ),
                                      Text(
                                        "${user?.longitude.toString()} / "
                                            "${user?.latitude.toString()}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * 0.015,
                                        ),
                                      ),
                                    ],
                                  ),


                                ]
                            ),

                            SizedBox(height: MediaQuery.of(context).size.width * 0.02),

                            Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.04, //height of button
                                    width: MediaQuery.of(context).size.height * 0.12, //width of button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(22,53,77,1.000),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedUserId = user?.UID ?? "No hay UID";
                                        });

                                        Future.delayed(
                                            Duration(milliseconds: 200), () {
                                          double latitude = user?.latitude ?? 1.0;
                                          double longitude = user?.longitude ?? 2.0;
                                          double? latitud = user?.latitude;
                                          double? longitud = user?.longitude;
                                          print("La longitude es: $latitud  // $longitud");
                                          LatLng userLocation = LatLng(latitude, longitude);
                                          _zoomToSelectedUserLocation(userLocation);
                                        });

                                      }, child: Text('En mapa',
                                      style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.012,
                                    ),),
                                    ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.04, //height of button
                                  width: MediaQuery.of(context).size.height * 0.12,
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
                                      final String? uid = user?.UID;

                                      if (uid != null) {
                                        FirebaseFirestore.instance.collection('Users').doc(uid).get().then((DocumentSnapshot snapshot) {
                                          setState(() {
                                            friend = snapshot;
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => mensajes(currentUser: widget.currentUser, UidAmigo: uid)),
                                          );
                                        });
                                      } else {
                                        print('No user UID found, sorry');
                                      }
                                    }, child: Text('Chat',
                                    style: TextStyle(
                                    color: Color.fromRGBO(22,53,77,1.000),
                                      fontSize: MediaQuery.of(context).size.height * 0.012,
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