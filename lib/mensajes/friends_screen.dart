import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mensajes/mensajes.dart';
import '../profile/perfil2.dart';
import '../user.dart';
import '../message_utils.dart';

class FriendsScreen extends StatelessWidget {
  final Usuario currentUser;

  FriendsScreen({
    required this.currentUser,
  });

  final Stream<QuerySnapshot> _friendsStream =
  FirebaseFirestore.instance.collection('Users').snapshots();

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
                        Icons.person,
                        size: 36.0,
                        color: Color.fromRGBO(22, 53, 77, 1.000),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => perfil2(
                              currentUser: currentUser,
                            ),
                          ),
                        );
                      },
                      iconSize: 48.0,
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
            'Chat with \nyour friends',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
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
    );
  }
}


class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}