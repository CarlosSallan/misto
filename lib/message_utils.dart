import 'package:cloud_firestore/cloud_firestore.dart';

Stream<Map<String, dynamic>?> getLastMessageAndTime(String chatId) {
  final CollectionReference _chatsCollection =
  FirebaseFirestore.instance.collection('chats');

  return _chatsCollection
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) {
      return null;
    }

    return {
      'text': snapshot.docs.first['text'],
      'timestamp': snapshot.docs.first['timestamp'],
    };
  });
}
