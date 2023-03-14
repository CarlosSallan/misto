import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Stream<DocumentSnapshot> _userStream;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _userStream =
        FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          String? name = data?['Nombre'];
          String? email = user?.email;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name', style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 16.0),
                Text('Email: $email', style: TextStyle(fontSize: 24.0)),
              ],
            ),
          );
        },
      ),
    );
  }
}