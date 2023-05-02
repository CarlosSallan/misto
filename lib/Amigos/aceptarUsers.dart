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
  late bool pantallaSolicitudes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pantallaSolicitudes = true;
      _userStream = getStreamSolicitudes(user?.uid);
    });
  }

  Stream<List<Usuario>> getStreamAmigos(String? uid) {
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

  Future<void> _aceptarUsuario(Usuario userAdded) async {
    crearDocUserAmistad(userAdded, user!);
  }
  Future<void> _eliminarUsuario(Usuario userAdded) async {
    print('Eliminando usuario...');
    eliminarAmigo(userAdded, user!);
  }

  Future<void> eliminarAmigo(Usuario userToRemove, User currentUser) async {
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');
    final currentUserUid = currentUser?.uid;
    final userToRemoveUid = userToRemove?.gettUID;
    print('Eliminando usuario $userToRemoveUid...');

    // Verificar si el usuario actual tiene el documento de Amistad
    final currentUserDoc = await amistadCollection.doc(currentUserUid).get();
    if (!currentUserDoc.exists) {
      // El documento no existe, no hay amigos que eliminar
      print('fallo');
      return;
    }

    // Eliminar al usuarioToRemove del array de amigos del usuario actual
    await amistadCollection.doc(currentUserUid).update({
      'ArrayAmigos': FieldValue.arrayRemove([userToRemoveUid])
    });

    // Verificar si el usuarioToRemove tiene el documento de Amistad
    final userToRemoveDoc = await amistadCollection.doc(userToRemoveUid).get();
    if (!userToRemoveDoc.exists) {
      // El documento no existe, no hay amigos que eliminar
      print('fallo');
      return;
    }

    // Eliminar al usuario actual del array de amigos del usuarioToRemove
    await amistadCollection.doc(userToRemoveUid).update({
      'ArrayAmigos': FieldValue.arrayRemove([currentUserUid])
    });
  }




  Future<void> crearDocUserAmistad(Usuario userAdded, User user) async {
    final amistadCollection = FirebaseFirestore.instance.collection('Amistad');
    final currentUserUid = user?.uid;
    final userAddedUid = userAdded?.gettUID;

    // Verificar si el usuario actual tiene el documento de Amistad
    final currentUserDoc = await amistadCollection.doc(currentUserUid).get();
    if (!currentUserDoc.exists) {
      // El documento no existe, lo creamos con los campos ArrayAmigos y ArraySoli vacíos
      await amistadCollection
          .doc(currentUserUid)
          .set({'ArrayAmigos': [], 'ArraySoli': []});
    }

    // Verificar si el usuarioAdded tiene el documento de Amistad
    final userAddedDoc = await amistadCollection.doc(userAddedUid).get();
    if (!userAddedDoc.exists) {
      // El documento no existe, lo creamos con los campos ArrayAmigos y ArraySoli vacíos
      await amistadCollection
          .doc(userAddedUid)
          .set({'ArrayAmigos': [], 'ArraySoli': []});
    }

    // Verificar si el usuario actual tiene al usuarioAdded en el array de solicitudes
    final currentUserSoliList =
        currentUserDoc.data()?['ArraySoli'] ?? <String>[];
    if (currentUserSoliList.contains(userAddedUid)) {
      // El usuarioAdded está en el array de solicitudes del usuario actual, lo eliminamos del array
      await amistadCollection.doc(currentUserUid).update({
        'ArraySoli': FieldValue.arrayRemove([userAddedUid])
      });
      // Añadimos al usuarioAdded en el array de amigos del usuario actual

      await amistadCollection.doc(currentUserUid).update({
        'ArrayAmigos': FieldValue.arrayUnion([userAddedUid])
      });
    }

    // Verificar si el usuarioAdded tiene al usuario actual en el array de solicitudes
    final userAddedSoliList = userAddedDoc.data()?['ArraySoli'] ?? <String>[];
    // El usuario actual está en el array de solicitudes del usuarioAdded, lo eliminamos del array
    await amistadCollection.doc(userAddedUid).update({
      'ArraySoli': FieldValue.arrayRemove([currentUserUid])
    });
    // Añadimos al usuario actual en el array de amigos del usuarioAdded
    print('Agregando a tus amigos');
    await amistadCollection.doc(userAddedUid).update({
      'ArrayAmigos': FieldValue.arrayUnion([currentUserUid])
    });

    /*
    // Esperar un poco antes de llamar a la función anyadirSolicitud
    await Future.delayed(Duration(seconds: 3));
    anyadirSolicitud(user!, userAdded);

     */
  }

  Widget _buildUserListItemAmigo(Usuario user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.FullName.substring(0, 2)),
      ),
      title: Text(user.FullName),
      subtitle: Text(user.FullName),
      trailing: ElevatedButton(
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _eliminarUsuario(user);
            });
          },
        ),
        onPressed: () {

        },
      ),
    );
  }

  Widget _buildUserListItem(Usuario user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.FullName.substring(0, 2)),
      ),
      title: Text(user.FullName),
      subtitle: Text(user.FullName),
      trailing: ElevatedButton(
        child: Text('Aceptar'),
        onPressed: () {
          setState(() {
            _aceptarUsuario(user);
          });
        },
      ),
    );
  }

  Widget _buildUserListAmigo(List<Usuario> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItemAmigo(user);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color.fromRGBO(228, 229, 234, 1.000),
        title: Text(
          'Social',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      pantallaSolicitudes = true;
                      _userStream = getStreamSolicitudes(user?.uid);
                    });
                  },
                  child: Text('Solicitudes')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      pantallaSolicitudes = false;
                      _userStream = getStreamAmigos(user?.uid);
                    });
                  },
                  child: Text('Amigos'))
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Usuario>>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (pantallaSolicitudes) {
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
                } else {
                  if (snapshot.hasData && pantallaSolicitudes == false) {
                    final users = snapshot.data!;
                    return _buildUserListAmigo(users);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
