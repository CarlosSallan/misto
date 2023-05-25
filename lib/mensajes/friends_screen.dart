import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misto/main_screen/main_screen.dart';
import 'package:misto/profile/perfil.dart';
import '../mensajes/mensajes.dart';
import '../profile/perfil2.dart';
import '../user.dart' as UsuarioLogin;
import '../message_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Amigos/models/Usuario.dart' as UsuarioApp;

class FriendsScreen extends StatelessWidget {
  final UsuarioLogin.Usuario currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot> _userStream;
  FriendsScreen({
    required this.currentUser,
  });

  late final Stream<List<UsuarioApp.Usuario>> _friendsStream;


  Stream<List<UsuarioApp.Usuario>> getStreamAmigos(String? uid) {
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
      final userList = <UsuarioApp.Usuario>[]; // lista de usuarios a devolver
      for (final uid in soliList) {
        final userDoc = await userCollection.doc(uid).get();
        if (userDoc.exists) {
          final fullName = userDoc.data()?['FullName'] as String?;
          final image = userDoc.data()?['Avatar'] as String?;

          if (fullName != null && image != null) {
            userList.add(UsuarioApp.Usuario(fullName, uid, true, image));
          }
        }
      }

      return userList; // devuelve la lista final de usuarios
    });
  }


  @override
  Widget build(BuildContext context) {
    _friendsStream =
        getStreamAmigos(user?.uid);
    _userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.id)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => perfil2()),
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03,), // adjust this value as per your need
                                child: Text(
                                  'Hola, ' + (data!['FullName'] as String),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 8.0), // Add some spacing between the text and the image
                              ClipOval(
                                child: data?['Avatar'] != null
                                    ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      data!['Avatar'] as String),
                                  radius: MediaQuery.of(context).size.height * 0.03,
                                )
                                    : CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/MistoLogo.png',),
                                  radius: MediaQuery.of(context).size.height * 0.03,
                                ),
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            primary: Color.fromRGBO(22, 53, 77, 1.000),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
          Row(
            children: [
                Material(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: MediaQuery.of(context).size.height * 0.035,
                      color: Color.fromRGBO(22, 53, 77, 1.000),
                    ),
                  onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => main_screen(currentUser: currentUser))),
                  iconSize: MediaQuery.of(context).size.height * 0.035,
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.025,),
              Text(
                'Habla con \ntus amigos',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.023, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
        ],

      ),
    );
  }

  Widget _buildUserListItem(UsuarioApp.Usuario user, BuildContext context) {
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
      trailing: Icon( Icons.chat_rounded
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mensajes(
              currentUser: currentUser,
              UidAmigo: user.gettUID,
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserList(List<UsuarioApp.Usuario> users, BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user, context);
      },
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: Colors.white,
        ),
        child: StreamBuilder<List<UsuarioApp.Usuario>>(
          stream: _friendsStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<UsuarioApp.Usuario>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data!;

            return _buildUserList(users, context);
          },
        ),
      ),
    );
  }
}

/*
ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                String? friendDoc = user?.uid;

                String chatId = currentUser.id.compareTo(friendDoc!) < 0
                    ? '${currentUser.id}-${friendDoc}'
                    : '${friendDoc}-${currentUser.id}';

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

                    return InkWell(
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
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 15.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/MistoLogo.png',
                                    image: avatarUrl ??
                                        'https://firebasestorage.googleapis.com/v0/b/misto-22442.appspot.com/o/avatars%2FMistoLogo.png?alt=media&token=1df83d6e-a913-4ef4-90a0-c4b5f9d7f8e0',
                                    width: MediaQuery.of(context).size.width *
                                        0.1, // Cambia el tamaño aquí
                                    height: MediaQuery.of(context).size.width *
                                        0.1, // Cambia el tamaño aquí
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10.0), // Add some spacing
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      fullName != null ? fullName : 'Unknown user',
                                      style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.width * 0.03,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromRGBO(22, 53, 77, 1.000),
                                      ), // Increase font size as you need
                                    ),
                                    Text(
                                      lastMessage == null
                                          ? 'No hay mensajes'
                                          : '$lastMessage (${lastMessageTime.toString()})',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.02,
                                      ), // Increase font size as you need
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Añade un espacio
                          Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 0.6,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
 */