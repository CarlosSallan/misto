import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main_screen/main_screen.dart';
import '../user.dart';
import 'friends_screen.dart';
export 'package:misto/mensajes/mensajes.dart' show _getLastMessageAndTime;
import '../user.dart' as UsuarioLogin;

class mensajes extends StatefulWidget {
  final Usuario currentUser;
  final String UidAmigo;

  mensajes({required this.currentUser, required this.UidAmigo});

  @override
  _mensajes createState() => _mensajes();
}

class _mensajes extends State<mensajes> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _chatsCollection =
  FirebaseFirestore.instance.collection('chats');
  get child => null;

  Future<String?> _getUserAvatar(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userDoc['Avatar'] as String?;
  }


  String _getChatId() {
    return widget.currentUser.id.compareTo(widget.UidAmigo) < 0
        ? '${widget.currentUser.id}-${widget.UidAmigo}'
        : '${widget.UidAmigo}-${widget.currentUser.id}';
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Crear un chatId único para la conversación entre dos usuarios
    String chatId = widget.currentUser.id.compareTo(widget.UidAmigo) < 0
        ? '${widget.currentUser.id}-${widget.UidAmigo}'
        : '${widget.UidAmigo}-${widget.currentUser.id}';

    DocumentReference chatDoc = _chatsCollection.doc(chatId);

    await chatDoc.collection('messages').add({
      'text': message.trim(),
      'timestamp': Timestamp.now(),
      'userId': widget.currentUser.id,
    });

    _messageController.clear();
  }

  Future<String?> _getUserFullName(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userDoc['FullName'] as String?;
  }


  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _messagesStream = _chatsCollection
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return Scaffold(
      backgroundColor: Color.fromRGBO(22,53,77,1.000),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                _top(context),
                Spacer(),
                FutureBuilder<String?>(
                  future: _getUserAvatar(widget.UidAmigo), // Pasamos el UidAmigo para obtener el avatar
                  builder: (BuildContext context, AsyncSnapshot<String?> avatarSnapshot) {
                    if (avatarSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga la imagen
                    }

                    return FutureBuilder<String?>(
                        future: _getUserFullName(widget.UidAmigo), // Pasamos el UidAmigo para obtener el nombre completo
                        builder: (BuildContext context, AsyncSnapshot<String?> fullNameSnapshot) {
                          if (fullNameSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga el nombre
                          }

                          return Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03,), // adjust this value as per your need
                                  child: Text(
                                    fullNameSnapshot.data ?? 'Usuario',
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8.0), // Add some spacing between the text and the image
                                ClipOval(
                                  child: avatarSnapshot.data != null
                                      ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        avatarSnapshot.data!),
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
                          );
                        }
                    );
                  },
                ),

              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                  color: Colors.white,
                ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot messageDoc = snapshot.data!.docs[index];
                      bool isCurrentUser = messageDoc['userId'] == widget.currentUser.id;

                      return FutureBuilder<String?>(
                        future: _getUserAvatar(messageDoc['userId']),
                        builder: (BuildContext context, AsyncSnapshot<String?> avatarSnapshot) {
                          if (avatarSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return Row(
                            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              if (!isCurrentUser) // Si no es el usuario actual, mostramos el avatar
                                CircleAvatar(
                                  backgroundImage: NetworkImage(avatarSnapshot.data ?? 'URL_por_defecto'), // Coloca una URL por defecto en caso de que no exista una imagen de perfil para el usuario
                                  radius: MediaQuery.of(context).size.height * 0.017, // Ajusta el tamaño según prefieras
                                ),
                              SizedBox(width: 8), // Espacio entre el avatar y el mensaje
                              Align(
                                alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: isCurrentUser ? 50.0 : 8.0,
                                    right: isCurrentUser ? 8.0 : 50.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser ? Color.fromRGBO(22,53,77,1.000) : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messageDoc['text'],
                                        style: TextStyle(
                                          color: isCurrentUser ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                      Text(
                                        messageDoc['timestamp'].toDate().toString(),
                                        style: TextStyle(
                                          color: isCurrentUser ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                                          fontSize: MediaQuery.of(context).size.height * 0.01,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isCurrentUser) // Si es el usuario actual, mostramos el avatar
                                CircleAvatar(
                                  backgroundImage: NetworkImage(avatarSnapshot.data ?? 'URL_por_defecto'), // Coloca una URL por defecto en caso de que no exista una imagen de perfil para el usuario
                                  radius: MediaQuery.of(context).size.height * 0.017, // Ajusta el tamaño según prefieras
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
            ),
            Container(  // Nuevo contenedor aquí
              color: Colors.white,  // Esto cambiará el color de fondo a blanco
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                    size: MediaQuery.of(context).size.height * 0.04,
                    color: Color.fromRGBO(22, 53, 77, 1.000),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => main_screen(currentUser: widget.currentUser)
                    ),
                  ),
                  iconSize: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.025,),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
        ],
      ),
    );
  }


  Future<Map<String, dynamic>?> _getLastMessageAndTime(String chatId) async {
    QuerySnapshot querySnapshot = await _chatsCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return {
        'text': doc['text'],
        'timestamp': doc['timestamp'].toDate(),
      };
    }
    return null;
  }
}