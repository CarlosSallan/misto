import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> addUser(User? user, String nombre) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("Ejecutando addUser");
  CollectionReference users = firestore.collection('Users');

  String nombre2;

  if (nombre == "") {
    nombre2 = user?.displayName ?? "Usuario";

    for (int i = 0; i < nombre2.length; i++) {
      var char = nombre2[i];
      if (char == ' ') {
        nombre = nombre2.substring(0, i);
      }
    }
  }
  //Conseguimos el nombre

  // Call the user's CollectionReference to add a new user
  return users.doc(user?.uid).set({
    'FullName': nombre,

  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<void> addAmistad(User? user) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("Ejecutando addUser");
  CollectionReference users = firestore.collection('Amistad');

  List<String> ArrayAmigos = [];
  List<String> ArraySoli = [];

  // Call the user's CollectionReference to add a new user
  return users.doc(user?.uid).set({
    'ArrayAmigos': ArrayAmigos,
    'ArraySoli': ArraySoli,

  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<bool> checkAmigosDoc(User? user) async {
  print("Comprobando si tiene doc Amigos");
  final snapShot = await FirebaseFirestore.instance.collection('Amistad').doc(
      user?.uid).get();
  if(snapShot.exists){
    return true;
  }else{
    return false;
  }
}

Future<List<String>?> getAllUserUIDs() async {
  List<String> uids = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        'Users').get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      uids.add(doc.id);
    }
    for (var value in uids) {
      print("UID == $value");
    }
    return uids;
  } catch (e) {
    print(e.toString());
    return null;
  }
}