import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> addUser(User? user) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  print("Ejecutando addUser");
  CollectionReference users = firestore.collection('Users');

  //Conseguimos el nombre
  String nombre = user?.displayName ?? "Usuario";
  for(int i=0; i<nombre.length ; i++) {
    var char = nombre[i];
    if(char == ' '){
      nombre = nombre.substring(0, i);
    }
  }

  // Call the user's CollectionReference to add a new user
  return users.doc(user?.uid).set({
    'FullName': nombre,
    'Creado': new DateTime.now(),
    'Amigos': [],

  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
/*
Future<void> addAmigoForUser(User? user) {
  print("Creando nueva colección para usuario ${user?.uid}");
  CollectionReference userCollection = FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('myCollection');
  // Luego puedes agregar documentos a la nueva colección como lo harías en cualquier otra colección de Firestore:
  return userCollection.add({
    'createdAt': FieldValue.serverTimestamp(),
  }).then((value) => print("Documento agregado a Amigos"))
      .catchError((error) => print("Error al agregar documento a myCollection: $error"));
}
*/