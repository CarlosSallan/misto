import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';

class seguirUsers extends StatefulWidget {
  seguirUsers({Key? key}) : super(key: key);

  @override
  State<seguirUsers> createState() => _seguirUsersState();
}

class _seguirUsersState extends State<seguirUsers> {
  late Stream<List<User>> _userStream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

      _userStream = userStream();
    });
  }

  Stream<List<User>> userStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final fullName = doc.data()['FullName'] as String;
        return User(fullName, false);
      }).toList();
    });
  }

  void _followUser(User user) {
    /*
    // Actualizar el documento del usuario en Firestore para marcar que el usuario actual lo está siguiendo
    FirebaseFirestore.instance.collection('Users').doc(user.username).update({'isFollowing': true});

     */
  }

  Widget _buildUserListItem(User user) {
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

  Widget _buildUserList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user);
      },
    );
  }

  List<User> _filterUsers(List<User> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users.where((user) => user.FullName.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Stream<List<User>> _getUsersStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final fullName = doc.data()['FullName'] as String;
        /*
        final username = doc.data()['Username'] as String;
        final isFollowing = doc.data()['isFollowing'] as bool;
         */
        return User(fullName, false);
      }).toList();
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar usuarios...',
      ),
      onChanged: (query) {
        setState(() {
          _userStream = _getUsersStream().map((users) => _filterUsers(users, query));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguir usuarios'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<List<User>>(
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
