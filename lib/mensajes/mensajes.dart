import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user.dart';
import 'friends_screen.dart';
export 'package:misto/mensajes/mensajes.dart' show _getLastMessageAndTime;


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
                _top(),
                Spacer(),
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
                      bool isCurrentUser =
                          messageDoc['userId'] == widget.currentUser.id;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(
                            top: 4.0,
                            bottom: 4.0,
                            left: isCurrentUser ? 50.0 : 8.0,
                            right: isCurrentUser ? 8.0 : 50.0,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Color.fromRGBO(22,53,77,1.000)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageDoc['text'],
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                messageDoc['timestamp']
                                    .toDate()
                                    .toString(),
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7),
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
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
          ],
        ),
      ),
    );
  }




  Widget _top() {
    Usuario currentUser = widget.currentUser;
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Habla con \ntus amigos',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),

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


