import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/Usuario.dart';

class seguirUsers extends StatefulWidget {
  seguirUsers({Key? key}) : super(key: key);

  @override
  State<seguirUsers> createState() => _seguirUsersState();
}

class _seguirUsersState extends State<seguirUsers> {
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

        return Usuario(fullName, true);
      }).toList();
    }

    );



  }

  Stream<List<Usuario>> amistadCheckUser() {
    /* conseguir el true false de seguir */
    final userCollection = FirebaseFirestore.instance.collection('Users');
    User? currentUser = FirebaseAuth.instance.currentUser;
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUser?.uid) // Excluir el usuario actual
          .map((doc) {
        final fullName = doc.data()['FullName'] as String;

        return Usuario(fullName, true);
      }).toList();
    }

    );



  }




  void _followUser(Usuario user) {





    /*
    // Actualizar el documento del usuario en Firestore para marcar que el usuario actual lo está siguiendo
    FirebaseFirestore.instance.collection('Users').doc(user.username).update({'isFollowing': true});

     */
  }

  Widget _buildUserListItem(Usuario user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.FullName.substring(0, 2)),
      ),
      title: Text(user.FullName),
      subtitle: Text(user.FullName),
      trailing: ElevatedButton(
        child: Text(user.isFollowing ? 'Siguiendo' : 'Seguir'),
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
        /*
        final username = doc.data()['Username'] as String;
        final isFollowing = doc.data()['isFollowing'] as bool;
         */
        return Usuario(fullName, false);
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
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 153, 195, 1.000),
        title: Text('Seguir usuarios'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
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
