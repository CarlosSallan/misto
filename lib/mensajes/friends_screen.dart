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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Color.fromRGBO(22, 53, 77, 1.0),
              child: Center(
                child: Text(
                  'Conversaciones',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
                left: 0,
                right: 0,
                top: 200,
                bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _friendsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Filtrar al usuario actual de la lista de amigos
                  final friends = snapshot.data!.docs
                      .where((userDoc) => userDoc.id != currentUser.id);

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
                            return ListTile(
                                title: Text('Error: ${lastMessageSnapshot.error}'));
                          }

                          if (lastMessageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(title: Text('Cargando...'));
                          }

                          String? lastMessage = lastMessageSnapshot.data?['text'];
                          DateTime? lastMessageTime = (lastMessageSnapshot.data?['timestamp']
                          as Timestamp?)
                              ?.toDate();

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://cdn3d.iconscout.com/3d/premium/thumb/happy-girl-7962207-6451736.png?f=webp"),
                              backgroundColor: Color.fromRGBO(22, 53, 77, 1.000),
                            ),
                            title: Text(friendDoc['FullName']),
                            subtitle: lastMessage == null
                                ? Text('No hay mensajes')
                                : Text(
                                '$lastMessage (${lastMessageTime.toString()})'),
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
            ),
            ),

          ],
        ),
      ),
    );
  }
}
