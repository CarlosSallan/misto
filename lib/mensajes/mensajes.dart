import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user.dart';
export 'package:misto/mensajes/mensajes.dart' show _getLastMessageAndTime;


class mensajes extends StatefulWidget {
  final Usuario currentUser;
  final DocumentSnapshot friendUser;

  mensajes({required this.currentUser, required this.friendUser});

  @override
  _mensajes createState() => _mensajes();
}

class _mensajes extends State<mensajes> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _chatsCollection =
  FirebaseFirestore.instance.collection('chats');

  String _getChatId() {
    return widget.currentUser.id.compareTo(widget.friendUser.id) < 0
        ? '${widget.currentUser.id}-${widget.friendUser.id}'
        : '${widget.friendUser.id}-${widget.currentUser.id}';
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Crear un chatId único para la conversación entre dos usuarios
    String chatId = widget.currentUser.id.compareTo(widget.friendUser.id) < 0
        ? '${widget.currentUser.id}-${widget.friendUser.id}'
        : '${widget.friendUser.id}-${widget.currentUser.id}';

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
      appBar: AppBar(
        title: Text('Chat con ${widget.friendUser['FullName']}'),
      ),
      body: Column(
        children: [
          Expanded(
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
                              ? Colors.blueAccent
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
          Container(
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


