import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mensajes/mensajes.dart';
import '../main_screen/main_screen.dart';
import '../user.dart';

class FriendsScreen extends StatelessWidget {
  final Usuario currentUser;

  FriendsScreen({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // Usuario currentUser = widget.currentUser; // Elimina esta línea
    final Stream<QuerySnapshot> _friendsStream =
    FirebaseFirestore.instance.collection('Users').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de amigos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _friendsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Filtrar al usuario actual de la lista de amigos
          final friends = snapshot.data!.docs.where((userDoc) => userDoc.id != currentUser.id);

          return ListView(
            children: friends.map((DocumentSnapshot friendDoc) {
              return ListTile(
                title: Text(friendDoc.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => mensajes(
                        currentUser: currentUser,
                        friendUser: friendDoc,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
