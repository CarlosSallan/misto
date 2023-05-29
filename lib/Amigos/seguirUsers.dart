import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_screen/main_screen.dart';
import 'models/Usuario.dart';

class seguirUsers extends StatefulWidget {
  seguirUsers({Key? key}) : super(key: key);

  @override
  State<seguirUsers> createState() => _seguirUsersState();
}

class _seguirUsersState extends State<seguirUsers> {
  final User? user = FirebaseAuth.instance.currentUser;
  late Stream<List<Usuario>> _userStream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _userStream = userStream();
    });
  }

  Stream<List<Usuario>> userStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    User? currentUser = FirebaseAuth.instance.currentUser;
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUser?.uid) // Excluir el usuario actual
          .map((doc) {
        final fullName = doc.data()['FullName'] as String;
        final image = doc.data()?['Avatar'] as String;

        return Usuario(fullName, doc.id, true, image);
      }).toList();
    }

    );



  }

  Future<bool> compruebaSeguir(String amigoId) async {
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');

    // Verificar si el usuario actual tiene el documento de Amistad
    final currentUserDoc = await amistadCollection.doc(user?.uid).get();
    if (!currentUserDoc.exists) {
      // El documento no existe, por lo que no está siguiendo a nadie
      return false;
    }

    // Verificar si el usuario actual sigue al usuario pasado por parámetro
    final currentUserAmigosList = currentUserDoc.data()?['ArrayAmigos'] ?? <String>[];
    if (currentUserAmigosList.contains(amigoId)) {
      // El usuario actual sigue al usuario pasado por parámetro
      return true;
    } else {
      // El usuario actual no sigue al usuario pasado por parámetro
      return false;
    }
  }
  Future<bool> checkIfValueExistsInUserArray( String value) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('Amistad');
    final querySnapshot =
    await userRef.where('uid', isEqualTo: currentUser?.uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final user = querySnapshot.docs.first.data();
      return true;
      /*
      if (user.containsKey('arrayAmigos') && user['arrayField'].contains(value)) {
        return true;
      }

       */
    }

    return false;
  }




  Future<void> _followUser(Usuario userAdded) async {
    final user = FirebaseAuth.instance.currentUser;
    crearDocUserAmistad(userAdded, user!);
  }
  Future<void> crearDocUserAmistad(Usuario userAdded, User user) async {
    FirebaseFirestore.instance.collection('Amistad').doc(userAdded?.gettUID).get().then((docSnapshot) {
      if (!docSnapshot.exists) {
        // El documento no existe, lo creamos
        FirebaseFirestore.instance.collection('Amistad').doc(userAdded?.gettUID).set({
          'ArrayAmigos': [],
          'ArraySoli': []
        }).then((_) {
          // Documento creado con éxito
          print('Documento creado con éxito.');
        }).catchError((error) {
          // Error al crear el documento
          print('Error al crear el documento: $error');
        });
      } else {
        // El documento ya existe, verificamos si los campos existen
        if (docSnapshot.data()!['ArrayAmigos'] == null) {
          // El campo ArrayAmigos no existe, lo creamos
          FirebaseFirestore.instance.collection('Amistad').doc(userAdded?.gettUID).update({
            'ArrayAmigos': []
          }).then((_) {
            // Campo creado con éxito
            print('Campo ArrayAmigos creado con éxito.');
          }).catchError((error) {
            // Error al crear el campo
            print('Error al crear el campo ArrayAmigos: $error');
          });
        }
        if (docSnapshot.data()!['ArraySoli'] == null) {
          // El campo ArraySoli no existe, lo creamos
          FirebaseFirestore.instance.collection('Amistad').doc(userAdded?.gettUID).update({
            'ArraySoli': []
          }).then((_) {
            // Campo creado con éxito
            print('Campo ArraySoli creado con éxito.');
          }).catchError((error) {
            // Error al crear el campo
            print('Error al crear el campo ArraySoli: $error');
          });
        }
      }
    }).catchError((error) {
      // Error al obtener el documento
      print('Error al obtener el documento: $error');
    });
    await Future.delayed(Duration(seconds: 3));
    anyadirSolicitud(user!, userAdded);
  }
  void anyadirSolicitud(User user, Usuario userAdded){

    final docRef = FirebaseFirestore.instance.collection('Amistad').doc(userAdded?.gettUID);
    String? userUid = user?.uid;
    String userAddedUid = userAdded?.gettUID;
    print('Añadiendo $userUid a $userAddedUid');
    docRef.update({'ArraySoli': FieldValue.arrayUnion([user?.uid])});
  }

  Widget _buildUserListItem(Usuario user) {
    return FutureBuilder<bool>(
      future: compruebaSeguir(user.gettUID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool sigue = snapshot.data!;
          return ListTile(
            leading: ClipOval(
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
            title: Text(user.FullName),
            subtitle: Text(user.FullName),
            trailing: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(22,53,77,1.000)), // Establece el color del botón aquí
              ),
              child: Text(sigue ? 'Siguiendo' : 'Seguir'),
              onPressed: () {
                setState(() {
                  _followUser(user);
                });
              },
            ),
          );
        } else if (snapshot.hasError) {
          // Manejar errores
          return CircularProgressIndicator();
        } else {
          // Mostrar un indicador de progreso
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildUserList(List<Usuario> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user);
      },
    );
  }

  List<Usuario> _filterUsers(List<Usuario> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users
          .where((user) =>
              user.FullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Stream<List<Usuario>> _getUsersStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final fullName = doc.data()['FullName'] as String;
        final image = doc.data()?['Avatar'] as String;
        /*
        final username = doc.data()['Username'] as String;
        final isFollowing = doc.data()['isFollowing'] as bool;
         */
        return Usuario(fullName, doc.id,false, image);
      }).toList();
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar usuarios...',
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              _userStream = _getUsersStream();
            });
          },
        ),
      ),
      onChanged: (query) {
        setState(() {
          _userStream =
              _getUsersStream().map((users) => _filterUsers(users, query));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 53, 77, 1.000),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                _top(),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 30.0),
                  child: Material(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.home,
                        size: MediaQuery.of(context).size.height * 0.04,
                        color: Color.fromRGBO(22, 53, 77, 1.000),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: MediaQuery.of(context).size.height * 0.05,
                      padding: EdgeInsets.all(8.0),
                    ),
                  ),
                ),
              ],
            ),

            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Haz nuevos \namigos',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 55,
              ),

            ],
          ),


        ],


      ),
    );
  }
  Widget _body() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: StreamBuilder<List<Usuario>>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return _buildUserList(users);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
