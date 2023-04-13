import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';

class seguirUsers extends StatefulWidget {
  seguirUsers({Key? key}) : super(key: key);

  @override
  State<seguirUsers> createState() => _seguirUsersState();
}

class _seguirUsersState extends State<seguirUsers> {
  Stream<List<User>> userStream() {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final fullName = doc.data()['FullName'] as String;
        return User(fullName, false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<User>>(
          stream: userStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Text(user.FullName);
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        )
    );
  }
}
