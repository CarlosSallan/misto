import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/Usuario.dart';

class aceptarUsers extends StatefulWidget {
  aceptarUsers({Key? key}) : super(key: key);

  @override
  State<aceptarUsers> createState() => _aceptarUsersState();
}

class _aceptarUsersState extends State<aceptarUsers> {
  late Stream<List<Usuario>> _userStream;
  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _userStream = getStreamSolicitudes(user?.uid);
    });
  }

  Stream<List<Usuario>> userStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    User? currentUser = FirebaseAuth.instance.currentUser;
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) =>
      doc.id != currentUser?.uid) // Excluir el usuario actual
          .map((doc) {
        final fullName = doc.data()['FullName'] as String;
        return Usuario(fullName, doc.id, true);
      }).toList();
    }

    );
  }

  Stream<List<Usuario>> getStreamSolicitudes(String? uid) {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');

    return amistadCollection.doc(uid).get().asStream().map((doc) {
      final ArraySoli = (doc.data() ?? {})['ArraySoli'] as List<dynamic>?;
      if (ArraySoli == null || ArraySoli.isEmpty) {
        return []; // si no hay solicitudes pendientes, devuelve una lista vacía
      } else {
        return ArraySoli; // devuelve la lista de uid de los usuarios con solicitudes pendientes
      }
    }).asyncMap((soliList) async {
      final userList = <Usuario>[]; // lista de usuarios a devolver

      for (final uid in soliList) {
        final userDoc = await userCollection.doc(uid).get();
        if (userDoc.exists) {
          final fullName = userDoc.data()?['FullName'] as String?;
          if (fullName != null) {
            userList.add(Usuario(fullName, uid, true));
          }
        }
      }

      return userList; // devuelve la lista final de usuarios
    });
  }

  Future<bool> checkIfValueExistsInUserArray(String value) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('Amistad');
    final querySnapshot =
    await userRef.where('uid', isEqualTo: currentUser?.uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }

    return false;
  }


  Future<void> _followUser(Usuario userAdded) async {
    final user = FirebaseAuth.instance.currentUser;
    crearDocUserAmistad(userAdded, user!);
  }

  Future<void> crearDocUserAmistad(Usuario userAdded, User user) async {
    FirebaseFirestore.instance.collection('Amistad')
        .doc(userAdded?.gettUID)
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        // El documento no existe, lo creamos
        FirebaseFirestore.instance.collection('Amistad')
            .doc(userAdded?.gettUID)
            .set({
          'ArrayAmigos': [],
          'ArraySoli': []
        })
            .then((_) {
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
          FirebaseFirestore.instance.collection('Amistad').doc(
              userAdded?.gettUID).update({
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
          FirebaseFirestore.instance.collection('Amistad').doc(
              userAdded?.gettUID).update({
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

  void anyadirSolicitud(User user, Usuario userAdded) {
    final docRef = FirebaseFirestore.instance.collection('Amistad').doc(
        userAdded?.gettUID);
    String? userUid = user?.uid;
    String userAddedUid = userAdded?.gettUID;
    print('Añadiendo $userUid a $userAddedUid');
    docRef.update({'ArraySoli': FieldValue.arrayUnion([user?.uid])});
  }

  Widget _buildUserListItem(Usuario user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.FullName.substring(0, 2)),
      ),
      title: Text(user.FullName),
      subtitle: Text(user.FullName),
      trailing: ElevatedButton(
        child: Text(user.isFollowing ? 'Siguiendo' : 'Aceptar'),
        onPressed: () {
          setState(() {
            _followUser(user);
          });
        },
      ),
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
        return Usuario(fullName, doc.id, false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 153, 195, 1.000),
        title: Text('Aceptar solicitudes.'),
      ),
      body: Column(
        children: [
          Expanded(
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
        ],
      ),
    );
  }
}