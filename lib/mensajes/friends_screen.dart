import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misto/main_screen/main_screen.dart';
import 'package:misto/profile/perfil.dart';
import '../mensajes/mensajes.dart';
import '../profile/perfil2.dart';
import '../user.dart';
import '../message_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendsScreen extends StatelessWidget {
  final Usuario currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot> _userStream;
  FriendsScreen({
    required this.currentUser,
  });

  final Stream<QuerySnapshot> _friendsStream =
  FirebaseFirestore.instance.collection('Users').snapshots();



  @override
  Widget build(BuildContext context) {
    _userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.id)
        .snapshots();
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: _userStream,
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;

                  return Scaffold(
                    backgroundColor: Color.fromRGBO(22, 53, 77, 1.000),
                    body: SafeArea(
                      child: Column(

                        children: [
                          Row(
                            children: [
                              _top(context),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 30.0),
                                child: Material(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(22,53,77,1.000),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => perfil2()),
                                      );
                                    },
                                    child: ClipOval(

                                      child: data?['Avatar'] != null
                                          ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            data?['Avatar']),
                                        radius: 50,
                                      )
                                          : CircleAvatar(
                                        backgroundImage:
                                        AssetImage('assets/avatar_prueba.jpg'),
                                        radius: 50,
                                      ),
                                    ),
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
                },
    ),
    );
  }


  Widget _top(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Row(
            children: [
                Material(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 36.0,
                      color: Color.fromRGBO(22, 53, 77, 1.000),
                    ),
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => main_screen(currentUser: currentUser))),
                  iconSize: 48.0,
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
              Text(
                'Habla con \ntus amigoss',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
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

                    String? lastMessage;
                    if (lastMessageSnapshot.data != null && lastMessageSnapshot.data!['text'] != null) {
                      lastMessage = lastMessageSnapshot.data?['text'];
                    }

                    DateTime? lastMessageTime;
                    if (lastMessageSnapshot.data != null && lastMessageSnapshot.data!['timestamp'] != null) {
                      lastMessageTime = (lastMessageSnapshot.data?['timestamp']
                      as Timestamp?)
                          ?.toDate();
                    }

                    DocumentSnapshot user = snapshot.data!.docs[index];
                    Map<String, dynamic>? userData = user.data() as Map<String, dynamic>?;
                    String? avatarUrl;
                    if (userData != null && userData['Avatar'] != null) {
                      avatarUrl = userData['Avatar'];
                    }

                    DocumentSnapshot friendDoc = snapshot.data!.docs[index];
                    Map<String, dynamic>? friendData = friendDoc.data() as Map<String, dynamic>?;
                    String? fullName;
                    if (friendData != null && friendData['FullName'] != null) {
                      fullName = friendData['FullName'];
                    }

                    return Column(
                      children: [
                        SizedBox(height: 10.0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 15.0,
                          ),
                          leading: avatarUrl != null
                              ? ClipOval(
                            child: Image.network(
                              avatarUrl,
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox.shrink(), // Add some placeholder widget here
                          title: fullName != null ? Text(fullName) : Text('Unknown user'),
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
                        ),
                        // Añade un espacio
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 0.6,
                        ),
                      ],
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