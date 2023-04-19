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

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot messageDoc) {
                    bool isCurrentUser =
                        messageDoc['userId'] == widget.currentUser.id;
                    return ListTile(
                      title: Text(messageDoc['text']),
                      subtitle: Text(messageDoc['timestamp'].toDate().toString()),
                      trailing: isCurrentUser ? Icon(Icons.person) : null,
                    );
                  }).toList(),
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


