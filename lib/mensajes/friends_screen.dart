import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mensajes/mensajes.dart';
import '../main_screen/main_screen.dart';
import '../user.dart';
import '../message_utils.dart';

class FriendsScreen extends StatelessWidget {
  final Usuario currentUser;

  FriendsScreen({
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
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

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              DocumentSnapshot friendDoc = friends.elementAt(index);
              String chatId = currentUser.id.compareTo(friendDoc.id) < 0
                  ? '${currentUser.id}-${friendDoc.id}'
                  : '${friendDoc.id}-${currentUser.id}';

              return StreamBuilder<Map<String, dynamic>?>(
                stream: getLastMessageAndTime(chatId),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>?> lastMessageSnapshot) {
                  if (lastMessageSnapshot.hasError) {
                    return ListTile(title: Text('Error: ${lastMessageSnapshot.error}'));
                  }

                  if (lastMessageSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Cargando...'));
                  }

                  String? lastMessage = lastMessageSnapshot.data?['text'];
                  DateTime? lastMessageTime =
                  (lastMessageSnapshot.data?['timestamp'] as Timestamp?)?.toDate();

                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage("https://cdn3d.iconscout.com/3d/premium/thumb/happy-girl-7962207-6451736.png?f=webp"),
                      backgroundColor: Color.fromRGBO(22,53,77,1.000),
                        ),
                    title: Text(friendDoc['FullName']),
                    subtitle: lastMessage == null
                        ? Text('No hay mensajes')
                        : Text('$lastMessage (${lastMessageTime.toString()})'),
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
                },
              );
            },
          );
        },
      ),
    );
  }
}
